FROM ubuntu:14.04

MAINTAINER kommadot <tlagyqls7@naver.com>

ENV SHELL /bin/bash

RUN apt-get update && apt-get install -y openssh-server lib32stdc++6 lib32z1 gdb vim python2.7 python2.7-dev python-pip
RUN pip install --upgrade pip
RUN apt-get install libffi-dev libssl-dev -y
RUN pip install pwntools
RUN mkdir /var/run/sshd

RUN useradd -ms /bin/bash user
RUN useradd -ms /bin/bash horse_race

# set password
RUN echo 'user:guest' | chpasswd
RUN echo 'horse_race:hPKrM>)#Lif(lxERB#o3P$wBt7*tagF!LV?0ta0$?#>2E3#>@4g' | chpasswd

# set ssh access
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# copy binary
USER user
COPY horse_race /home/user/

# 
USER horse_race
COPY welcome /home/horse_race/
COPY flagz /home/horse_race/

USER root
RUN chown horse_race:horse_race /home/user/horse_race /home/horse_race/welcome /home/horse_race/flagz
RUN chmod 4755 /home/user/horse_race

RUN chmod 770 /home/horse_race/flagz
RUN chmod 774 /home/horse_race/welcome

# remove history
RUN rm -rf /home/user/.bashrc /home/user/.profile /home/user/.bash_logout
RUN rm -rf /home/horse_race/.bashrc /home/horse_race/.profile /home/horse_race/.bash_logout

RUN chmod 733 /tmp
RUN chmod 555 /home/user
RUN chmod 555 /home/horse_race
RUN rm -rf /usr/bin/wall /usr/bin/sudo /usr/bin/apt-get /usr/bin/who /usr/bin/g++* /usr/bin/gcc*
RUN rm -rf /bin/ch* /bin/fusermount /bin/mount /bin/umount /bin/kill /bin/gzip /bin/nc /bin/nc.openbsd /bin/netcat /bin/netstat /bin/ping /bin/ping6 /bin/ps /bin/su /bin/slepp /bin/sudo /bin/passwd
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
