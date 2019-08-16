FROM openjdk:8-jre-slim

WORKDIR /waves

RUN apt-get update && apt-get install -y curl jq wget \
    && JAR_REMOTE_PATH=$(curl "https://api.github.com/repos/wavesplatform/Waves/releases" \
        | jq -r '[.[] | select(.prerelease == false)] | first.assets[] | select(.name|endswith(".jar")) | .browser_download_url') \ 
	&& echo "Downloading '$JAR_REMOTE_PATH'. This may take a few minutes..." \
	&& wget $JAR_REMOTE_PATH -qO /waves/waves-all.jar

COPY configs /waves/nodex/configs/
COPY lib/ /waves/lib/

EXPOSE 6860 6869 6886

ENTRYPOINT ["java", "-cp","/waves/waves-all.jar:/waves/lib/*", "com.wavesplatform.Application","/waves/nodex/configs/waves-dex.conf"]
