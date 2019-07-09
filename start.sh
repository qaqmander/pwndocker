#!/bin/bash

ctf_name=pwn

sudo docker run -it \
    --rm \
    -h ${ctf_name} \
    --name ${ctf_name} \
    -v `pwd`/share:/pwn/work \
    --privileged \
    "pwn"
# --cap-add=SYS_PTRACE \
