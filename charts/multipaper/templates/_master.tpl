{{/*
Expand the name of the master chart.
*/}}
{{- define "multipaper.master.name" -}}
{{- default .Chart.Name .Values.master.nameOverride | trunc 63 | trimSuffix "-" }}-master
{{- end }}

{{/*
Create a default fully qualified master app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "multipaper.master.fullname" -}}
{{- if .Values.master.fullnameOverride }}
{{- .Values.master.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.master.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" .Release.Name $name "master" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "multipaper.master.labels" -}}
helm.sh/chart: {{ include "multipaper.chart" . }}
{{ include "multipaper.selectorLabels.master" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for MultiPaper master
*/}}
{{- define "multipaper.selectorLabels.master" -}}
app.kubernetes.io/name: {{ include "multipaper.master.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/multipaper-instance: master
{{- end }}
