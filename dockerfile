FROM debian:stable-slim
MAINTAINER Samuel Debruyn <s@muel.be>

ENV DEBIAN_FRONTEND noninteractive



# setup workdir
RUN mkdir -p /root/work/
WORKDIR /root/work/

# install apt-utils for debconf
RUN apt-get -y update && \
	apt-get -y install --no-install-recommends apt-utils

# install git
RUN apt-get -y update && \
	apt-get -y install git

RUN apt-get update -y  && \
	apt-get install -y gnupg && \
    apt-get install -y wget 

# install java 8for debian 	
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
	echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
	apt-get update -y 	
	
# accept oracle licence 	
RUN	echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
	echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
	
# purge  and install java 8	
RUN mkdir -p /usr/share/man/man1 && \
	apt-get install -f && \
    apt-get purge oracle-java8-installer && \
	apt-get install oracle-java8-installer -y && \
	apt-get install oracle-java8-set-default && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/cache/oracle* /var/log/* && \
    rm -rf /usr/lib/jvm/java-8-oracle/man /usr/lib/jvm/java-8-oracle/src.zip /usr/lib/jvm/java-8-oracle/javafx-src.zip /tmp/*
	
# slim down image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man/?? /usr/share/man/??_*


# get and install MAVEN
ARG MAVEN_VERSION=3.5.4
ARG USER_HOME_DIR="/root"
ARG SHA=22cac91b3557586bb1eba326f2f7727543ff15e3
ARG BASE_URL=http://apache.mediamirrors.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN apt-get update && \
    apt-get install -y curl procps &&\
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha1sum  -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

#ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
#CMD ["mvn"]

# copy XStudio from your local directory
RUN mkdir -p /usr/share/xqual
COPY xstudio_v3_3sp3_linux.tar /usr/share/xqual/xstudio.tar
RUN tar -xvf /usr/share/xqual/xstudio.tar -C /usr/share/xqual
RUN rm -f /usr/share/xqual/xstudio.tar

#Copy Modified Xagent.sh to relocate in /usr/share/xqual
COPY xagent.sh /usr/share/xqual/xstudio/xagent.sh
# A better way would be to adapt the path to have /usr/share/xqual ?

RUN ln -sf /usr/share/xqual/xstudio/xagent.sh /usr/bin/xagent

# here we force this container to start an xagent - this may not be the desired need at the end 
CMD /usr/share/xqual/xstudio/xagent.sh --alias jules --poolDelay 60 --headless true --login admin:password --forceIpv4 true


	