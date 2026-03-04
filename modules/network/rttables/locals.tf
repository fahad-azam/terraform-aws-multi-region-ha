locals {
    rt_tables = {
        public = { is_public = true , suffix = "public-rt" }
        private = { is_public = false , suffix = "private-rt"}
    }
}