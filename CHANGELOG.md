# Changelog

Tutte le modifiche importanti a questo progetto saranno documentate in questo file.

Il formato è basato su [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
e questo progetto aderisce al [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Supporto per profili Spring (dev, prod, test)
- Test di integrazione completi
- Pipeline CI/CD con GitHub Actions
- Security scan con Trivy
- Dependency vulnerability check
- Documentazione completa

### Changed
- Aggiornato Spring Boot da 2.7.2 a 3.4.11
- Migrato da Java 11 a Java 17
- Migliorato Dockerfile con multi-stage build
- Ottimizzati manifest Kubernetes per produzione

### Fixed
- Problemi di sicurezza nei container
- Configurazioni Kubernetes non ottimali
- Mancanza di health checks appropriati

## [1.0.0] - 2024-11-11

### Added
- Applicazione Spring Boot base
- Integrazione con Kubernetes ConfigMaps
- Controller REST per demo
- Dockerfile base
- Manifest Kubernetes per deployment
- Configurazione Nexus3

### Features
- Endpoint `/` che mostra configurazione da ConfigMap
- Caricamento configurazioni da `application.properties`
- Override configurazioni tramite Kubernetes ConfigMap
- Deployment su Kubernetes con Service NodePort

## [0.0.1-SNAPSHOT] - Versione originale

### Added
- Setup iniziale del progetto
- Configurazione Maven base
- Struttura package it.alf.testk8s