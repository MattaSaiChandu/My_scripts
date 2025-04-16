#!/bin/bash

# === Variables ===
TOMCAT_VERSION="9.0.102"
TOMCAT_ARCHIVE="apache-tomcat-$TOMCAT_VERSION.tar.gz"
TOMCAT_URL="https://dlcdn.apache.org/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/$TOMCAT_ARCHIVE"
TOMCAT_DIR="apache-tomcat-$TOMCAT_VERSION"
JAVA_HOME_PATH="/usr/lib/jvm/java-1.8.0-openjdk"

echo "==> Installing Java (OpenJDK 8)..."
sudo yum install -y java-1.8.0-openjdk

echo "==> Setting JAVA_HOME..."
export JAVA_HOME=$JAVA_HOME_PATH
echo "export JAVA_HOME=$JAVA_HOME_PATH" >> ~/.bashrc
source ~/.bashrc

echo "==> Downloading Tomcat $TOMCAT_VERSION..."
wget $TOMCAT_URL

echo "==> Extracting Tomcat..."
tar -zxvf $TOMCAT_ARCHIVE

echo "==> Configuring tomcat-users.xml..."
cat <<EOL > $TOMCAT_DIR/conf/tomcat-users.xml
<tomcat-users>
    <role rolename="manager-gui"/>
    <role rolename="manager-script"/>
    <user username="tomcat" password="raham123" roles="manager-gui,manager-script"/>
</tomcat-users>
EOL

echo "==> Modifying manager context.xml (removing IP restrictions)..."
CONTEXT_FILE="$TOMCAT_DIR/webapps/manager/META-INF/context.xml"
sed -i '21d;22d' "$CONTEXT_FILE"

echo "==> Starting Tomcat..."
sh $TOMCAT_DIR/bin/startup.sh

echo "✅ Apache Tomcat $TOMCAT_VERSION installed and running!"
