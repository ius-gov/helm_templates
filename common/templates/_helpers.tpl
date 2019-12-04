{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Create a url from root scope
*/}}
{{- define "common.url" -}}
{{- include "common.url.dict" (dict "state" .Values.global.ClientStateName "environment" .Values.global.Environment "serviceName" .Chart.Name  "globalhost" .Values.global.ingress.host) -}}
{{- end -}}

{{/*
Create a url from dictionary 
*/}}
{{- define "common.url.dict" -}}
{{- printf "%s-%s-%s.%s" .state .environment .serviceName .globalhost | lower -}}
{{- end -}}

{{/*
Create an http url 
*/}}
{{- define "common.url.http" -}}
{{- printf "http://%s" . -}}
{{- end -}}

{{/*
Create an https url 
*/}}
{{- define "common.url.https" -}}
{{- printf "https://%s" . -}}
{{- end -}}

{{/*
appsettings-cm name
*/}}
{{- define "common.appsettings.name" -}}
{{- $appSettingLocation := "" }}
{{- if has .Chart.Name (values .Values.global.HelmNames.ExternalWeb ) }}
{{- $appSettingLocation = "external-web-" }}
{{- else if has .Chart.Name (values .Values.global.HelmNames.Gateway ) }}
{{- $appSettingLocation = "gateway-" }}
{{- else if has .Chart.Name (values .Values.global.HelmNames.ExternalService ) }}
{{- $appSettingLocation = "external-service-" }}
{{- else if has .Chart.Name (values .Values.global.HelmNames.InternalService ) }}
{{- $appSettingLocation = "internal-service-" }}
{{- else if has .Chart.Name (values .Values.global.HelmNames.InternalWeb ) }}
{{- $appSettingLocation = "internal-web-" }}
{{- else if has .Chart.Name (values .Values.global.HelmNames.InternalReport ) }}
{{- $appSettingLocation = "internal-report-" }}
{{- else if has .Chart.Name (values .Values.global.HelmNames.InternalProcessor ) }}
{{- $appSettingLocation = "internal-processor-" }}
{{- else if has .Chart.Name (values .Values.global.HelmNames.Omniscience ) }}
{{- $appSettingLocation = "omniscience-" }}
{{- else if has .Chart.Name (values .Values.global.HelmNames.IdentityServer ) }}
{{- $appSettingLocation = "omniscience-" }}
{{- end }}
{{- printf "%sappsettings-%s-%s-%s-cm" $appSettingLocation .Release.Namespace .Values.global.ClientStateName .Values.global.Environment | lower -}}
{{- end -}}


