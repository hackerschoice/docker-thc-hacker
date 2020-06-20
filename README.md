# docker-thc-hacker
Docker environment for hackers

Docker is like a Virtual Machine (but it aint!). It uses the 'Container' to isolate any activities from a docker instance from the Host OS.

Docker uses the overlay-fs. No data is written to the host's file system. A docker instance always looks new when it is run again. It's perfect for hacking or executing untrusted binaries.   

The host's ~/hax is mounted to /hax in order to quickly share data between the docker instance and the Host OS.

**This Docker Instance comes pre-installed with our favourite hacking tools**

THIS IS TOTALLY ALPHA FOR CLOSE FRIENDS ONLY. PLEASE LET ME KNOW WHAT TOOLS YOU LIKE ME TO ADD.

Install:
```
$ git clone https://github.com/hackerschoice/docker-thc-hacker
$ docker build -t thc-hacker docker-thc-hacker
```

Run:
```
$ docker run -it --rm --name thc -v ~/hax:/hax --log-driver=none thc-hacker
```
(the ***--rm*** command will automatically remove the container on exit).

Run a second shell:
```
$ docker exec -it thc zsh
```

Attach back to an instance:
```
$ docker start thc
$ docker attach thc
```

Save the state of an instance and start it again where we stopped:
```
$ docker commit thc thc-hacker:have-a-break
$ docker container rm thc
$ docker run -it --name thc -v ~/hax:/hax --log-driver=none thc-hacker:have-a-break
```

Export an instance and import it (on another machine):
```
$ docker save thc | gzip >warez.gz
$ docker load <warez.gz
```

Delete the instance:
```
$ docker container rm thc
```

Delete the image:
```
$ docker image rm thc-hacker
```

There is so much information missing (for example how to run X11 applications). Let me know what else is missing. I need help. Join me.

TODO:
- add TorGhost
- Infos on X11 redirection (ssh dude...)




