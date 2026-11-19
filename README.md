# grades-platform

A small monorepo for the CI/CD meeting of the DevOps & MLOps course. Its layout follows the capstone of the
DevOps Directive GitHub Actions course (https://github.com/sidpalas/capstone).

```
.github/actions/setup-service/   composite action: the tools one service needs on the runner
.github/utils/                   file-filters.yaml (which files belong to which service), release-please config
.github/workflows/               empty: you write the workflows in the lab
services/python/grades-api/      FastAPI service: /health, POST /average
services/python/grades-report/   CLI: a one-line summary of data/grades.csv
services/web/grades-web/         a static page on nginx
deploy/<environment>/apps.yaml   what runs in each environment (Kubernetes manifests; the CI edits the image lines)
scripts/                         version.sh (git describe), set-image.sh, commit-push.sh
homework/release-please.yaml     the release workflow, for part D
```

Every service answers the same two commands, so one CI job fits all of them:

```bash
cd services/python/grades-api
make install-ci
make test
```

Create your own repository from this template (**Use this template**, **Public**), open a Codespace on it,
and follow the lab in VeriClass.
