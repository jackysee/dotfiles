#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

pushd /tmp/

mkdir dot-install
cd dot-install

curl -s https://api.github.com/repos/ubnt-intrepid/dot/releases/latest \
| grep "browser_download_url.*x86.*linux-gnu\.tar\.gz" \
| cut -d ":" -f 2,3 \
| tr -d \" \
| xargs -I % curl -OL %

tarball="$(find . -name "dot*linux-gnu.tar.gz")"
tar -xzf $tarball

chmod +x dot
mv dot /usr/local/bin/
cd ..
rm -rf dot-install

popd

location="$(which dot)"
echo "dot binary location: $location"

version="$(dot --version)"
echo "dot binary version: $version"
