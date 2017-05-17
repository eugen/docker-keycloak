#!/bin/bash

# kch = keycloak home
KCH=/keycloak

function is_keycloak_running {
  local http_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:${KEYCLOAK_PORT}/auth/admin/realms)
  if [[ $http_code -eq 401 ]]; then
      return 0
  else
      return 1
  fi
}

function configure_keycloak {
    until is_keycloak_running; do
	echo Keycloak still not running, waiting 5 seconds
	sleep 5
    done

    echo Keycloak is running, proceeding with configuration

    ${KCH}/bin/kcadm.sh config credentials --server http://localhost:${KEYCLOAK_PORT}/auth --user $KEYCLOAK_ADMIN_USER --password $KEYCLOAK_ADMIN_PASSWORD --realm master

    if [ $KEYCLOAK_REALM ]; then
	echo Creating realm $KEYCLOAK_REALM
	${KCH}/bin/kcadm.sh create realms -s realm=$KEYCLOAK_REALM -s enabled=true
    fi

    if [ $KEYCLOAK_CLIENT_ID ]; then
	echo Creating client $KEYCLOAK_CLIENT_ID
	echo '{"clientId": "'$KEYCLOAK_CLIENT_ID'", "webOrigins": ["'$KEYCLOAK_CLIENT_WEB_ORIGINS'"], "redirectUris": ["'KEYCLOAK_CLIENT_REDIRECT_URIS'"]}' | ${KCH}/bin/kcadm.sh create clients -r ${KEYCLOAK_REALM:-master} -f -
    fi

    if [ $KEYCLOAK_REALM_ROLES ]; then
	for role in ${KEYCLOAK_REALM_ROLES//,/ }; do
	    echo Creating role $role
	    ${KCH}/bin/kcadm.sh create roles -r ${KEYCLOAK_REALM:-master} -s name=${role}
	done
    fi

    if [ $KEYCLOAK_USER_USERNAME ]; then
	echo Creating user $KEYCLOAK_USER_USERNAME
	echo '{"username": "'$KEYCLOAK_USER_USERNAME'", "credentials":[{"value":"'$KEYCLOAK_USER_PASSWORD'", "temporary": false}], "realmRoles":["'${KEYCLOAK_USER_ROLES//,/","}'"]}' \
	    | ${KCH}/bin/kcadm.sh create users -r ${KEYCLOAK_REALM:-master} -f -
    fi

}

configure_keycloak &

sed -i -e 's/<socket-binding name="http".*/<socket-binding name="http" port="'$KEYCLOAK_PORT'"\/>/' ${KCH}/standalone/configuration/standalone.xml

${KCH}/bin/add-user-keycloak.sh --user $KEYCLOAK_ADMIN_USER --password $KEYCLOAK_ADMIN_PASSWORD

${KCH}/bin/standalone.sh -b 0.0.0.0
