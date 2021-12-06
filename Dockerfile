FROM    alpine:edge

ENV     jarname server.jar
ENV     ram 2G
ENV     javaVersion 11
ENV     enableCommandOnShutdown false
ENV     commandOnShutdown "say Shutting down..."

WORKDIR /mcserver

COPY    tmux.conf /root/.tmux.conf
COPY    run.sh    /run.sh

RUN     apk add --update --no-cache openjdk8-jre openjdk11-jre openjdk16-jre openjdk17-jre tmux

CMD     sh /run.sh $jarname $ram $javaVersion $enableCommandOnShutdown $commandOnShutdown

