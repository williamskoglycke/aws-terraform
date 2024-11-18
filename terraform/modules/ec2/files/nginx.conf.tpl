events {
    worker_connections 1024;  # You can adjust this value as needed
}

http {
    server {
        listen 80;
        server_name ${domain_name};

        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }

        location / {
            return 301 https://$host$request_uri;
        }
    }
    server {
        listen 443 ssl;
        server_name ${domain_name};

        ssl_certificate /etc/letsencrypt/live/${domain_name}/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/${domain_name}/privkey.pem;

        location / {
            resolver 127.0.0.11 valid=30s;
            set $frontend frontend;
            proxy_pass http://$frontend:3000;
        }
    }
}