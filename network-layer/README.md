# Network Layer

## Purpose

The network layer provisions the foundational AWS networking required by the rest of the platform in both the primary and standby regions. It is responsible for:

- creating one VPC per region
- carving each VPC into public, private application, and private database subnets across two Availability Zones
- attaching internet gateways
- deploying one NAT instance per region
- creating and associating route tables
- establishing cross-region VPC peering
- creating S3 gateway VPC endpoints
- creating security groups and security group rules for public, application, and private/database tiers
- publishing network metadata to AWS Systems Manager Parameter Store for downstream layers

This layer is the shared connectivity substrate for the ALB, application, database, storage, IAM, and jobs layers.

## Directory Layout

`network-layer/` is the root Terraform stack for networking.

- [main.tf](/terraform-aws-multi-region-ha/network-layer/main.tf): calls the reusable `modules/network` orchestration module
- [variables.tf](/terraform-aws-multi-region-ha/network-layer/variables.tf): root inputs
- [providers.tf](/terraform-aws-multi-region-ha/network-layer/providers.tf): primary and standby AWS provider configurations
- [locals.tf](/terraform-aws-multi-region-ha/network-layer/locals.tf): shared tag model and normalized environment
- [outputs.tf](/terraform-aws-multi-region-ha/network-layer/outputs.tf): exported values for operators and other stacks
- [ssm.tf](/terraform-aws-multi-region-ha/network-layer/ssm.tf): publishes network outputs to SSM Parameter Store
- [versions.tf]: Terraform and provider constraints

`modules/network/` is the reusable internal module that composes the lower-level networking submodules.

## Provider Model

This stack uses two AWS provider configurations:

- the default `aws` provider targets the primary region
- the aliased `aws.standby_region_aws` provider targets the standby region

See [providers.tf](/terraform-aws-multi-region-ha/network-layer/providers.tf).

This is what enables a single Terraform root module to manage resources in two regions at once. Resources intended for the standby region explicitly declare `provider = aws.standby_region_aws` inside the child modules.

The provider block also applies `default_tags`, so all supported AWS resources inherit the baseline network tags:

- `Project`
- `ManagedBy = Terraform`
- `Layer = network`
- `Environment`
- `RegionRole = primary|standby`

## Version Constraints

The root network layer pins:

- Terraform: `>= 1.5.0, < 2.0.0`
- AWS provider: `~> 6.0`

See [versions.tf](/terraform-aws-multi-region-ha/network-layer/versions.tf).

The child modules under `modules/network/` also declare their own `required_providers` and `configuration_aliases` so Terraform knows they expect both the default AWS provider and the standby alias.

## High-Level Architecture

Per region, this layer creates:

- 1 VPC
- 6 subnets
- 2 route tables
- 1 internet gateway
- 1 NAT instance
- 1 NAT security group
- 3 workload-facing security groups
- 1 S3 gateway VPC endpoint

Across regions, it also creates:

- 1 VPC peering connection
- bidirectional private route entries over the peering connection

## Module Composition

The root stack delegates almost all infrastructure creation to [modules/network/main.tf](/terraform-aws-multi-region-ha/modules/network/main.tf).

That orchestration module composes these child modules in order:

1. `vpcs`
2. `subnets`
3. `gateways`
4. `rttables`
5. `routes`
6. `peering`
7. `endpoints`
8. `associations`
9. `security_groups`
10. `security_group_rules`

The dependency flow is mostly data-driven through outputs:

- VPC IDs feed subnets, gateways, route tables, peering, endpoints, and security groups
- subnet outputs feed NAT placement and route table associations
- NAT network interfaces and IGWs feed route creation
- route table outputs feed endpoints, associations, and peering
- security group IDs feed security group rules

## Detailed Resource Design

### 1. VPCs

The `vpcs` submodule creates one VPC in each region with:

- `enable_dns_support = true`
- `enable_dns_hostnames = true`

See [modules/network/vpcs/main.tf](/terraform-aws-multi-region-ha/modules/network/vpcs/main.tf).

### 2. Subnet Topology

The subnet plan is defined in [modules/network/subnets/locals.tf](/terraform-aws-multi-region-ha/modules/network/subnets/locals.tf).

Each VPC is split into six subnets:

- `public_az1`
- `public_az2`
- `private_app1`
- `private_app2`
- `private_db1`
- `private_db2`

Subnet CIDRs are derived from the VPC CIDR using `cidrsubnet(..., 8, cidr_index)`, which means each subnet is created by adding 8 bits to the VPC mask. For a `/16` VPC, this produces `/24` subnets.

Current CIDR slot allocation per VPC:

- public subnets: indexes `1`, `2`
- private application subnets: indexes `11`, `12`
- private database subnets: indexes `21`, `22`

Availability Zones are selected dynamically from `data.aws_availability_zones`.

Public subnets set `map_public_ip_on_launch = true`.

See [modules/network/subnets/main.tf](/terraform-aws-multi-region-ha/modules/network/subnets/main.tf).

### 3. Internet Egress Model

This stack uses NAT instances, not managed NAT gateways.

That choice is implemented in [modules/network/gateways/main.tf](/terraform-aws-multi-region-ha/modules/network/gateways/main.tf):

- one internet gateway per region
- one EC2 instance per region acting as a NAT host
- one dedicated NAT security group per region

The NAT instance:

- uses the latest AL2023 AMI from SSM
- disables source/destination checks
- gets a public IP
- runs `user_data` that enables IPv4 forwarding and configures `nftables` masquerading

Important implementation detail:

- only `public_az1` in each region is used to host the NAT instance
- both private subnets in the region route through that single NAT instance

This is simpler and cheaper than per-AZ NAT, but it is not AZ-redundant for outbound private egress.

### 4. Route Tables

The `rttables` submodule creates two route tables per region:

- `public`
- `private`

See [modules/network/rttables/locals.tf](/terraform-aws-multi-region-ha/modules/network/rttables/locals.tf) and [modules/network/rttables/main.tf](/terraform-aws-multi-region-ha/modules/network/rttables/main.tf).

### 5. Route Configuration

The `routes` submodule creates default routes:

- public route table `0.0.0.0/0` -> internet gateway
- private route table `0.0.0.0/0` -> NAT instance primary network interface

See [modules/network/routes/main.tf](/terraform-aws-multi-region-ha/modules/network/routes/main.tf).

### 6. Route Table Associations

The `associations` submodule associates each subnet with either the public or private route table based on `map_public_ip_on_launch`.

Association logic:

- public subnet -> public route table
- non-public subnet -> private route table

See [modules/network/associations/main.tf](/terraform-aws-multi-region-ha/modules/network/associations/main.tf).

### 7. VPC Peering

The `peering` submodule creates cross-region connectivity between the two VPCs:

- primary-side VPC peering request
- standby-side accepter
- DNS resolution enabled on requester and accepter
- a private route in each region pointing to the peer VPC CIDR

See [modules/network/peering/main.tf](/terraform-aws-multi-region-ha/modules/network/peering/main.tf).

Traffic enabled by this design includes:

- primary application tier reaching the standby database network CIDR
- standby application tier reaching the primary database network CIDR
- more generally, routed IP connectivity between both VPC CIDR ranges

### 8. S3 Gateway Endpoints

The `endpoints` submodule creates one S3 gateway VPC endpoint per region and attaches it to the private route table.

See [modules/network/endpoints/main.tf](/terraform-aws-multi-region-ha/modules/network/endpoints/main.tf).

This allows private subnets to reach S3 without traversing internet egress for S3 traffic.

### 9. Security Group Model

The `security_groups` submodule creates three workload-oriented security groups per region:

- public security group
- private security group
- application security group

See [modules/network/security_groups/main.tf](/terraform-aws-multi-region-ha/modules/network/security_groups/main.tf).

The `security_group_rules` submodule then applies the traffic policy:

- public inbound rules come from the configurable `public_inbound_rules` map
- application inbound allows `application_port` from the public security group
- private inbound allows TCP `0-65535` from the application security group
- private/database ingress also allows `database_port` from the peer VPC CIDR
- public, private, and application security groups all allow full outbound egress

See [modules/network/security_group_rules/main.tf](/terraform-aws-multi-region-ha/modules/network/security_group_rules/main.tf) and [modules/network/security_group_rules/locals.tf](/terraform-aws-multi-region-ha/modules/network/security_group_rules/locals.tf).

## Traffic Flow Summary

### Inbound Internet Traffic

1. Internet traffic reaches public subnets through the internet gateway.
2. Public security group ingress is controlled by `public_inbound_rules`.
3. The application security group accepts `application_port` traffic only from the public security group.

### Private Subnet Outbound Traffic

1. Private application and private database subnets use the private route table.
2. The private route table sends `0.0.0.0/0` to the NAT instance network interface.
3. The NAT instance forwards and masquerades traffic through its public interface.

### S3 Access from Private Subnets

1. Private subnets use the private route table.
2. The private route table is attached to the S3 gateway endpoint.
3. S3 traffic resolves to the regional S3 endpoint path without general internet traversal.

### Cross-Region Database Reachability

1. Private route tables include routes to the opposite VPC CIDR through the VPC peering connection.
2. Private security groups allow `database_port` from the peer VPC CIDR.
3. This enables cross-region application-to-database connectivity.

## Inputs

Root inputs are declared in [network-layer/variables.tf](/terraform-aws-multi-region-ha/network-layer/variables.tf).

Key inputs:

- `project_name`: naming prefix and SSM namespace prefix
- `environment`: environment label; normalized to lowercase before being passed to the child module
- `additional_tags`: merged into default resource tags
- `primary_region_aws`
- `standby_region_aws`
- `primary_vpc_name`
- `primary_vpc_cidr`
- `standby_vpc_name`
- `standby_vpc_cidr`
- `public_inbound_rules`: map of ingress rules for the public SG
- `nat_instance_type`: EC2 instance type for NAT hosts, default `t3.nano`
- `database_port`: port opened across regions for DB access

`modules/network/variables.tf` also defines:

- `application_port`: port used by application traffic from public to app SG, default `80`

This is not exposed by the root stack today, so the network layer currently always uses the child module default unless the root module is updated to pass it through explicitly.

## Outputs

The root stack exports:

- VPC IDs
- subnet maps
- public/private/application security group IDs
- public/private route table IDs
- internet gateway IDs
- S3 VPC endpoint IDs

See [network-layer/outputs.tf](/terraform-aws-multi-region-ha/network-layer/outputs.tf).

The composed module additionally exposes:

- NAT instance IDs
- NAT network interface IDs
- VPC peering connection ID
- VPC peering status

See [modules/network/outputs.tf](/terraform-aws-multi-region-ha/modules/network/outputs.tf).

## SSM Parameter Store Contract

This layer persists its outputs to SSM so downstream layers can discover networking resources without direct remote-state coupling.

SSM parameters are written in [network-layer/ssm.tf](/terraform-aws-multi-region-ha/network-layer/ssm.tf).

Published categories include:

- VPC IDs
- subnet IDs by logical subnet name
- route table IDs by logical type
- internet gateway IDs
- NAT instance IDs
- VPC peering connection ID
- security group IDs

Path pattern examples:

```text
/${project_name}/${environment}/network/primary/primary_vpc_id
/${project_name}/${environment}/network/primary/subnets/public_az1/id
/${project_name}/${environment}/network/primary/route_tables/private/id
/${project_name}/${environment}/network/standby/application_sg_id
/${project_name}/${environment}/network/vpc_peering_connection_id
```

This makes the network layer a discovery source for:

- ALB layer subnet and SG lookups
- application layer subnet and SG lookups
- database layer subnet and private SG lookups
- any failover or jobs logic that needs network metadata

## Resource Naming

Representative naming patterns used in this layer:

- VPCs: caller-provided names
- subnets: the subnet submodule is designed to use `${project_name}-${environment}-{primary|standby}-{logical-subnet-name}-subnet`
- IGWs: `igw-primary`, `igw-standby`
- NAT security groups: `nat-primary-sg`, `nat-standby-sg`
- NAT instances: `nat-primary`, `nat-standby`
- route tables: `rt-public-rt`, `rt-private-rt`
- peering: `${project_name}-${environment}-primary-standby-peering`
- S3 endpoints: `s3-endpoint-primary`, `s3-endpoint-standby`
- workload security groups: `primary-public-sg`, `primary-private-sg`, `primary-application-sg`, and standby equivalents

## Operational Notes

Important implementation characteristics of the current design:

- This is a dual-region design, not a single-region network with recovery artifacts.
- It uses NAT instances rather than managed NAT gateways.
- It places one NAT instance per region in `public_az1`, so private egress in that region depends on a single AZ-local NAT host.
- It uses one public and one private route table per region, not per subnet or per AZ.
- Cross-region reachability is enabled only through the peering routes and SG rules that are explicitly defined here.
- SSM Parameter Store is the integration mechanism for downstream stacks.

## Deployment Flow

Typical execution flow:

1. Configure `terraform.tfvars` with VPC names, CIDRs, regions, ingress rules, and DB port.
2. Initialize the layer.
3. Plan and apply the network stack.
4. Confirm outputs and SSM parameters are created.
5. Deploy dependent layers that consume the published SSM paths.

## Current Gaps and Considerations

Based on the current implementation:

- `application_port` exists in the child module but is not exposed at the root layer, so it is effectively fixed to the module default unless the root stack is extended.
- the `subnets` child module expects `project_name` and `environment` for subnet naming, but the current `modules/network/main.tf` orchestration file does not pass those inputs through yet.
- Route table names are generic and do not currently include project or environment context.
- SSM parameters in this layer are published without explicit custom tags.
- NAT high availability is regional but not AZ-resilient because each region uses a single NAT instance.

These are not necessarily defects, but they are important design assumptions to understand before extending the layer.
