Bibliograph Docker Image
========================

This is a preconfigured image of Bibliograph running in an Ubuntu container,
a good way to test the application. The docker setup is very simple and should not
be used in production. 

The code is the latest version published at [Sourceforge](http://sourceforge.net/projects/bibliograph/files/).

Building and running of the Image
---------------------------------

On Mac and Windows, use [Kitematic](https://kitematic.com/) to run the image.

On Linux or if you like the command line, download and build the container with
```
sudo docker pull cboulanger/bibliograph
sudo docker build -t cboulanger/bibliograph .
```
and run it with
```
docker run –rm -p 80:80 cboulanger/bibliograph
```

If you want to be able to shut it down quickly, or with
```
docker run -d -p 80:80 cboulanger/bibliograph
```
for a detached process. 

Configuration and use
---------------------
The image is configured to install all plugins shipped with the release.
You can log with the following credentials (username/password):
- user/user
- manager/manager
- admin/amdin

Issues:
-------
- https-access on port 443 doesn't work yet. 

If you can improve the docker setup, fork the code and share an improved version. 
A safe and stable production setup with data persistence and backup would be
very welcome. 
