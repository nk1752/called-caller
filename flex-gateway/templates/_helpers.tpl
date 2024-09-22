{{/* vim: set filetype=mustache: */}}

{{- define "gateway.mode" -}}
{{- if and (eq .Values.gateway.mode "local") (.Values.ingressClass.enabled) -}}
{{- print "ingress" -}}
{{- else -}}
{{- print .Values.gateway.mode -}}
{{- end -}}
{{- end -}}

/*
Is gateway configured as ingress
*/
{{- define "gateway.mode.isIngress" -}}
{{- if (eq (include "gateway.mode" .) "ingress") -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}

/*
 Gateway log level mapping
*/
{{- define "gateway.logLevel" -}}
    {{- with (((.Values.gateway.configuration).logging).runtimeLogs).logLevel }}
        {{- if (eq . "error") -}}
            {{- print "1" -}}
        {{- else if (eq . "warn") -}}
            {{- print "2" -}}
        {{- else if (eq . "debug") -}}
            {{- print "8" -}}
        {{- else -}}
            {{- print "4" -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

/*
 Gateway Configuration
*/
{{- define "gateway.configuration" -}}
---
apiVersion: gateway.mulesoft.com/v1beta1
kind: Configuration
metadata:
  name: configuration
spec:
  {{- toYaml .Values.gateway.configuration | nindent 2 -}}
{{- end -}}

/* Ingress Class name */
{{- define "ingressClass.name" -}}
{{- if .Values.ingressClass.name -}}
{{- print .Values.ingressClass.name -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Release.Namespace -}}
{{- end -}}
{{- end -}}

/* Ingress controller value for ingress class */
{{- define "ingressClass.controllerValue" -}}
{{- printf "flex.mulesoft.com/%s" (include "ingressClass.name" .)}}
{{- end -}}

{{- define "gateway.concurrency" -}}
    {{- with .Values.resources.limits.cpu }}
        {{- if (hasSuffix "m" (toString .)) -}}
            {{- print (max 1 (div (trimSuffix "m" .) 1000)) | quote -}}
        {{- else -}}
            {{- print (max 1 (floor (toString .))) | quote -}}
        {{- end -}}
    {{- end -}}
{{- end -}}