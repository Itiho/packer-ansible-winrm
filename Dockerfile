FROM alpine:3.6

ARG PACKER_VER=1.4.3

RUN	apk --update add \
    bash \
    ca-certificates \
    git \
    less=487-r0 \
    openssl \
    openssh-client \
    p7zip \
    python \
    py-lxml \
    py-pip \
    rsync \
    sshpass \
    zip \
    jq \
    ca-certificates \
    openssh-client \
    sed \
    && apk --update add --virtual \
    build-dependencies \
    python-dev \
    libffi-dev \
    openssl-dev \
    build-base \
    && pip install --upgrade \
    pip \
    cffi \
    && pip install \
    ansible==2.7.6 \
    pywinrm>=0.3.0 \
    pyvmomi==6.0.0.2016.6 \
    && apk del build-dependencies \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /etc/ansible \		
    && echo 'localhost' > /etc/ansible/hosts \		
    && mkdir -p ~/.ssh && touch ~/.ssh/known_hosts \
    && wget -O /tmp/packer.zip "https://releases.hashicorp.com/packer/${PACKER_VER}/packer_${PACKER_VER}_linux_amd64.zip" \
    && unzip -o /tmp/packer.zip -d /usr/local/bin \
    && rm -f /tmp/packer.zip

ONBUILD	WORKDIR	/tmp
ONBUILD	COPY 	. /tmp
ONBUILD	RUN	ansible -c local -m setup all > /dev/null
CMD ["bash"]