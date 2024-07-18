#!/bin/bash

SHELLDIR=$(dirname $(readlink -f $0))

PLAYCEKUBE_VERSION=$(git branch --show-current)

CHARTS_ROOT_PATH=${SHELLDIR}
ICON_DEST_PATH=${CHARTS_ROOT_PATH}/assets/icon

mkdir -p ${ICON_DEST_PATH}

WORKTEMP=$(mktemp -d)

# get charts list
for CHART in $(find ${CHARTS_ROOT_PATH} -name "*.tgz")
do
  CHARTNAME=$(echo ${CHART} | awk -F "/" '{ print $NF }' | sed "s/\(.*\)-[^-]*/\1/g")

  tar zxf ${CHART} -C ${WORKTEMP}
  cd ${WORKTEMP}/${CHARTNAME}

  OLDCHARTNAME=$(yq .icon Chart.yaml)
  yq -i ".icon = \"https://github.com/OpenSourceConsulting/playcekube-charts/blob/${PLAYCEKUBE_VERSION}${OLDCHARTNAME}\"" Chart.yaml

  helm package ${WORKTEMP}/${CHARTNAME} -d $(dirname ${CHART})
done

# index.yaml update
helm repo index ${CHARTS_ROOT_PATH}

# change shell run directory
cd ${SHELLDIR}

# clean
rm -rf ${WORKTEMP}

