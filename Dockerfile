FROM debian:stretch

ENV DEBIAN_FRONTEND=noninteractive SSH_AUTH_SOCK=/ssh-agent LANG=en_US.UTF-8
# set default locale
RUN apt-get update && \
    apt-get install -y --no-install-recommends locales wget gnupg apt-utils ca-certificates && \
    sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen && \
    locale-gen && \
    echo "LANG=en_US.UTF-8" >> /etc/default/locale

RUN wget http://pkg.yeti-switch.org/key.gpg -O - | apt-key add -
RUN echo "deb http://pkg.yeti-switch.org/debian/stretch unstable main ext" >> /etc/apt/sources.list
RUN echo "deb http://deb.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list
RUN echo "Package: *\nPin: release n=buster\nPin-Priority: 50\n\nPackage: python-git python-gitdb python-smmap python-tzlocal\nPin: release n=buster\nPin-Priority: 500\n\n" | tee /etc/apt/preferences
RUN apt update && apt -y --no-install-recommends install ruby ruby-dev build-essential devscripts \
    debhelper fakeroot lintian lsb-release zlib1g-dev libpq-dev postgresql-client git-changelog python-setuptools

ADD . /local/build/oms/
WORKDIR /local/build/oms/
ENTRYPOINT ["make"]
CMD ["package"]
