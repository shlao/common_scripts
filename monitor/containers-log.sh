#!/bin/bash

function collect_crictl_containers_logs() {
    for i in `crictl  ps |grep -v CONT|awk '{print $1}'`
    do
    ls |grep "$i" 1>/dev/null
    if [[ $? != 0 ]]; then
        name=$(crictl inspect $i| grep "\"name\":" | head -1 | awk '{print $NF}' | sed 's/"//g')
        $(crictl logs -f $i >"$i-$name-log.txt" 2>&1) &
    fi
    done
}

function collect_podman_containers_logs() {
    for i in `podman ps |grep -v CONT|awk '{print $1}'`
    do
    ls |grep "$i" 1>/dev/null
    if [[ $? != 0 ]]; then
        name=$(podman inspect $i| grep "\"name\":" | head -1 | sed 's/"//g' | sed 's/,//g' | sed 's#/# #g' | awk '{print $NF}')
        $(podman logs -f $i >"$i-$name-log.txt" 2>&1) &
    fi
    done
}

while [ 1 ]
do
    collect_crictl_containers_logs
    collect_podman_containers_logs
    sleep 1
done
