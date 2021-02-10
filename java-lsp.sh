#!/usr/bin/env bash

JDT="$HOME/code/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository"
JAR="$JDT/plugins/org.eclipse.equinox.launcher_*"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
export GRADLE_HOME="$HOME/gradle"
$(echo "$JAVA_HOME")/bin/java \
  -Declipse.application=org.eclipse.jdt.ls.core.id1 \
  -Dosgi.bundles.defaultStartLevel=4 \
  -Declipse.product=org.eclipse.jdt.ls.core.product \
  -Dlog.protocol=true \
  -Dlog.level=ALL \
  -Xms1g \
  -Xmx2G \
  -jar $(echo "$JAR") \
  -configuration "$JDT/config_linux" \
  -data "${1:-$HOME/jws}" \
  --add-modules=ALL-SYSTEM \
  --add-opens java.base/java.util=ALL-UNNAMED \
  --add-opens java.base/java.lang=ALL-UNNAMED

