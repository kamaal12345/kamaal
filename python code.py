"""
Intentionally vulnerable Python/Flask app for SonarQube testing.
DO NOT deploy in production. Use only in isolated/local test environments.

Included insecure patterns (for scanners to detect):
- Hardcoded credentials/secrets
- Weak crypto (MD5), insecure random for tokens
- SQL Injection (string concatenation)
- Command Injection (subprocess with shell=True)
- Path Traversal (user-controlled file path)
- Dangerous eval()
- Insecure deserialization (pickle)
- Unsafe YAML load (yaml.load without Loader)
- Open Redirect
- HTTP request with TLS verification disabled
- Sensitive data logged/printed
- Flask debug mode enabled
- Overly permissive file permissions (0o777)
"""

from flask import Flask, request, redirect, jsonify
import os
import sqlite3
import subprocess
import hashlib
import pickle
import yaml
import requests
import random
import string

app = Flask(__name__)

# Hardcoded secret key (sensitive)
app.secret_key = "super-secret-key-please-dont-hardcode"  # Noncompliant: hardcoded secret

# Hardcoded credentials (for demo only)
HARDCODED_DB_USER = "admin"  # Noncompliant: hardcoded credential
HARDCODED_DB_PASS = "P@ssw0rd123"  # Noncompliant: hardcoded credential

DB_PATH = "test.db"


def init_db():
    # Initialize a local sqlite DB for the demo (not secure). Passwords stored with MD5.
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    cur.execute(
        "CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, username TEXT, password TEXT)"
    )
    # Insert a demo user (username: user, password: password)
    md5_pwd = hashlib.md5("password".encode()).hexdigest()  # Noncompliant: weak hash
    cur.execute("DELETE FROM users")
    cur.execute("INSERT INTO users (username, password) VALUES (?, ?)", ("user", md5_pwd))
    conn.commit()
    conn.close()


@app.route("/")
def index():
    return "Vulnerable demo app is running. DO NOT USE IN PRODUCTION."


@app.route("/login", methods=["POST"])  # SQL Injection
def login():
    username = request.form.get("username", "")
    password = request.form.get("password", "")

    # Sensitive logging of credentials
    print(f"[DEBUG] Attempt login: {username}/{password}")  # Noncompliant: log credentials

    # Weak hash (MD5)
    pwd_hash = hashlib.md5(password.encode()).hexdigest()  # Noncompliant: weak hash

    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    # SQLi: string concatenation with user input
    query = (
        "SELECT id FROM users WHERE username='" + username + "' AND password='" + pwd_hash + "'"
    )  # Noncompliant: SQL injection
    print(f"[DEBUG] Executing query: {query}")
    cur.execute(query)  # Vulnerable
    row = cur.fetchone()
    conn.close()

    if row:
        return "Login OK"
    return "Invalid credentials", 401


@app.route("/exec")  # Command Injection
def exec_cmd():
    cmd = request.args.get("cmd", "")
    # Dangerous: shell=True with unsanitized user input
    output = subprocess.getoutput(cmd)  # Noncompliant: command injection (implicit shell)
    return f"<pre>{output}</pre>"


@app.route("/read")  # Path Traversal
def read_file():
    filename = request.args.get("file", "")
    # Vulnerable to traversal (e.g., ../../etc/passwd)
    path = os.path.join("uploads", filename)  # Noncompliant: user-controlled path
    try:
        with open(path, "r", encoding="utf-8", errors="ignore") as f:
            return f"<pre>{f.read()}</pre>"
    except Exception as e:
        return str(e), 404


@app.route("/eval")  # Dangerous eval
def eval_code():
    code = request.args.get("code", "")
    try:
        result = eval(code)  # Noncompliant: use of eval
        return str(result)
    except Exception as e:
        return str(e), 400


@app.route("/pickle", methods=["POST"])  # Insecure deserialization
def pickle_load():
    data = request.data
    obj = pickle.loads(data)  # Noncompliant: unsafe deserialization
    return jsonify({"loaded_type": str(type(obj))})


@app.route("/yaml", methods=["POST"])  # Unsafe YAML load
def yaml_load():
    body = request.data.decode("utf-8", errors="ignore")
    y = yaml.load(body, Loader=None)  # Noncompliant: unsafe loader
    return jsonify({"yaml": y})


@app.route("/redirect")  # Open Redirect
def open_redirect():
    next_url = request.args.get("next", "/")
    return redirect(next_url)  # Noncompliant: open redirect


@app.route("/insecure-request")
def insecure_request():
    url = request.args.get("url", "http://example.com")
    # TLS verification disabled
    r = requests.get(url, verify=False, timeout=5)  # Noncompliant: verify=False
    return f"Status: {r.status_code}\nBody: {r.text[:200]}"


@app.route("/token")  # Weak token generation
def token():
    # Insecure: predictable token using random instead of secrets
    t = "".join(random.choice(string.ascii_letters + string.digits) for _ in range(16))  # Noncompliant
    return t


@app.route("/upload", methods=["POST"])  # Overly permissive perms
def upload():
    f = request.files.get("file")
    if not f:
        return "No file", 400
    os.makedirs("uploads", exist_ok=True)
    path = os.path.join("uploads", f.filename)
    f.save(path)
    os.chmod(path, 0o777)  # Noncompliant: world-writable
    return "Uploaded"


if __name__ == "__main__":
    init_db()
    # Debug mode enabled, exposes stack traces
    app.run(host="0.0.0.0", port=5000, debug=True)  # Noncompliant: debug=True
