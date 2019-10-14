http {
  proxy_cache_path /tmp/nginx levels=1:2 keys_zone=STATIC:10m inactive=24h max_size=1g;
  proxy_cache_key "$scheme$request_method$host$request_uri";
  server {
    listen 80 default_server;
    charset utf-8;
    resolver 8.8.8.8 valid=10s;
    resolver_timeout 10s;
    location / {
#        proxy_pass                  ${MAGENTO_HTTP_URL};
#        proxy_set_header            Host ${MAGENTO_BASE_URL};
#        proxy_set_header            X-Real-IP       $remote_addr;
#        proxy_set_header            X-Forwarded-For $proxy_add_x_forwarded_for;
#        proxy_set_header            X-Forwarded-Proto $scheme;
        add_header                  Front-End-Https   on;
        proxy_cache                 STATIC;
        proxy_cache_valid           200  1d;
        proxy_cache_use_stale       error timeout invalid_header updating http_500 http_502 http_503 http_504;
        proxy_next_upstream         error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect              off;
        proxy_pass_request_headers  on;
    }
  }
}

events {
  worker_connections  1024;
}
