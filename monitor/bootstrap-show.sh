#!/bin/bash

function get_manifests_dir()  {
    kubelet_args=$(ps -ef |grep pod-manifest-path |grep -v grep)
    if [[ x"$kubelet_args" == x ]]; then
        echo "/etc/kubernetes/manifests/"
        return
    fi

    echo "/etc/kubernetes/manifests/"
}

me=`basename "$0"`
manifests_path=$(get_manifests_dir)
kube_path="/var/opt/openshift/auth/kubeconfig-loopback"
export KUBECONFIG="${kube_path}"

while [ 1 ]
do
    now=$(date +"%Y-%m-%d-%H:%M:%S")
    echo "=========================================================================="
    echo "$now"
    echo "--------------------------------------------------------------------------"

    oc get pod --all-namespaces
    echo "--------------------------------------------------------------------------"

    ls "${manifests_path}/"
    echo "--------------------------------------------------------------------------"

    podman images
    echo "----------------------------------------"
    crictl images
    echo "--------------------------------------------------------------------------"

    podman ps
    echo "----------------------------------------"
    crictl ps
    echo "--------------------------------------------------------------------------"

    echo "=========================================================================="
    sleep 1
done >$me.log.txt 2>&1
