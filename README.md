# gitea-env

Brings up a Gitea instance on `localhost`. Gitea and its dependencies
(postgresql) are executed as docker images.


## Run

1. Set environment variables to control behavior:

   ```bash
   # Host port where Gitea will serve its web/API.
   export GITEA_WEB_PORT=8080
   # Host port where Gitea will serve ssh.
   export GITEA_SSH_PORT=2222
   # The admin account credentials that will be configured.
   export GITEA_ADMIN_USERNAME=gitea
   export GITEA_ADMIN_PASSWORD=password
   # Host port where Postgres will serve.
   export POSTGRES_PORT=5432
   ```

1. Start the containers:

   ``` bash
   ./bin/gitea.sh up && ./bin/gitea.sh logs
   ```

1. Navigate your browser to http://localhost:${GITEA_WEB_PORT} and log in with
   admin credentials.

1. If you want to push commits via SSH, you can add an ssh key to your profile
   via the [API](http://localhost:8080/api/swagger).

   ```bash
   curl_opts="--fail --header Content-Type:application/json -u ${GITEA_ADMIN_USERNAME}:${GITEA_ADMIN_PASSWORD}"

   curl ${curl_opts} http://localhost:8080/api/v1/user/keys
   curl ${curl_opts} -X POST -d "{\"title\":\"dummy-ssh-key\",\"key\":\"$(cat gitea.pub)\"}" http://localhost:8080/api/v1/user/keys
   ```

1. To clone a repo over HTTP:

   ```bash
   git clone http://localhost:8080/gitea/<repo>.git
   ```

1. To clone a repo over SSH with the sample [gitea](gitea) ssh key:

   ```bash
   export GIT_SSH_COMMAND="ssh -i ${PWD}/gitea -p 2222 -o NoHostAuthenticationForLocalhost=true"
   git clone git@localhost:gitea/<repo>.git
   ```

1. Dispose the environment (note: wipes storage!)

   ``` bash
   ./bin/gitea.sh down
   ```
