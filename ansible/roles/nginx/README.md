# 🚀 Debugging DOCKER NGINX

## 1️⃣ Confirm containers are running

    docker ps

You should see at least:
dearlavion-nginx
dearlavion-web-ui
dearlavion-authentication-service
dearlavion-core-service

All should be Up (not restarting).

## 2️⃣ Confirm they’re on the same network

    docker network inspect dearlavion-net

Under Containers, you should see all four container names listed.

✅ This confirms Docker DNS will work.

## 3️⃣ Check nginx container logs (most important)

    docker logs dearlavion-nginx

You want to see:
no [emerg]
no host not found in upstream
no config errors

If nginx is running, you’ll usually see:
nginx entered RUNNING state
or nothing at all (which is good).

## 4️⃣ Validate nginx config inside the container

    docker exec -it dearlavion-nginx nginx -t


Expected output:
nginx: configuration file /etc/nginx/nginx.conf test is successful

## 5️⃣ Test service name resolution (critical)

    docker exec -it dearlavion-nginx sh

Then inside:

    # Test Web UI
    curl -I http://dearlavion-web-ui:80

    # Test Auth service
    curl -I http://dearlavion-authentication-service:8080

    # Test Core service
    curl -I http://dearlavion-core-service:8080

## 6️⃣ Test proxy paths via curl

From the host:

    curl http://localhost/
    curl http://localhost/auth/health || true
    curl http://localhost/core/health || true


Even if /health isn’t implemented, you should:
NOT get connection errors
get 200, 404, or JSON responses

🚫 If you get 502 Bad Gateway, nginx can’t reach backend.

## 7️⃣ (Optional) Confirm ports are correct

    ss -tulpn | grep :80

You should see Docker/nginx bound to port 80.

## 8️⃣ End-to-end browser test

From your browser:

    http://<server-ip>/


If you’re using ngrok:

    https://<your-subdomain>.ngrok.app

You should see your Angular app load.

## Debug if the image pulled is latest

    docker images ghcr.io/dearlavion/dearlavion-auth-service:dev

    REPOSITORY                                   TAG       IMAGE ID       CREATED          SIZE
    ghcr.io/dearlavion/dearlavion-auth-service   dev       fae251ea4100   11 minutes ago   319MB
