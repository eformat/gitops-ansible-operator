#!/bin/bash

HOST=${HOST:-$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')}
docker login -u $(oc whoami) -p $(oc whoami -t) $HOST
docker build -t gitops-ansible-operator -f build/Dockerfile .
docker tag gitops-ansible-operator:latest ${HOST}/gitops-ansible-operator/gitops-ansible-operator:latest
docker push ${HOST}/gitops-ansible-operator/gitops-ansible-operator:latest
