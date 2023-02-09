# On Shell

install runner bin

```shell
# Download the binary for your system
sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64

# Give it permission to execute
sudo chmod +x /usr/local/bin/gitlab-runner

# Create a GitLab Runner user
sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash

# Install and run as a service
sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner

# gitlab-runner install
sudo gitlab-runner start
```

register shell runner

```shell
GITLAB_URL="http://172.16.31.36:23456"
REGISTER_TOKEN="WG8Boxdsdba_kAWaJbDt"
RUNNER_TAGS="shell,1037"
DESC="1037-shell-runner"

sudo gitlab-runner register -n \
  --url $GITLAB_URL \
  --registration-token $REGISTER_TOKEN \
  --tag-list $RUNNER_TAGS \
  --executor shell \
  --locked="false" \
  --description $DESC
```