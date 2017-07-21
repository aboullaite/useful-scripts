#!/bin/bash

REPOSITORY=maven-releases
EXTENSIONS="*.jar *.war *.pom *.xml *.md5 *.sha1 *.zip"

for tosearch in $EXTENSIONS;
do
     for file in `find . -name $tosearch`;
     do
         length=${#file}
         path=${file:2:$length}
         echo "uploading path $path"
         curl -u <NDEXUS_USER>:<NDEXUS_PASSWORD> --upload-file $path http://<NEXUS_URL>:<PORT>/repository/$REPOSITORY/$path
     done;
done;
