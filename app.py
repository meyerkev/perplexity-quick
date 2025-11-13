#!/usr/bin/env python3
"""
Simple Python web server using Flask and requests.
"""

from flask import Flask, jsonify, request
import requests

app = Flask(__name__)

@app.route('/')
def home():
    """Home endpoint that returns a welcome message."""
    return jsonify({
        'message': 'Welcome to the Simple Python Web Server',
        'status': 'running'
    })

@app.route('/health')
def health():
    """Health check endpoint."""
    return jsonify({'status': 'healthy'})

@app.route('/fetch', methods=['GET'])
def fetch_url():
    """
    Fetch a URL using the requests library.
    Usage: /fetch?url=https://example.com
    """
    url = request.args.get('url')
    if not url:
        return jsonify({'error': 'Missing url parameter'}), 400
    
    try:
        response = requests.get(url, timeout=5)
        return jsonify({
            'url': url,
            'status_code': response.status_code,
            'content_length': len(response.content),
            'headers': dict(response.headers)
        })
    except requests.exceptions.RequestException as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)

