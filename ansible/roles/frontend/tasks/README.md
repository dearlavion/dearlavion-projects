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

---
To check if nginx server is running
$ brew services list
or 
$ ps aux | grep nginx


---
Check if no permission issue:
$ nginx -t

Expected:
nginx: the configuration file /opt/homebrew/etc/nginx/nginx.conf syntax is ok
nginx: configuration file /opt/homebrew/etc/nginx/nginx.conf test is successful


If permission issue on pid, override admin to your user

$ sudo chown -R alysson:admin /opt/homebrew/var/run/nginx

$ ls -l@ /opt/homebrew/var/run/nginx
-rw-r--r--@ 1 alysson  admin   0 Dec  9 11:17 nginx.pid


