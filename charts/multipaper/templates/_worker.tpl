
{{/*
Expand the name of the worker chart.
*/}}
{{- define "multipaper.worker.name" -}}
{{- default .Chart.Name .Values.worker.nameOverride | trunc 63 | trimSuffix "-" }}-worker
{{- end }}

{{/*
Create a default fully qualified worker app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "multipaper.worker.fullname" -}}
{{- if .Values.worker.fullnameOverride }}
{{- .Values.worker.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.worker.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name "worker" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "multipaper.worker.labels" -}}
helm.sh/chart: {{ include "multipaper.chart" . }}
{{ include "multipaper.selectorLabels.worker" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for MultiPaper worker node
*/}}
{{- define "multipaper.selectorLabels.worker" -}}
app.kubernetes.io/name: {{ include "multipaper.worker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/multipaper-instance: worker
{{- end }}
