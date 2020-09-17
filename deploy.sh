#!/bin/bash

curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt -y install jq git file nodejs build-essential

function build_dir {
  DIR="$1"
  pushd $DIR
  rsync -rv ../_layouts/ ./_layouts/
  rsync -rv ../resources/ ./resources/
  gitbook init
  gitbook install
  gitbook build
  popd  
}

sudo npm install -g gitbook-cli

build_dir zh_cn
build_dir en
build_dir ru
build_dir ko
build_dir fa
build_dir vi

TARGET_DIR=_v2ray_com

git clone "https://github.com/webcirque/v2ray-man.git" ${TARGET_DIR}

rm -rf ${TARGET_DIR}/*
cp -r ./zh_cn/_book/* ${TARGET_DIR}/zh_cn
mkdir ${TARGET_DIR}/en/
cp -r ./en/_book/* ${TARGET_DIR}/
mkdir ${TARGET_DIR}/ru/
cp -r ./ru/_book/* ${TARGET_DIR}/ru/
mkdir ${TARGET_DIR}/ko/
cp -r ./ko/_book/* ${TARGET_DIR}/ko/
mkdir ${TARGET_DIR}/fa/
cp -r ./fa/_book/* ${TARGET_DIR}/fa/
mkdir ${TARGET_DIR}/vi/
cp -r ./vi/_book/* ${TARGET_DIR}/vi/
cp -r ./_dev/* ${TARGET_DIR}/
cp CNAME ${TARGET_DIR}/
cp robots.txt ${TARGET_DIR}/
cp -r ./resources/* ${TARGET_DIR}/resources/

pushd ${TARGET_DIR}
git config user.name "Auto build"
git config user.email "webcirque@gmail.com"

git add -A
git commit -m 'update'
git push "https://${GITHUB_TOKEN}@github.com/webcirque/v2ray-man.git" master
popd
