# Dockerfile for a TShock Terraria Server
# https://github.com/kalhartt/docker-tshock
FROM mono:latest
LABEL maintainer="Agustin I. monetta <agustin.monetta@gmail.com>"

ARG TSHOCK_VERSION="v4.3.26"
ENV TSHOCK_VERSION="${TSHOCK_VERSION}"
ENV HOUSE_REGION_VERSION="1.2.2"
ENV CLANS_VERSION="v1.0"
ENV PERMABUFFS_VERSION="4.1.0"
ENV TSHOCK_HOME="/opt/tshock"

# Install unzip package,
RUN apt -qq update && \
    apt -qqy install unzip && \
    apt -qqy install jq && \
    apt -qqy install curl && \
    apt -qqy install nano

#Install TSchok
RUN TSHOCK_DOWNLOAD_URL=$(curl -sS -X GET https://api.github.com/repos/Pryaxis/TShock/releases/tags/${TSHOCK_VERSION} | jq -r '.assets[0].browser_download_url') && \
    curl -sL "${TSHOCK_DOWNLOAD_URL}" -o "/tmp/tshock_${TSHOCK_VERSION}.zip" && \
    unzip "/tmp/tshock_${TSHOCK_VERSION}.zip" -d ${TSHOCK_HOME} && \
    rm "/tmp/tshock_${TSHOCK_VERSION}.zip" && \
    echo "${TSHOCK_VERSION}" > ${TSHOCK_HOME}/tshock.version
COPY config/config.json ${TSHOCK_HOME}/tshock/config.json

COPY config/sscconfig.json /tmp/sscconfig.json
ARG SSC_ENABLED="false"
RUN jq ".Enabled = ${SSC_ENABLED}" /tmp/sscconfig.json > ${TSHOCK_HOME}/tshock/sscconfig.json && \
    rm "/tmp/sscconfig.json"

COPY scripts ${TSHOCK_HOME}/scripts
RUN chmod -R +x ${TSHOCK_HOME}/scripts && \
    echo "export PATH="\$PATH:${TSHOCK_HOME}/scripts"" >> /etc/profile && \
    echo "export PATH="\$PATH:${TSHOCK_HOME}/scripts"" >> ~/.profile && \
    echo "export PATH="\$PATH:${TSHOCK_HOME}/scripts"" >> ~/.bashrc
ENV PATH="$PATH:${TSHOCK_HOME}/scripts"

RUN CLANS_URL=$(curl -sS -X GET https://api.github.com/repos/ivanbiljan/Clans/releases/tags/${CLANS_VERSION} | jq -r '.assets[0].browser_download_url') && \
    cd "${TSHOCK_HOME}/ServerPlugins" && curl -sL "${CLANS_URL}" -O

RUN HOUSE_REGION_URL=$(curl -sS -X GET https://api.github.com/repos/CoderCow/HouseRegions-Plugin/releases/tags/${HOUSE_REGION_VERSION} | jq -r '.assets[0].browser_download_url') && \
    curl -sL "${HOUSE_REGION_URL}" -o "/tmp/HouseRegion_${HOUSE_REGION_VERSION}.zip" && \
    unzip  "/tmp/HouseRegion_${HOUSE_REGION_VERSION}.zip" -d /opt/tshock && \
    rm "/tmp/HouseRegion_${HOUSE_REGION_VERSION}.zip"

RUN PERMABUFFS_URL=$(curl -sS -X GET https://api.github.com/repos/amonetta/PermabuffsV2/releases/tags/${PERMABUFFS_VERSION} | jq -r '.assets[0].browser_download_url') && \
    curl -sL "${PERMABUFFS_URL}" -o "/tmp/Permabuffs_${PERMABUFFS_VERSION}.zip" && \
    unzip  "/tmp/Permabuffs_${PERMABUFFS_VERSION}.zip" -d /opt/tshock && \
    rm "/tmp/Permabuffs_${PERMABUFFS_VERSION}.zip"

# Start the server and expose the port
EXPOSE 7777/tcp
EXPOSE 7878/tcp

HEALTHCHECK --interval=5m --timeout=1s \
  CMD tsc health

WORKDIR ${TSHOCK_HOME}
ENTRYPOINT ["mono", "--server", "--gc=sgen", "-O=all", "TerrariaServer.exe"]
CMD ["-world", "Terraria/Worlds/Default.wld", "-autocreate", "2"]