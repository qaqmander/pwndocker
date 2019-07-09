#!/bin/bash

ctf_name=pwn

docker run -it \
    --rm \
    -h ${ctf_name} \
    --name ${ctf_name} \
    -v `pwd`/${ctf_name}/share:/pwn/work \
    --privileged \
    "pwn"
# --cap-add=SYS_PTRACE \
