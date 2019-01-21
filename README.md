# Docker Image for hosting a PHP7 application on Apache

## Building Image 

Default version of PHP is set to 7.3.  
Current settings (php.ini) are geared toward development environments since errors are verbose. 

Image can be built by running:  
`.\build-image.bat` 

## Starting Container 

Run the container to see the demo application:  
`docker run -p 8080:80 -d php7_apache_app` 

You should see the PHP Info page when visiting:  
[http://localhost:8080/](http://localhost:8080/) 

## Advanced Container Options

### Live updates while developing 
By default, the application `www` directory is copied into the image at build time so it's packaged for a release. However, while developing, this is obviously an 
unusable work pattern so it's ideal to mount the directory as a volume when starting the container:  
`docker run -p 8080:80 -d -v c:\my\path\to\www:/var/www/site php7_apache_app` 

### Connecting to MySQL on Docker Host 
Usually when developing locally, you'll run a local MySQL client (whether Docker-ized or not) on your host machine, but it's a bit difficult to connect to it from a container running on that host machine. Without configured DNS, Docker needs to know that "localhost" refers to the host machine versus the image itself. Luckily there's a special domain called host.docker.internal that can be used to reference the host machine; however, apparently it only works on Windows after recent Docker updates. You can pass it in as an environment variable and implement it accordingly in your connection string:  
`docker run -p 8080:80 -d -v c:\my\path\to\www:/var/www/site -e MYSQL_SERVER_ADDRESS='host.docker.internal' php7_apache_app` 