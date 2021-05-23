#!/usr/bin/env bash

export REMCO_HOME=/etc/remco
export REMCO_RESOURCE_DIR=${REMCO_HOME}/resources.d
export REMCO_TEMPLATE_DIR=${REMCO_HOME}/templates
export SPIGOT_CURRENT_VERSION="latest"
export BUILDTOOLS_CURRENT_VERSION="lastSuccessfulBuild"
export SPIGOT_VERSION=${SPIGOT_VERSION:-$SPIGOT_CURRENT_VERSION}
export BUILDTOOLS_VERSION=${BUILDTOOLS_VERSION:-$BUILDTOOLS_CURRENT_VERSION}

echo "Spigot server version set to: $SPIGOT_VERSION"
echo

sudo chown -R minecraft:minecraft ${MC_HOME}
git config --global --unset core.autocrlf

if [ -f "${MC_HOME}/server/spigot-${SPIGOT_VERSION}.jar" ]; then
  echo "Existing spigot jar found: spigot-${SPIGOT_VERSION}.jar"
else
  echo -e "\nSpigot set to latest or no correct spigot version found."
  echo -e "Compiling new binarys.\n"
  curl -o buildtools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/${BUILDTOOLS_VERSION}/artifact/target/BuildTools.jar && \
    chmod +x *.jar && \
    java -Xmx512M -jar buildtools.jar --rev ${SPIGOT_VERSION} --output-dir ${MC_HOME}/server
fi

if [ -f ${MC_HOME}/server/spigot-${SPIGOT_VERSION}.jar ]; then
  echo -e "\nStarting spigot..."

  remco

  cd ${MC_HOME}/server && \
    chmod +x *.jar && \
    java -Xms${JAVA_MEMORY}M -Xmx${JAVA_MEMORY}M -XX:+UseG1GC -jar spigot-${SPIGOT_VERSION}.jar nogui
else
  echo "!!! No spigot jar found !!!"
fi

