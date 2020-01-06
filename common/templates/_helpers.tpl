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
{{- else if has .Chart.Name (values (merge (dict) .Values.global.HelmNames.Omniscience .Values.global.HelmNames.TestingService .Values.global.HelmNames.TestingWeb )) }}
{{- $appSettingLocation = "omniscience-" }}
{{- else if has .Chart.Name (values .Values.global.HelmNames.IdentityServer ) }}
{{- $appSettingLocation = "identityserver-" }}
{{- end }}
{{- printf "%sappsettings-%s-%s-%s-cm" $appSettingLocation .Release.Namespace .Values.global.ClientStateName .Values.global.Environment | lower -}}
{{- end -}}


{{- define "dpapi_key_location" -}}
{{- if .Values.global.DisableDataProtectionSecret }}
{{- else if has .Chart.Name (values (merge (dict) .Values.global.HelmNames.ExternalWeb .Values.global.HelmNames.InternalWeb ) ) }}
- name: DataProtectionKeyPath
  value: "/app/dpapi"
{{- end -}}
{{- end -}}

{{- define "dpapi_secret_volume" -}}
{{- $identifier := (printf "web-dpapi-%s-%s-%s" .Release.Namespace .Values.global.ClientStateName .Values.global.Environment) | lower -}}
{{- if .Values.global.DisableDataProtectionSecret }}
{{- else if has .Chart.Name (values (merge (dict) .Values.global.HelmNames.InternalWeb .Values.global.HelmNames.TestingWeb )) }}
- name: dpapi-secret
  secret:
    secretName: {{ printf "internal-%s-secret" $identifier }}
{{- else if has .Chart.Name (values .Values.global.HelmNames.ExternalWeb ) }}
- name: dpapi-secret
  secret:
    secretName: {{ printf "external-%s-secret" $identifier }}
{{- end -}}
{{- end -}}

{{- define "dpapi_volume_mount" }}
{{- if .Values.global.DisableDataProtectionSecret }}
{{- else if has .Chart.Name (values (merge (dict ) .Values.global.HelmNames.ExternalWeb .Values.global.HelmNames.InternalWeb .Values.global.HelmNames.TestingWeb ) ) }}
- name: dpapi-secret
  mountPath: /app/dpapi
{{- end -}}
{{- end -}}
