import json
import os
import socket
import subprocess
import tempfile
import urllib.request
from datetime import datetime, timezone
from html import escape
from http.server import BaseHTTPRequestHandler, HTTPServer

APP_PORT = int(os.environ["APP_PORT"])
AWS_REGION = os.environ["AWS_REGION"]
DATA_BUCKET = os.environ["DATA_BUCKET"]
DB_ENDPOINT = os.environ["DB_ENDPOINT"]
DB_PORT = int(os.environ["DB_PORT"])
ENVIRONMENT = os.environ["ENVIRONMENT"]
HEALTH_CHECK_PATH = os.environ["HEALTH_CHECK_PATH"]
READINESS_CHECK_PATH = os.environ.get("READINESS_CHECK_PATH", "/readiness")
PROJECT_NAME = os.environ["PROJECT_NAME"]
REGION_LABEL = os.environ["REGION_LABEL"]
HOSTNAME = socket.gethostname()
DEFAULT_HEALTH_PATH = "/health"
DEFAULT_READINESS_PATH = "/readiness"


def normalized_health_path():
    path = (HEALTH_CHECK_PATH or "").strip()
    if not path:
        return DEFAULT_HEALTH_PATH
    if not path.startswith("/"):
        path = f"/{path}"
    if path == "/":
        return DEFAULT_HEALTH_PATH
    return path


def normalized_readiness_path():
    path = (READINESS_CHECK_PATH or "").strip()
    if not path:
        return DEFAULT_READINESS_PATH
    if not path.startswith("/"):
        path = f"/{path}"
    if path == "/":
        return DEFAULT_READINESS_PATH
    return path


def run_command(command):
    try:
        completed = subprocess.run(
            command,
            check=True,
            capture_output=True,
            text=True,
            timeout=8,
        )
        return True, completed.stdout.strip() or completed.stderr.strip() or "ok"
    except Exception as exc:
        return False, str(exc)


def get_metadata(path):
    try:
        token_request = urllib.request.Request(
            "http://169.254.169.254/latest/api/token",
            method="PUT",
            headers={"X-aws-ec2-metadata-token-ttl-seconds": "21600"},
        )
        token = urllib.request.urlopen(token_request, timeout=2).read().decode()
        metadata_request = urllib.request.Request(
            f"http://169.254.169.254/latest/{path}",
            headers={"X-aws-ec2-metadata-token": token},
        )
        return urllib.request.urlopen(metadata_request, timeout=2).read().decode()
    except Exception as exc:
        return f"unavailable: {exc}"


def check_db():
    try:
        with socket.create_connection((DB_ENDPOINT, DB_PORT), timeout=3):
            return {"ok": True, "message": "reachable"}
    except Exception as exc:
        return {"ok": False, "message": str(exc)}


def check_s3():
    key = f"runtime/{REGION_LABEL}/{HOSTNAME}.json"
    payload = {
        "project": PROJECT_NAME,
        "environment": ENVIRONMENT,
        "region": REGION_LABEL,
        "host": HOSTNAME,
        "timestamp": datetime.now(timezone.utc).isoformat(),
    }

    with tempfile.NamedTemporaryFile("w", delete=False, encoding="utf-8") as handle:
        json.dump(payload, handle)
        temp_path = handle.name

    put_ok, put_msg = run_command(
        [
            "aws",
            "s3api",
            "put-object",
            "--bucket",
            DATA_BUCKET,
            "--key",
            key,
            "--body",
            temp_path,
            "--content-type",
            "application/json",
            "--region",
            AWS_REGION,
        ]
    )
    os.unlink(temp_path)

    list_ok, list_msg = run_command(
        [
            "aws",
            "s3api",
            "list-objects-v2",
            "--bucket",
            DATA_BUCKET,
            "--max-items",
            "5",
            "--region",
            AWS_REGION,
        ]
    )

    objects = []
    if list_ok and list_msg:
        try:
            parsed = json.loads(list_msg)
            objects = [item["Key"] for item in parsed.get("Contents", [])[:5]]
        except Exception:
            objects = []

    ok = put_ok and list_ok
    message = "write/read path ready" if ok else f"put={put_msg}; list={list_msg}"
    return {
        "ok": ok,
        "message": message,
        "bucket": DATA_BUCKET,
        "sample_key": key,
        "recent_objects": objects,
    }


def build_payload():
    db = check_db()
    s3 = check_s3()
    metadata = {
        "instance_id": get_metadata("meta-data/instance-id"),
        "availability_zone": get_metadata("meta-data/placement/availability-zone"),
    }
    overall_ok = db["ok"] and s3["ok"]
    return {
        "status": "ok" if overall_ok else "degraded",
        "project": PROJECT_NAME,
        "environment": ENVIRONMENT,
        "region": REGION_LABEL,
        "aws_region": AWS_REGION,
        "host": HOSTNAME,
        "time": datetime.now(timezone.utc).isoformat(),
        "metadata": metadata,
        "database": {
            "endpoint": DB_ENDPOINT,
            "port": DB_PORT,
            **db,
        },
        "storage": s3,
    }


def status_badge(ok):
    return "healthy" if ok else "attention"


def html_page(payload):
    db = payload["database"]
    storage = payload["storage"]
    metadata = payload["metadata"]
    payload_json = escape(json.dumps(payload, indent=2))
    recent = "".join(f"<li>{escape(item)}</li>" for item in storage["recent_objects"]) or "<li>No objects yet</li>"

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{escape(PROJECT_NAME)} Multi-Region Portal</title>
  <style>
    :root {{
      --bg: #07111f;
      --panel: rgba(9, 20, 38, 0.88);
      --line: rgba(148, 163, 184, 0.20);
      --text: #e5eefb;
      --muted: #9db3cb;
      --good: #4ade80;
      --warn: #f59e0b;
      --accent: #38bdf8;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      font-family: "Segoe UI", sans-serif;
      background:
        radial-gradient(circle at top left, rgba(56, 189, 248, 0.22), transparent 28rem),
        radial-gradient(circle at top right, rgba(74, 222, 128, 0.18), transparent 24rem),
        linear-gradient(160deg, #030712, var(--bg));
      color: var(--text);
    }}
    .wrap {{ max-width: 1100px; margin: 0 auto; padding: 32px 20px 48px; }}
    .hero {{
      background: linear-gradient(135deg, rgba(14, 165, 233, 0.18), rgba(15, 23, 42, 0.92));
      border: 1px solid var(--line);
      border-radius: 24px;
      padding: 28px;
      box-shadow: 0 24px 60px rgba(2, 8, 23, 0.45);
    }}
    .eyebrow {{ color: var(--accent); text-transform: uppercase; letter-spacing: 0.18em; font-size: 12px; }}
    h1 {{ margin: 10px 0 8px; font-size: 40px; }}
    p {{ color: var(--muted); line-height: 1.6; }}
    .grid {{
      display: grid;
      gap: 16px;
      margin-top: 20px;
      grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    }}
    .card {{
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 18px;
      padding: 18px;
      backdrop-filter: blur(10px);
    }}
    .label {{ color: var(--muted); font-size: 13px; text-transform: uppercase; letter-spacing: 0.12em; }}
    .value {{ margin-top: 10px; font-size: 20px; font-weight: 600; word-break: break-word; }}
    .badge {{
      display: inline-flex;
      margin-top: 12px;
      padding: 6px 10px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 0.08em;
    }}
    .healthy {{ background: rgba(74, 222, 128, 0.16); color: var(--good); }}
    .attention {{ background: rgba(245, 158, 11, 0.16); color: var(--warn); }}
    pre {{
      overflow: auto;
      padding: 16px;
      background: rgba(2, 6, 23, 0.75);
      border-radius: 16px;
      border: 1px solid var(--line);
      color: #cbd5e1;
    }}
    ul {{ margin: 10px 0 0; padding-left: 18px; color: var(--muted); }}
  </style>
</head>
<body>
  <div class="wrap">
    <section class="hero">
      <div class="eyebrow">Resume Infrastructure Demo</div>
      <h1>{escape(PROJECT_NAME)} control surface</h1>
      <p>
        This page is served from the {escape(REGION_LABEL)} application stack and surfaces the runtime
        health of the instance, cross-layer database wiring, and private S3 access through the VPC endpoint path.
      </p>
      <div class="grid">
        <div class="card">
          <div class="label">Overall status</div>
          <div class="value">{escape(payload["status"].upper())}</div>
          <span class="badge {status_badge(payload["status"] == "ok")}">{escape(payload["status"])}</span>
        </div>
        <div class="card">
          <div class="label">Region / AZ</div>
          <div class="value">{escape(payload["aws_region"])} / {escape(metadata["availability_zone"])}</div>
        </div>
        <div class="card">
          <div class="label">Instance</div>
          <div class="value">{escape(metadata["instance_id"])}</div>
        </div>
        <div class="card">
          <div class="label">Host / Time</div>
          <div class="value">{escape(payload["host"])}</div>
          <p>{escape(payload["time"])}</p>
        </div>
      </div>
    </section>

    <section class="grid">
      <article class="card">
        <div class="label">Database connectivity</div>
        <div class="value">{escape(db["endpoint"])}:{db["port"]}</div>
        <span class="badge {status_badge(db["ok"])}">{'connected' if db["ok"] else 'check path'}</span>
        <p>{escape(db["message"])}</p>
      </article>
      <article class="card">
        <div class="label">S3 private access</div>
        <div class="value">{escape(storage["bucket"])}</div>
        <span class="badge {status_badge(storage["ok"])}">{'active' if storage["ok"] else 'check IAM or endpoint'}</span>
        <p>{escape(storage["message"])}</p>
      </article>
      <article class="card">
        <div class="label">Recent objects</div>
        <div class="value">{escape(storage["sample_key"])}</div>
        <ul>{recent}</ul>
      </article>
    </section>

    <section class="card" style="margin-top: 20px;">
      <div class="label">Live payload</div>
      <pre>{payload_json}</pre>
    </section>
  </div>
</body>
</html>"""


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        payload = build_payload()
        health_path = normalized_health_path()
        readiness_path = normalized_readiness_path()
        if self.path == health_path:
            body = json.dumps(payload).encode("utf-8")
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return

        if self.path == readiness_path:
            body = json.dumps(payload).encode("utf-8")
            self.send_response(200 if payload["status"] == "ok" else 503)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return

        body = html_page(payload).encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):
        return


HTTPServer(("0.0.0.0", APP_PORT), Handler).serve_forever()
