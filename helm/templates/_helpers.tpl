{{/* vim: set filetype=mustache: */}}

{{/* Expand the name of the chart. */}}
{{- define "bitwarden.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create a default fully qualified app name. We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec). */}}
{{- define "bitwarden.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Common labels */}}
{{- define "bitwarden.labels" -}}
app.kubernetes.io/name: {{ include "bitwarden.name" . }}
helm.sh/chart: {{ include "bitwarden.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/* Labels to use on {deploy|sts}.spec.selector.matchLabels and svc.spec.selector */}}
{{- define "bitwarden.matchLabels" -}}
app.kubernetes.io/name: {{ include "bitwarden.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/* Create chart name and version as used by the chart label. */}}
{{- define "bitwarden.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Renders a value that contains template. Usage: {{ include "bitwarden.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }} */}}
{{- define "bitwarden.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/* Return  the proper Storage Class */}}
{{- define "bitwarden.storageClass" -}}
{{/* Helm 2.11 supports the assignment of a value to a variable defined in a different scope, but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic. */}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.storageClass -}}
              {{- if (eq "-" .Values.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.storageClass -}}
        {{- if (eq "-" .Values.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}
