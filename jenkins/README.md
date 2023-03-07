# Jenkins

Jenkins Pipeline is used. Rebuilds the containers in the EC2 instance on GitHub push events. Uses GitHub's webhook.

## Docker
```
docker build -t jenkins .
```

```
docker run -d --name jenkins -p <JENKINS_GUI_PORT>:8080 -p <JENKINS_SSH_PORT>:50000 --restart=on-failure \
--env GITHUB_USERNAME=<GITHUB_USERNAME> \
--env GITHUB_PAT=<GIT_PAT> \
--env GITHUB_ADDRESS=<GIT_ADDRESS> \
--env USER_ID=<JENKINS_USER_ID> \
--env USER_PW=<JENKINS_USER_PW< \
--env SERVER_IP_ADDRESS=<SERVER_IP_ADDRESS> \
--env BACKEND_PORT=<BACKEND_PORT> \
--env IS_BACKEND_SECURE=<IS_BACKEND_SECURE> \
--env FRONTEND_PORT=<FRONTEND_PORT> \
--env IS_FRONTEND_SECURE=<IS_FRONTEND_SECURE> \
--env KEY_PAIR_CONTENT="<KEY_PAIR_CONTENT>" \
jenkins
```

## Important Note

After Jenkins is set up, a webhook should be created with a such payload url: `http://my.ip.add.ress/github-webhook/`.<br>
The content type of the webhook must be `application/json`

For the webhook to work and trigger the pipeline; after Jenkins is setup, once, a build must successfully run manually. The reason, i'm not sure. Sources;
- https://stackoverflow.com/a/67132578
- https://stackoverflow.com/a/53660281
- https://github.com/jenkinsci/bitbucket-push-and-pull-request-plugin/issues/19#issuecomment-489326391