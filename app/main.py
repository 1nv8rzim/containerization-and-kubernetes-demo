import socket
from flask import Flask

app = Flask(__name__)

@app.route('/')
def get_hostname():
    hostname = socket.gethostname()
    return f"Hostname: {hostname}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)