FROM node:16-alpine AS node

FROM alpine:edge

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

RUN apk update
RUN apk add bash dbus openssh openssh-server supervisor fluxbox chromium xorg-server xvfb x11vnc alpine-conf

RUN adduser -D alpine 
RUN echo "root:alpine" | /usr/sbin/chpasswd
RUN echo "alpine ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "alpine:alpine" | /usr/sbin/chpasswd
RUN chown -R alpine:alpine /home/alpine

COPY ./supervisord.conf /etc/
EXPOSE 3389 3033 5900 8124 6080

CMD /usr/bin/supervisord -c /etc/supervisord.conf
