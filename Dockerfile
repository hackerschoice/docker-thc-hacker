FROM kalilinux/kali-rolling
#FROM ubuntu:latest

COPY install.sh /tmp/

WORKDIR /tmp/
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends \
	curl \
	`# Install build Environment - about 300 MB` \
	python3 \
	git \
	automake \
	gcc \
	patch \
	gdb 

RUN apt-get install -y --no-install-recommends \
	openssh-client \
	nmap \
	netcat \
	socat \
	screen \
	dnsutils \
	net-tools \
	lsof \
	iputils-ping \
	vim \
	hexedit \
	encfs \
	sshfs \
	tcpdump \
	iodine \
	hashcat \
	hydra \
	dirb \
	zsh \
	openssl \
	ca-certificates \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /root/.ssh \
	&& ssh-keyscan github.com >>/root/.ssh/known_hosts \
	&& echo 1.1 >/THC-DOCKER-VERSION \
	&& chmod 755 ./install.sh \
	&& ./install.sh  \
	&& rm -rf install.sh \
	&& true

WORKDIR /hax

COPY motd /etc/motd

CMD ["/usr/bin/zsh"]

