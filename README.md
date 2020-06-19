# docker-thc-hacker
Docker environment for hackers

THIS IS TOTALLY ALPHA FOR CLOSE FRIENDS ONLY. PLEASE LET ME KNOW WHAT TOOLS YOU LIKE ME TO ADD.

Install:
```
$ git clone https://github.com/hackerschoice/docker-thc-hacker
$ docker build -t thc-hacker docker-thc-hacker
```

Run:
```
$ docker run -it --name thc -v ~/hax:/hax --log-driver=none thc-hacker
```

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




