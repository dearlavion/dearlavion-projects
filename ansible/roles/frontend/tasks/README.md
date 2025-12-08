NGINX
Update config:
sudo nano /opt/homebrew/etc/nginx/servers/dearlavion.conf

——
To check config syntax:
nginx -t -c /opt/homebrew/etc/nginx/nginx.conf

Expected output:
nginx: the configuration file /opt/homebrew/etc/nginx/nginx.conf syntax is ok
nginx: configuration file /opt/homebrew/etc/nginx/nginx.conf test is successful

——

To kill nginx:
sudo pkill -f nginx

——
To restart nginx:
brew services restart nginx
Or
sudo /opt/homebrew/bin/nginx

