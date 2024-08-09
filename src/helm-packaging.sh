#!/bin/bash

# ROOT_PATH=/playcecloud/playcekube-charts
ROOT_PATH=$(readlink -f $(dirname $0)/..)

# playcekube chart namespace
CHART_SUBPATH_LIST="kube-system playcekube playcekube-dev"

# package all sub path helm chart
for CHART_SUBPATH in ${CHART_SUBPATH_LIST}
do
  for CHART_NAME in $(ls ${ROOT_PATH}/src/${CHART_SUBPATH})
  do
    for CHART_VERSION in $(ls ${ROOT_PATH}/src/${CHART_SUBPATH}/${CHART_NAME})
    do
      helm package ${ROOT_PATH}/src/${CHART_SUBPATH}/${CHART_NAME}/${CHART_VERSION}/${CHART_NAME} -d ${ROOT_PATH}/${CHART_SUBPATH}
    done
  done
done

helm repo index ${ROOT_PATH}

