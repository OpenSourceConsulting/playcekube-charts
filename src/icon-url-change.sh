#!/bin/bash

# ROOT_PATH=/playcecloud/playcekube-charts
ROOT_PATH=$(readlink -f $(dirname $0)/..)

GIT_URL=$(git remote get-url playcekube-charts)
GIT_HOME=$(echo ${GIT_URL} | awk -F "/" '{ print $(NF-1) }')
GIT_BRANCH=$(git branch --show-current)

sed -i "s|raw.githubusercontent.com/[-_+a-zA-Z0-9]*/playcekube-charts|raw.githubusercontent.com/${GIT_HOME}/playcekube-charts|g" ${ROOT_PATH}/src/*/*/*/*/Chart.yaml

