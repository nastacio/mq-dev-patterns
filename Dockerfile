# https://developer.ibm.com/components/ibm-mq/tutorials/mq-develop-mq-jms/

#
# Stage 1
#
FROM maven:3.6.3-openjdk-16 as build

WORKDIR /project/

COPY ./JMS .

RUN \
    mvn -ntp -f pom.xml package && \
    find /root/.m2/repository -name "javax.jms-api*.jar"  -exec cp {} /project/target/javax.jms-api.jar \; && \
    find /root/.m2/repository -name "com.ibm.mq.allclient*.jar"  -exec cp {} /project/target/com.ibm.mq.allclient.jar \;

#
# Stage 2
#
FROM openjdk:11-jre-slim-buster

WORKDIR /project
COPY --from=build /project/target/javax.jms-api.jar .
COPY --from=build /project/target/com.ibm.mq.allclient.jar .
COPY --from=build /project/target/mq-dev-patterns-0.1.0.jar mq-dev-patterns.jar
COPY env-mock.json /env.json


ENTRYPOINT ["/usr/local/openjdk-11/bin/java", "-cp", "./com.ibm.mq.allclient.jar:./javax.jms-api.jar:./mq-dev-patterns.jar", "com.ibm.mq.samples.jms.JmsPut"]
