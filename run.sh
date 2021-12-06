jarname=$1
ram=$2
javaVersion=$3
enableCommandOnShutdown=$4
commandOnShutdown=$5

echo jarname: $jarname

echo ram: $ram 

echo java version: $javaVersion 

echo shutdownmessage: $shutdownmessage 

if [ "$javaVersion"  = "8" ]
then
    echo /usr/lib/jvm/java-1.8-openjdk/jre/bin > /tmp/out 
elif [ "$javaVersion" = "16" ]
then
        echo /usr/lib/jvm/java-16-openjdk/jre/bin > /tmp/out 
elif [ "$javaVersion" = "17" ]
then
    echo /usr/lib/jvm/java-17-openjdk/jre/bin > /tmp/out 
elif [ "$javaVersion" = "11" ]
then
    echo /usr/lib/jvm/java-11-openjdk/jre/bin > /tmp/out 
else
    echo Only java 8, 11, 16 and 17 are supported...
    exit 1
fi

echo java path: $(cat /tmp/out)  

tmux new -s minecraft -d '$(cat /tmp/out)/java -Xms'$ram' -Xmx'$ram' -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar '$jarname'' 

_term() { 
    echo shutting down...  

    [ "$shutdownmessage"  = "true" ] && ( 
        for n in `seq 1 25`
        do 
            tmux send-keys -t minecraft "say RESTARTING OR SHUTTING DOWN SERVER!" ENTER 
            sleep 0.1
        done 
        sleep 2 
    ) 

    tmux send-keys -t minecraft "stop" ENTER 
    sleep 0.5 
    tmux send-keys -t minecraft "end" ENTER 
    sleep 5  
}

trap _term TERM EXIT INT

(
    while [ "$(tmux ls)" != "" ]
    do 
        sleep 5
    done
) &

wait "$!"
