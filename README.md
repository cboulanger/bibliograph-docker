Bibliograph Docker Image
========================

This is a preconfigured image of Bibliograph running in an Ubuntu container,
a good way to test the application. The setup is very simple and should not
be used in production. The code is the latest version published at [Sourceforge](http://sourceforge.net/projects/bibliograph/files/).

On Mac and Windows, use [Kitematic](https://kitematic.com/) to run the image.

On Linux or if you like the command line, download and build the container with

```
sudo docker pull cboulanger/bibliograph
sudo docker build -t cboulanger/bibliograph
```

and run it with

`docker run –rm -p 80:80 cboulanger/bibliograph`

if you want to be able to shut it down quickly with Control-C, or with

`docker run -d -p 80:80 cboulanger/bibliograph`

for a detached process. 

Issues:
- https-access on port 443 doesn't work yet. 

If you can improve the docker setup, please let me know in the comments, 
or fork the code and share an improved version.
