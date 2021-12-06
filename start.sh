docker run -p 0.0.0.0:60606:60606/udp -p 25565:25565 --name mc1 --rm -v $(pwd)/servertest:/mcserver --env javaVersion=17 --env jarname=spigot.jar -d mc
#docker run --network host --name mc1 --rm -v $(pwd)/servertest:/mcserver --env javaVer8or11or16=16 --env jarname=spigot.jar -d mc 
