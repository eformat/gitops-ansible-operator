# gitops-ansible-operator

A simple GitOps ansible operator that applies configuration for a cluster.

The configuration of a cluster is stored in this git repo

- https://github.com/eformat/openshift-cluster-config

The directory structure in `openshift-cluster-config` is as follows:

```
openshift-cluster-config$ tree
.
├── cluster-foo                      # Cluster Name
│   ├── absent                       # Config to Add
│   └── present                      # Config to Remove
│       ├── 000-foobar.yml
│       └── 001-github-secret.yml
└── README.md
```
Sync period for the `GitOps` CRD is set using the annotation
```
  ansible.operator-sdk/reconcile-period: "30s"  
```
The `CR` has the following configuration parameters:
```
  git_url: "https://github.com/eformat/openshift-cluster-config.git"     # URL of cluster repo
  git_dir: "/tmp/openshift-cluster-config"                               # temp directory within operator pod (could become a PV/PVC)
  git_context_dir: "cluster-foo"                                         # Cluster Name (also directory name in git repo)
```

## Create the Operator in the Cluster

Build
```
oc new-project gitops-ansible-operator
docker build -t gitops-ansible-operator -f build/Dockerfile .
```
Tag and Push
```
HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
docker login -u $(oc whoami) -p $(oc whoami -t) $HOST
docker tag gitops-ansible-operator:latest ${HOST}/gitops-ansible-operator/gitops-ansible-operator:latest
docker push ${HOST}/gitops-ansible-operator/gitops-ansible-operator:latest
```
Create cluster operator resources
```
oc create -f deploy/crds/eformat_v1alpha1_gitops_crd.yaml
oc create -f deploy/service_account.yaml
oc create -f deploy/role.yaml
oc create -f deploy/role_binding.yaml
oc create -f deploy/operator.yaml
```

## Create GitOps instance

```
oc create -f deploy/crds/eformat_v1alpha1_gitops_cr.yaml
```

Permissions (needs refining)

```
--
-- make  gitops-ansible-operator sa a cluster admin for now
--
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:gitops-ansible-operator:gitops-ansible-operator
```