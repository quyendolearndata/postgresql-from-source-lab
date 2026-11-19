# Learn PostgreSQL from source lab

Hands-on lab: build PostgreSQL from upstream source and learn internals toward a DE platform mindset.

## Goal

- Build from source
- Apply SQL on an instance you built
- Read and reason about source modules
- Grow toward DE platform skills on that foundation

## Where am I?

Track progress here (update as you go):

- [docs/LEARNING-PROGRESS.md](docs/LEARNING-PROGRESS.md) — phases, checklist, next step (Data Platform Engineer track)
- [docs/LEARNING-PROGRESS-FRESHMAN.md](docs/LEARNING-PROGRESS-FRESHMAN.md) — phiên bản 2–3 năm dành cho sinh viên năm nhất
- [docs/c4/](docs/c4/) — C4 architecture diagrams (PNG in `export/`)

## Upstream source

`postgres-src/` is a local clone of PostgreSQL (gitignored). Clone it yourself if missing:

```bash
git clone https://github.com/postgres/postgres.git postgres-src
```

