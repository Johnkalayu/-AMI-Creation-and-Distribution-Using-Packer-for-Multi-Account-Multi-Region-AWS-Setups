FROM amazonlinux:2 AS builder

ENV MAVEN_VERSION=3.6.3
ENV SONAR_SCANNER_VERSION=4.4.0.2170
ENV JFROG_CLI_VERSION=1.42.1
ENV TRIVY_VERSION=0.19.2
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.292.b10-0.amzn2.0.1.x86_64/jre
ENV PATH=$PATH:$JAVA_HOME/bin

RUN yum update -y && yum install -y wget unzip git jq && \
    wget https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mv apache-maven-$MAVEN_VERSION /opt/maven && \
    rm -f apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    # Install Sonar Scanner
    wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip && \
    unzip sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip && \
    mv sonar-scanner-$SONAR_SCANNER_VERSION-linux /opt/sonar-scanner && \
    rm -f sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip && \
    # Install JFrog CLI
    wget https://releases.jfrog.io/artifactory/jfrog-cli/v1/$JFROG_CLI_VERSION/jfrog-cli-linux-amd64/jfrog && \
    chmod +x jfrog && \
    mv jfrog /usr/bin/jfrog && \
    curl https://static.snyk.io/cli/latest/snyk-linux -o snyk && \
    chmod +x snyk && \
    mv ./snyk /usr/local/bin/snyk && \
    # Install trivy
    wget https://github.com/aquasecurity/trivy/releases/download/v$TRIVY_VERSION/trivy_$TRIVY_VERSION_Linux-64bit.tar.gz && \
    tar -zxvf trivy_$TRIVY_VERSION_Linux-64bit.tar.gz && \
    mv trivy /usr/local/bin/trivy && \
    rm -f trivy_$TRIVY_VERSION_Linux-64bit.tar.gz


RUN snyk --version && \
    jfrog --version && \
    mvn --version && \
    sonar-scanner --version && \
    trivy --version


FROM amazonlinux:2 AS final

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.292.b10-0.amzn2.0.1.x86_64/jre
ENV PATH=$PATH:$JAVA_HOME/bin

RUN yum update -y  && yum install -y git jq java-1.8.0-openjdk

COPY --from=builder /opt/maven /opt/maven
COPY --from=builder /opt/sonar-scanner /opt/sonar-scanner
COPY --from=builder /usr/bin/jfrog /usr/bin/jfrog
COPY --from=builder /usr/local/bin/snyk  /usr/local/bin/snyk
COPY --from=builder /usr/local/bin/trivy /usr/local/bin/trivy

ENTRYPOINT [ "/bin/bash" ]    