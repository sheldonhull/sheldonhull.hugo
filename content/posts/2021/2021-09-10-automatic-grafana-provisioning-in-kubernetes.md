---

date: 2021-09-10T20:11:44+0000
title: Automatic Grafana Provisioning in Kubernetes
slug: automatic-grafana-provisioning-in-kubernetes
tags:

- tech
- development
- microblog

draft: true

# images: [/images/]

typora-root-url: ../../../static
typora-copy-images-to:  ../../../static/images
---

Kubernetes is complex, but some things as user new to k8s just seem freaking magical.

Let's say you want to deploy Prometheus and Grafana into a k8 cluster so you can track a few metrics.
By default, the Grafana provisioning will be empty and you'll have to configure the Prometheus datasource manually, import your dashboards, and go through this each time you do local development tear downs.

Grafana provisioning can be done automatically with a few simple steps.
The end result is a Grafana deployment that is:

- Preconfigured to your prometheus datasource.
- Dashboards pre-populated and adjusted to your defined datasource.
- Dashboards that are managed via code so drift doesn't occur.

## Setup

This is in a simple format used by [Task](https://taskfile.dev/#/).

```yaml
---
version: '3'
output: prefixed
silent: true
vars:
  TARGET_NAMESPACE: grafana
tasks:
  deploy:monitoring:
    desc: Enable monitoring with Prometheus and Grafana
    prefix: 🚀
    summary: |
      Cool examples of provisioning with kubernetes at runtime: https://github.com/gurpreet0610/Deploy-Prometheus-Grafana-on-Kubernetes/blob/master/Grafana/grafana-datasource-config.yaml
    cmds:
      - |
        helm repo update
        helm repo add grafana https://grafana.github.io/helm-charts

        kubectl get namespaces {{ .TARGET_NAMESPACE }} || (kubectl create namespace {{ .TARGET_NAMESPACE }}  && echo "created {{ .TARGET_NAMESPACE }} namespace")
        (kubectl get pods -n {{ .TARGET_NAMESPACE }} && echo "✅  {{ .TARGET_NAMESPACE }} exists") || kubectl create namespace {{ .TARGET_NAMESPACE }}

        helm repo add bitnami https://charts.bitnami.com/bitnami || echo "⏩  helm repo add prometheus-operator"
        helm upgrade prometheus bitnami/kube-prometheus --install --force -n {{ .TARGET_NAMESPACE }} -f ./charts/prometheus/override.yml || echo "⏩  prom already installed"

        # Example of loki stack, not functional yet but will be soon.
        # Stack with logging using loki, not functional yet
        # helm upgrade --install loki grafana/loki-stack --force -n {{ .TARGET_NAMESPACE }} \
        #   --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false \
        #   -f ./charts/grafana/override.yml \
        #   -f ./charts/grafana/datasources.yml \
        #   -f ./charts/grafana/dashboards.yml \
        #  || echo "⏩  helm install grafana grafana/grafana"
        # GRAFANA_SECRET=$(kubectl get secret --namespace {{ .TARGET_NAMESPACE }} loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)

        helm upgrade grafana grafana/grafana --install --force -n {{ .TARGET_NAMESPACE }}  \
          -f ./charts/grafana/override.yml \
          -f ./charts/grafana/datasources.yml \
          -f ./charts/grafana/dashboards.yml \
        || echo "⏩  helm install grafana grafana/grafana"
        GRAFANA_SECRET=$(kubectl get secret --namespace {{ .TARGET_NAMESPACE }} grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
        echo "🕵️ Grafana Secret (only for pilot testing): $GRAFANA_SECRET"
        export POD_NAME=$(kubectl get pods --namespace {{ .TARGET_NAMESPACE }} -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
        echo "🔌 POD_NAME: $POD_NAME"

        kubectl get pods -n {{ .TARGET_NAMESPACE }}

        # echo "Enabling port forwarding"
        # kubectl --namespace {{ .TARGET_NAMESPACE }} port-forward $POD_NAME 3000
        echo "🔌  URL: $($POD_NAME):3000"
        kubectl get svc -n {{ .TARGET_NAMESPACE }}
        echo "TIP: ℹ the connection will probably be: http://prometheus-kube-prometheus-prometheus.{{ .TARGET_NAMESPACE }}:9090 in grafana"
        echo -e "{{ .green }} ✅ {{ .TASK }} complete {{ .nocolor }}"

```
