FROM quay.io/operator-framework/ansible-operator:v0.8.0

USER root
RUN yum -y install git && yum clean all && rm -rf /var/cache/yum

COPY watches.yaml ${HOME}/watches.yaml
COPY roles/ ${HOME}/roles/
COPY playbook.yml ${HOME}/playbook.yml


