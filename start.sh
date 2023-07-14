#!/bin/bash

RELEASE_PAGE=$(curl -sSL https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/)
CHANGELOGS_PAGE=$(curl -sSL https://changelogs-live.fivem.net/api/changelog/versions/linux/server)

if [[ "${AUTO_UPDATE}" == true ]] || [[ "${AUTO_UPDATE}" == TRUE ]]; then
    DOWNLOAD_LINK=(echo "${RELEASE_PAGE}" | jq -r '.latest_download')

    rm -r /home/container/alpine

    echo -e "Downloading latest version of FiveM..."

    curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
    echo "Extracting fivem files"
    tar -xvf ${DOWNLOAD_LINK##*/}
    rm -rf ${DOWNLOAD_LINK##*/} run.sh
fi

if [[ "${AUTO_UPDATE}" == false ]] || [[ "${AUTO_UPDATE}" == FALSE ]]; then
    echo -e "Not downloading latest version of FiveM..."
fi


if [[ "${CHANGELOGS}" == true ]] || [[ "${CHANGELOGS}" == TRUE ]]; then
    echo -e "Showing changelogs..."
    echo -e "${CHANGELOGS_PAGE}"
fi


## Run the Server

echo -e "Starting FiveM Server..."

$(pwd)/alpine/opt/cfx-server/ld-musl-x86_64.so.1 --library-path "$(pwd)/alpine/usr/lib/v8/:$(pwd)/alpine/lib/:$(pwd)/alpine/usr/lib/" -- $(pwd)/alpine/opt/cfx-server/FXServer +set citizen_dir $(pwd)/alpine/opt/cfx-server/citizen/ +set serverProfile default +set txAdminPort {{TXADMIN_PORT}}






