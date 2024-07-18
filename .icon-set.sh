#!/bin/bash

SHELLDIR=$(dirname $(readlink -f $0))

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

  ICONURL=$(yq .icon Chart.yaml)
  if [ "${ICONURL}" != "" ] && [ "${ICONURL}" != "null" ]; then
    ICONEXT=$(echo "${ICONURL}" | cut -d "?" -f 1 | awk -F "/" '{ print $NF }' | awk -F "." '{ print $NF }' | sed "s/[^a-zA-Z]*//g")
    if [ "${ICONEXT}" == "" ] || [ "${ICONEXT}" == "" ]; then
      ICONEXT=icon
    fi
    curl -s -L "${ICONURL}" -o icon.temp
    if [ -s icon.temp ]; then
      mv -f icon.temp ${ICON_DEST_PATH}/${CHARTNAME}-icon.${ICONEXT}
    fi
    yq -i ".icon = \"/assets/icon/${CHARTNAME}-icon.${ICONEXT}\"" Chart.yaml

    helm package ${WORKTEMP}/${CHARTNAME} -d $(dirname ${CHART})
  fi
done

# index.yaml update
helm repo index ${CHARTS_ROOT_PATH}

# change shell run directory
cd ${SHELLDIR}

# clean
rm -rf ${WORKTEMP}

