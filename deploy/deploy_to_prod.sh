#!/bin/sh

export APP_USER=appadm

export APP_NAME=activities-config-microservice
export APP_DIR=$APP_NAME

export LOG_DIR=log/$APP_DIR
# Override spring boot LOG_FOLDER
export LOG_FOLDER=/var/opt/$LOG_DIR
# Override spring boot LOG_FILENAME
export LOG_FILENAME=console.log

# export PID_DIR=pid
# Override spring boot PID_FOLDER
# export PID_FOLDER=/var/$PID_DIR

export NEXUS_URL=http://192.168.1.31:8082/nexus/service/local/artifact/maven/content
export REPO_ID=releases
export GROUP_ID=com.amhzing.activities-config
export ARTIFACT_ID=activities-config-microservice
export VERSION=RELEASE
export RELEASE_ARTIFACT_URL="$NEXUS_URL?r=$REPO_ID&g=$GROUP_ID&a=$ARTIFACT_ID&v=$VERSION"
export RELEASE_ARTIFACT=$APP_NAME.jar

export SPRING_PROFILES_ACTIVE=production

# -- Create user if it does not exist
id -u $APP_USER &>/dev/null || sudo useradd $APP_USER

# -- Set up application directory (assuming /opt folder already exists)
cd /opt
# Create the directory if it doesn't exist
sudo mkdir -p $APP_DIR
# Change owner and group
sudo chown -R $APP_USER:$APP_USER $APP_DIR
# Give owner full permissions
sudo chmod 700 $APP_DIR

# -- Set up PID directory (assuming /var folder already exists)
# cd /var
# sudo mkdir -p $PID_DIR
# sudo chown -R $APP_USER:$APP_USER $PID_DIR
# sudo chmod 700 $PID_DIR

# -- Set up Log directory (assuming /var/opt folder already exists)
cd /var/opt
sudo mkdir -p $LOG_DIR
sudo chown -R $APP_USER:$APP_USER $LOG_DIR
sudo chmod -R 700 $LOG_DIR

# -- Get the jar file from Nexus
cd /opt/$APP_DIR
sudo rm -f $RELEASE_ARTIFACT
wget -qO $RELEASE_ARTIFACT $RELEASE_ARTIFACT_URL
sudo chown -R $APP_USER:$APP_USER $RELEASE_ARTIFACT
sudo chmod 500 $RELEASE_ARTIFACT

# Create a symlink
sudo ln -s /opt/$APP_DIR/$RELEASE_ARTIFACT /etc/init.d/$APP_NAME

# Start the application automatically on boot (below is how it's done in Debian)
sudo update-rc.d $APP_NAME defaults

sudo service $APP_NAME stop
sudo service $APP_NAME start
