#!/usr/bin/env bash
BASE_DIR=$(dirname "$0")
source ${BASE_DIR}/utils.sh



function main {
    mkdir -p /opt/kubeoperator >/dev/null 2>&1
    cp -rp ${SCRIPTS_DIR}/service/kubeops.service /etc/systemd/system/
    cp -rp ${PROJECT_DIR}/* /opt/kubeoperator/
    chmod -R 777 /opt/kubeoperator/data
}
main