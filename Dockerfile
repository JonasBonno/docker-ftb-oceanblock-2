FROM eclipse-temurin:21-jre

MAINTAINER Jonas Bonno Mikkelsen (https://github.com/JonasBonno)

# Updating container
RUN apt-get update && \
	apt-get install apt-utils --yes && \
	apt-get upgrade --yes --allow-remove-essential && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Setting workdir
WORKDIR /minecraft

# Creating user and downloading files
RUN useradd -m -U minecraft && \
	mkdir -p /minecraft/world && \
	wget --no-check-certificate https://api.feed-the-beast.com/v1/modpacks/public/modpack/128/100074/server/linux -O serverinstall_128_100074 && \
	chmod u+x serverinstall_* && \
	./serverinstall_* --auto -force && \
	rm serverinstall_* && \
	echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)." > eula.txt && \
	echo "$(date)" >> eula.txt && \
	echo "eula=true" >> eula.txt && \
	chown -R minecraft:minecraft /minecraft

# Changing user to minecraft
USER minecraft

# Expose port 25565
EXPOSE 25565

# Expose volume
VOLUME ["/minecraft/world"]

# Start server
CMD ["/bin/bash", "/minecraft/run.sh"]
