FROM openjdk:8-jdk-alpine

MAINTAINER eugen@syntactic.org

ENV KEYCLOAK_PORT=8080

ENV KEYCLOAK_REALM=AppX

ENV KEYCLOAK_ADMIN_USER=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin

ENV KEYCLOAK_REALM_ROLES=user,finance,reporting

ENV KEYCLOAK_CLIENT_IDS=example_client
ENV KEYCLOAK_CLIENT_WEB_ORIGINS=""
ENV KEYCLOAK_CLIENT_REDIRECT_URIS=""

ENV KEYCLOAK_USER_USERNAME=user
ENV KEYCLOAK_USER_ROLES=user,reporting
ENV KEYCLOAK_USER_PASSWORD=password

RUN apk update && apk add tar gzip curl bash 

# Use this to download keycloak and extract it on the fly
RUN curl https://downloads.jboss.org/keycloak/3.1.0.Final/keycloak-3.1.0.Final.tar.gz | tar xzvf - 

# Use these 2 lines to copy the local archive and the extract it
#COPY keycloak-3.1.0.Final.tar.gz /
#RUN tar zxvf keycloak-3.1.0.Final.tar.gz

RUN mv keycloak-3.1.0.Final keycloak && apk del tar gzip 

VOLUME /keycloak/standalone/data

EXPOSE $KEYCLOAK_PORT

COPY run.sh /

CMD bash /run.sh
