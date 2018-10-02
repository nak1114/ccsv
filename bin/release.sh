#!/bin/bash

APPNAME=ccsv

apt-get update
apt-get install -y zip
go get github.com/aktau/github-release

CUR=`readlink -f $(dirname $0)`
pushd ${CUR}
mkdir tmp

#release
VERSION="$(git describe --abbrev=0)"
github-release release -u nak1114 -r ${APPNAME} -t ${VERSION} --name ${VERSION} 

pushd ..
go get -v -d
popd
for OS in "linux" "darwin" "windows"; do
  for ARCH in "386" "amd64"; do

    EXEC=${CUR}/tmp/${APPNAME}
    [ ${OS} = "windows" ] && EXEC=${EXEC}.exe
    
    #compile
    pushd ..
    GOOS=${OS} CGO_ENABLED=0 GOARCH=${ARCH} go build -ldflags "-X main.Version=$VERSION" -o ${EXEC}
    popd

    #compress
    pushd tmp
    if [ ${OS} = "windows" ] ; then
      ARCHIVE="${APPNAME}-${VERSION}-${OS}-${ARCH}.zip"
      zip -r ${ARCHIVE} ${EXEC##*/}
    else
      ARCHIVE="${APPNAME}-${VERSION}-${OS}-${ARCH}.tar.gz"
      tar -czf ${ARCHIVE} ${EXEC##*/}
    fi
    popd
    rm -f ${EXEC}

    #release
    echo ${ARCHIVE}
    github-release upload -u nak1114 -r ${APPNAME} -t ${VERSION} -f ${CUR}/tmp/${ARCHIVE} -n ${ARCHIVE}
  done
done
popd
#for OS in "linux" "windows"; do
#  for ARCH in "amd64"; do
#for OS in "freebsd" "linux" "darwin" "windows"; do
#  for ARCH in "386" "amd64"; do
# powershell Expand-Archive dcenv-1.1.1-windows-amd64.zip  -DestinationPath %DCENV_HOME%
# tar xvfz dcenv-1.1.1-linux-amd64.tar.gz -C $DCENV_HOME
