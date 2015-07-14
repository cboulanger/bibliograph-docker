Bibliograph Docker Image
========================

This is a preconfigured image of the web-based bibliographic data manager [Bibliograph](http://www.bibliograph.org) 
running in an Ubuntu container. It provides an easy way to try the application out and see whether it 
provides what you need. The docker setup is simple and should not be used in production. 
Improvements are very welcome.

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

if you want to be able to shut it down quickly. For a detached process, use

```
docker run -d -p 80:80 cboulanger/bibliograph
```

Configuration and use
---------------------
The image is configured to install all plugins shipped with the release.
You can log with the following credentials (username/password):

- user/user
- manager/manager
- admin/admin

Issues:
-------
- https-access on port 443 doesn't work yet. 

If you can improve the docker setup, fork the code and share an improved version. 
A safe and stable production setup with data persistence and backup is sorely needed.
