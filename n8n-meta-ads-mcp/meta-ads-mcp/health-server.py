#!/usr/bin/env python3

import http.server
import socketserver
import threading
import json
import os
import sys
from urllib.parse import urlparse

class HealthHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            health_data = {
                "status": "healthy",
                "service": "meta-ads-mcp",
                "version": "1.0.0",
                "meta_app_id": os.environ.get('META_APP_ID', 'not-set'),
                "timestamp": self._get_timestamp()
            }
            
            self.wfile.write(json.dumps(health_data, indent=2).encode())
            
        elif self.path == '/status':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            
            status_data = {
                "mcp_server": "running",
                "environment": {
                    "META_APP_ID": "configured" if os.environ.get('META_APP_ID') else "missing",
                    "META_ACCESS_TOKEN": "configured" if os.environ.get('META_ACCESS_TOKEN') else "not-provided"
                }
            }
            
            self.wfile.write(json.dumps(status_data, indent=2).encode())
            
        else:
            self.send_response(404)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            error_data = {"error": "Not found", "path": self.path}
            self.wfile.write(json.dumps(error_data).encode())
    
    def _get_timestamp(self):
        from datetime import datetime
        return datetime.utcnow().isoformat() + 'Z'
    
    def log_message(self, format, *args):
        # Suppress default logging to reduce noise
        pass

def start_health_server():
    """Start the health check HTTP server"""
    port = 3001
    handler = HealthHandler
    
    try:
        with socketserver.TCPServer(("", port), handler) as httpd:
            print(f"🏥 Health server running on port {port}")
            httpd.serve_forever()
    except Exception as e:
        print(f"❌ Failed to start health server: {e}")
        sys.exit(1)

if __name__ == "__main__":
    start_health_server()