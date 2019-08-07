FROM phusion/baseimage:master-amd64
MAINTAINER skysider <skysider@163.com>

COPY sources.list /etc/apt/sources.list

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    ipython \
    vim \
    ctags \
    net-tools \
    iputils-ping \
    libffi-dev \
    libssl-dev \
    python-dev \
    build-essential \
    ruby \
    ruby-dev \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    radare2 \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    file \
    python3-distutils \
    bison --fix-missing && \
    rm -rf /var/lib/apt/list/*

RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    -i https://pypi.doubanio.com/simple/  \
    --trusted-host pypi.doubanio.com \
    ropper \
    unicorn \
    keystone-engine \
    capstone

RUN pip install --upgrade setuptools && \
    pip install --no-cache-dir \
    -i https://pypi.doubanio.com/simple/  \
    --trusted-host pypi.doubanio.com \
    ropgadget \
    pwntools \
    zio \
    smmap2 \
    z3-solver \
    apscheduler && \
    pip install --upgrade pwntools

RUN gem install one_gadget seccomp-tools && rm -rf /var/lib/gems/2.*/cache/*

COPY pip.conf /root/.pip/pip.conf

RUN git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh && \
    sed -i "s?source /pwndbg/gdbinit.py?# source /pwndbg/gdbinit.py?g" /root/.gdbinit

RUN wget -O /root/.gdbinit-gef.py -q https://raw.githubusercontent.com/hugsy/gef/master/gef.py && \
    echo source /root/.gdbinit-gef.py >> /root/.gdbinit

RUN git clone https://github.com/niklasb/libc-database.git libc-database
#RUN git clone https://github.com/niklasb/libc-database.git libc-database && \
#    cd libc-database && ./get || echo "/libc-database/" > ~/.libcdb_path

WORKDIR /pwn/work/

COPY linux_server linux_server64  /pwn/

RUN chmod a+x /pwn/linux_server /pwn/linux_server64

RUN wget -O /usr/local/lib/python2.7/dist-packages/roputils.py -q https://raw.githubusercontent.com/qaqmander/roputils/master/roputils.py

COPY --from=skysider/glibc_builder64:2.19 /glibc/2.19/64 /glibc/2.19/64
COPY --from=skysider/glibc_builder32:2.19 /glibc/2.19/32 /glibc/2.19/32

COPY --from=skysider/glibc_builder64:2.23 /glibc/2.23/64 /glibc/2.23/64
COPY --from=skysider/glibc_builder32:2.23 /glibc/2.23/32 /glibc/2.23/32

COPY --from=skysider/glibc_builder64:2.24 /glibc/2.24/64 /glibc/2.24/64
COPY --from=skysider/glibc_builder32:2.24 /glibc/2.24/32 /glibc/2.24/32

COPY --from=skysider/glibc_builder64:2.25 /glibc/2.25/64 /glibc/2.25/64
#COPY --from=skysider/glibc_builder32:2.25 /glibc/2.25/32 /glibc/2.25/32

COPY --from=skysider/glibc_builder64:2.26 /glibc/2.26/64 /glibc/2.26/64
COPY --from=skysider/glibc_builder32:2.26 /glibc/2.26/32 /glibc/2.26/32

COPY --from=skysider/glibc_builder64:2.27 /glibc/2.27/64 /glibc/2.27/64
COPY --from=skysider/glibc_builder32:2.27 /glibc/2.27/32 /glibc/2.27/32

COPY --from=skysider/glibc_builder64:2.28 /glibc/2.28/64 /glibc/2.28/64
COPY --from=skysider/glibc_builder32:2.28 /glibc/2.28/32 /glibc/2.28/32

COPY --from=skysider/glibc_builder64:2.29 /glibc/2.29/64 /glibc/2.29/64
COPY --from=skysider/glibc_builder32:2.29 /glibc/2.29/32 /glibc/2.29/32

RUN git clone --recursive https://github.com/tony/tmux-config.git /root/.tmux && \
    ln -s /root/.tmux/.tmux.conf /root/.tmux.conf && \
    printf '\n%s\n' 'set-option -g mouse on' >> /root/.tmux.conf

RUN git clone https://github.com/scwuaptx/Pwngdb.git /root/Pwngdb && \
    cd /root/Pwngdb && cat /root/Pwngdb/.gdbinit  >> /root/.gdbinit && \
    sed -i "s?source ~/peda/peda.py?# source ~/peda/peda.py?g" /root/.gdbinit

RUN echo "alias changeld='patchelf --set-interpreter'" >> $HOME/.bashrc

RUN printf '\n%s\n' 'echo 0 >/proc/sys/kernel/randomize_va_space' >> $HOME/.bashrc

RUN apt-get update && \
    apt-get -y install qemu qemu-user qemu-user-static \
    'binfmt*' \
    libc6-mipsel-cross \
    gcc-mipsel-linux-gnu \
    --fix-missing && rm -rf /var/lib/apt/list/*

RUN mkdir /etc/qemu-binfmt && \
    ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel # MIPSEL

RUN git clone https://github.com/hellman/libnum && \
    cd libnum && python setup.py install

RUN apt-get update && \
    apt-get -y install foremost \
    fcrackzip

RUN wget https://github.com/devttys0/binwalk/archive/master.zip && \
    unzip master.zip && cd binwalk-master && python setup.py install

RUN pip install virtualenv virtualenvwrapper && \
    printf '\n%s\n%s\n%s\n' 'export WORKON_HOME=$HOME/.virtualenvs' \
    'export VIRTUALENVWRAPPER_PYTHON="$(command \which python3)"'   \
    'source /usr/local/bin/virtualenvwrapper.sh' >$HOME/.bashrc

RUN wget -O /pwn/setup.sh https://raw.githubusercontent.com/qaqmander/qpwn/master/setup.sh && \
    sed -i "s?#test_and_move '/tmp/qpwn/vimrc'?test_and_move '/tmp/qpwn/vimrc'?g" /pwn/setup.sh && \
    chmod a+x /pwn/setup.sh && /pwn/setup.sh && rm /pwn/setup.sh

RUN echo 'You need ./binwalk-master/deps.sh'

#CMD ["/sbin/my_init"]
CMD ["/bin/bash"]
