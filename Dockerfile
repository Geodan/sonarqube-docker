
FROM frolvlad/alpine-oraclejdk8:latest

MAINTAINER Jan Boonen <jan.boonen@geodan.nl>

ENV SONARQUBE_HOME /opt/sonarqube

# Http port
EXPOSE 9000

# Database configuration
# Defaults to using H2
ENV SONARQUBE_JDBC_USERNAME sonar
ENV SONARQUBE_JDBC_PASSWORD sonar
ENV SONARQUBE_JDBC_URL jdbc:h2:tcp://localhost:9092/sonar

ENV SONAR_VERSION 5.2

RUN apk add --update wget gnupg unzip bash

RUN set -x \
	&& mkdir /opt && cd /opt \
	&& wget --progress=bar:force http://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip -O sonarqube.zip \
	&& wget http://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc -O sonarqube.zip.asc \
	&& unzip sonarqube.zip \
	&& mv sonarqube-$SONAR_VERSION sonarqube \
	&& rm sonarqube.zip* \
	&& rm -rf $SONARQUBE_HOME/bin/* \
	&& cd sonarqube/extensions/plugins \
	&& wget --progress=bar:force http://sonarsource.bintray.com/Distribution/sonar-javascript-plugin/sonar-javascript-plugin-2.14.jar \
	-O sonar-javascript-plugin-2.14.jar \
	&& wget --progress=bar:force http://sonarsource.bintray.com/Distribution/sonar-ldap-plugin/sonar-ldap-plugin-1.5.jar \
	-O sonar-ldap-plugin-1.5.jar \
	&& wget --progress=bar:force http://sonarsource.bintray.com/Distribution/sonar-resharper-plugin-2.0.jar \
	-O sonar-resharper-plugin-2.0.jar \
	&& wget --progress=bar:force http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-cobertura-plugin/1.6.3/sonar-cobertura-plugin-1.6.3.jar \
	-O sonar-cobertura-plugin-1.6.3.jar \
	&& wget --progress=bar:force http://sonarsource.bintray.com/Distribution/sonar-csharp-plugin/sonar-csharp-plugin-4.3.jar \
	-O sonar-csharp-plugin-4.3.jar \
	&& wget --progress=bar:force --no-check-certificate https://github.com/SonarCommunity/sonar-css/releases/download/1.5/sonar-css-plugin-1.5.jar \
	-O sonar-css-plugin-1.5.jar \
	&& wget --progress=bar:force http://sonarsource.bintray.com/Distribution/sonar-findbugs-plugin/sonar-findbugs-plugin-3.3.jar \
	-O sonar-findbugs-plugin-3.3.jar \
	&& wget --progress=bar:force http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-motion-chart-plugin/1.7/sonar-motion-chart-plugin-1.7.jar \
	-O sonar-motion-chart-plugin-1.7.jar \
	&& wget --progress=bar:force http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/python/sonar-python-plugin/1.5/sonar-python-plugin-1.5.jar \
	-O sonar-python-plugin-1.5.jar \
	&& wget --progress=bar:force http://downloads.sonarsource.com/plugins/org/codehaus/sonar-plugins/sonar-timeline-plugin/1.5/sonar-timeline-plugin-1.5.jar \
	-O sonar-timeline-plugin-1.5.jar \
	&& wget --progress=bar:force http://sonarsource.bintray.com/Distribution/sonar-web-plugin/sonar-web-plugin-2.4.jar \
	-O sonar-web-plugin-2.4.jar \
	&& wget --progress=bar:force http://sonarsource.bintray.com/Distribution/sonar-xml-plugin/sonar-xml-plugin-1.3.jar \
	-O sonar-xml-plugin-1.3.jar

VOLUME ["$SONARQUBE_HOME/data", "$SONARQUBE_HOME/extensions", "$SONARQUBE_HOME/conf"]

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
RUN chmod +x $SONARQUBE_HOME/bin/run.sh
ENTRYPOINT ["./bin/run.sh"]
