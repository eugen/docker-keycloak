# Keycloak Docker Image

This is a simple Docker image that will run a Keycloak server with an embedded database.

It's based on `openjdk:8-jdk-alpine`.

A volume for storing the Keycloak data will be automatically created for `/keycloak/standalone/data`.

## Configuration 

This image supports configuring the Keycloak server through a set of environment variables:

### Generic 

* `KEYCLOAK_PORT`: The port on which to listen. Defaults to `8080`.
* `KEYCLOAK_ADMIN_USER`: The name of the admin user to create. Defaults to `admin`.
* `KEYCLOAK_ADMIN_PASSWORD`: The password for the admin user. Defaults to `admin`.

### Realm

* `KEYCLOAK_REALM`: The name of a Realm to create. Defaults to "AppX". All other entities (roles, client, user) will be created in this realm.
* `KEYCLOAK_REALM_ROLES`: A comma separated list of roles to create in the realm. E.g `ADMIN,USER,GUEST`. Make sure to not have spaces between the names.

### Client 

* `KEYCLOAK_CLIENT_IDS`: A comma separated list of client IDs to create. Defaults to `example_client`.
* `KEYCLOAK_CLIENT_WEB_ORIGINS`: If specified, the client will have the "Web Origins" field set to this value. 
* `KEYCLOAK_CLIENT_REDIRECT_URIS`: If specified, the client will have the "Redirect URIs" field set to this value.

### User 

* `KEYCLOAK_USER_USERNAME`: The name of the user to create in the realm. Defaults to `user`.
* `KEYCLOAK_USER_PASSWORD`: The password for the realm user above. Defaults to `password`.
* `KEYCLOAK_USER_ROLES`: A comma separated list of roles that will be assigned to the above user. Make sure to not have spaces between the names. Also note that the roles must be created beforehand by specifying `KEYCLOAK_REALM_ROLES`.

## Running

### With `docker run`

You can run this image directly with `docker run` by specifying all environment variables in the command line:

```
docker run \
	-e KEYCLOAK_ADMIN_USER=admin \
	-e KEYCLOAK_ADMIN_PASSWORD=pa55w00r7 \
	-e KEYCLOAK_REALM=MyRealm \
	-e KEYCLOAK_CLIENT_IDS=myapp1,myapp2 \
	-e KEYCLOAK_CLIENT_WEB_ORIGINS='*' \
	-e KEYCLOAK_CLIENT_REDIRECT_URIS='*' \
	-e KEYCLOAK_REALM_ROLES='ROLE_USER,ROLE_ADMIN' \
	-e KEYCLOAK_USER_ROLES='ROLE_USER,ROLE_ADMIN' \
	--name keycloak_myrealm \
	-p "8080:8080"
	eugenanghel/keycloak

```

### With `docker-compose`

To include in a `docker-compose.yml` file, just add it to the `services` section:

```
services:
	myrealm_keycloak:
		image: eugenanghel/keycloak
		container_name: keycloak_myrealm
		environment:
			- KEYCLOAK_ADMIN_USER=admin
			- KEYCLOAK_ADMIN_PASSWORD=pa55w00r7
			- KEYCLOAK_REALM=MyRealm
			- KEYCLOAK_CLIENT_IDS=myapp1,myapp2
			- KEYCLOAK_CLIENT_WEB_ORIGINS=*
			- KEYCLOAK_CLIENT_REDIRECT_URIS=*
			- KEYCLOAK_REALM_ROLES=ROLE_USER,ROLE_ADMIN
			- KEYCLOAK_USER_ROLES=ROLE_USER,ROLE_ADMIN
		ports:
			- "8080:8080"
```

