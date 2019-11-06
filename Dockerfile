FROM openjdk:13-jdk-alpine

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

ENV KEYCLOAK_REALM_SETTINGS='{"supportedLocales":["en", "de", "fr"], "defaultLocale":"en", "resetPasswordAllowed": true, "loginTheme": "keycloak"}'

RUN apk update && apk add tar gzip curl bash 

# Use this to download keycloak and extract it on the fly
RUN curl https://downloads.jboss.org/keycloak/7.0.1/keycloak-7.0.1.tar.gz | tar xzvf - 

# Use these 2 lines to copy the local archive and the extract it
#COPY keycloak-7.0.1.tar.gz /
#RUN tar zxvf keycloak-7.0.1.tar.gz

RUN mv keycloak-7.0.1 keycloak && apk del tar gzip 

VOLUME /keycloak/standalone/data

EXPOSE $KEYCLOAK_PORT

COPY run.sh /

CMD bash /run.sh
