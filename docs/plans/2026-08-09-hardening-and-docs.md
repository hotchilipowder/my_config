# HomeLab Hardening and Docs Fixes Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Remove committed service secrets, harden exposed Docker services, repair deterministic Compose errors, and make the GitHub Pages build generate snippets before building.

**Architecture:** Keep each Docker stack independently deployable. Required secrets will come from environment variables and tracked `.env.example` files, while public-facing services will use explicit safe defaults or read-only mounts. The documentation workflow will use the existing Python project metadata and run content generation before Sphinx.

**Tech Stack:** Docker Compose, Xray, Traefik, Prometheus, Sphinx, GitHub Actions, YAML/JSON.

---

### Task 1: Remove committed secrets and harden service exposure

**Files:**
- Modify: `dockers/aria_filebrowser/docker-compose.yml`
- Create: `dockers/aria_filebrowser/.env.example`
- Modify: `dockers/transmission/docker-compose.yml`
- Create: `dockers/transmission/.env.example`
- Modify: `dockers/traefik/docker-compose.yml`
- Modify: `.gitignore`

**Steps:**
1. Replace the hard-coded Aria2 RPC secret with a required environment variable and make certificate mounts read-only.
2. Replace the hard-coded Transmission password with a required environment variable and fix the downloads directory typo.
3. Disable Traefik's insecure API, make the Docker socket read-only, disable automatic service exposure, and remove the direct whoami host port.
4. Add safe environment templates and ignore local `.env` files.
5. Validate YAML structure and confirm the hard-coded RPC secret value is absent.

### Task 2: Repair deterministic Docker configuration errors

**Files:**
- Modify: `dockers/xray/config.json`
- Modify: `dockers/prom-grafana/docker-compose.yml`
- Modify: `dockers/prom-grafana/prom_confs/prometheus.yml`
- Modify: `docs/rsts/docker.rst`

**Steps:**
1. Fix Xray's duplicate HTTP port, invalid routing strategy, missing API/stats endpoint, and misspelled domain rules; remove unauthenticated proxy listeners whose outbounds are absent.
2. Correct Prometheus's config directory and exporter service name, and connect Prometheus to the external network used by the exporter.
3. Remove the documentation include for the missing ServerStatus Rust Dockerfile rather than documenting a nonexistent file.
4. Validate JSON-with-comments structurally and inspect all changed references.

### Task 3: Make the documentation deployment deterministic

**Files:**
- Modify: `.github/workflows/publish.yml`
- Modify: `pyproject.toml`
- Modify: `README.md`

**Steps:**
1. Set up the declared Python version and install from project metadata.
2. Generate snippets before running Sphinx.
3. Build with warnings treated as errors and grant only the required Pages token permission.
4. Add a useful root README and remove the placeholder project description.
5. Validate Python syntax, Lua syntax, workflow YAML, and the documentation build where dependencies are available.
