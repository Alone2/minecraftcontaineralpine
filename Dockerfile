FROM    alpine:edge

ENV     jarname server.jar
ENV     ram 2G
ENV     javaVersion 11
ENV     enableCommandOnShutdown false
ENV     commandOnShutdown "say Shutting down..."
ENV     javaFlags "-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

WORKDIR /mcserver

COPY    tmux.conf /root/.tmux.conf
COPY    run.sh    /run.sh

RUN     apk add --update --no-cache openjdk8-jre openjdk11-jre openjdk16-jre openjdk17-jre tmux

CMD     sh /run.sh $jarname $ram $javaVersion $enableCommandOnShutdown $commandOnShutdown

