FROM pihole/pihole:latest

MAINTAINER Ritik Kumar <ritikkne@gmail.com>

RUN apt-get update && apt-get -y install supervisor

COPY supervisord.conf /etc/supervisor/conf.d/

# https://docs.pi-hole.net/guides/dns-over-https/#configuring-pi-hole
RUN wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb && apt-get install ./cloudflared-stable-linux-amd64.deb && cloudflared -v

RUN useradd -s /usr/sbin/nologin -r -M cloudflared && chown cloudflared:cloudflared /usr/local/bin/cloudflared

RUN mkdir -p /var/log/cloudflared

CMD ["supervisord", "-n"]
