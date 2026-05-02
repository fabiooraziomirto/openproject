# OpenProject Custom — Dark Theme

A custom Docker image of [OpenProject](https://www.openproject.org/) with a dark "tech" theme inspired by Linear and Vercel.

## What's changed

- **Dark theme**: full CSS custom property override (`theme/custom_variables.css`)
- **Fonts**: JetBrains Mono + Inter via Google Fonts
- **Color palette**: dark blues, grays, accent cyan-green
- **Visual polish**: tighter border radius, minimal shadows, clean borders
- **No recompilation**: all changes are injected as static CSS over the pre-built official image

## Project structure

```
theme/               CSS overrides and font definitions
assets/logos/        Custom logo (replace logo.png)
assets/favicons/     Custom favicon (replace favicon.ico)
docker/Dockerfile    Extends openproject/openproject:17-slim
docker/deploy/       Production docker-compose + .env.example
docker/hooks/        Rails initializer injected into the image
scripts/             build.sh, push.sh, deploy.sh helpers
.github/workflows/   GitHub Actions: build + push to ghcr.io on push to main
```

## Quick start (local build)

**Prerequisites**: Docker 24+, Git

```bash
# Build the image
./scripts/build.sh 1.0.0

# Run it (ephemeral, no persistence)
docker run --rm -p 8080:80 \
  -e OPENPROJECT_SECRET__KEY__BASE=$(openssl rand -hex 64) \
  ghcr.io/fabiooraziomirto/openproject:1.0.0
```

Open http://localhost:8080 — you should see the dark theme.

## Production deployment

```bash
cd docker/deploy
cp .env.example .env
# Edit .env with your values

docker compose up -d
```

Update to a new version:

```bash
./scripts/deploy.sh 1.1.0
```

## Customizing the theme

Edit `theme/custom_variables.css` — all values are standard CSS custom properties.
Rebuild and push to apply:

```bash
./scripts/build.sh 1.1.0
./scripts/push.sh 1.1.0
./scripts/deploy.sh 1.1.0
```

## Replacing logo and favicon

Drop your files in:
- `assets/logos/logo.png` (recommended: 200×50px transparent PNG)
- `assets/favicons/favicon.ico`

Then rebuild the image.

## CI/CD (GitHub Actions)

Pushing to `main` automatically builds and pushes to:
- `ghcr.io/fabiooraziomirto/openproject:latest`
- `ghcr.io/fabiooraziomirto/openproject:main`

Pushing a tag like `v1.0.0` additionally creates:
- `ghcr.io/fabiooraziomirto/openproject:1.0.0`
- `ghcr.io/fabiooraziomirto/openproject:1.0`

The workflow uses `GITHUB_TOKEN` — no additional secrets needed.

## Branch protection recommendations

- `main`: require PR review, no force-push, require CI build to pass
- `dev`: require at least 1 reviewer

## How the theme injection works

`docker/hooks/custom_theme.rb` is copied into `/app/config/initializers/` in the
Docker image. It registers a listener on OpenProject's `view_layouts_base_html_head`
hook, called in every page's `<head>`. The listener returns `<link>` tags pointing to
static CSS files in `/app/public/assets/`.

No core OpenProject files are modified. On image rebuild (OpenProject update), the
initializer and CSS are simply re-injected on top of the new base image.

## Updating to a new OpenProject version

1. Update `FROM openproject/openproject:17-slim` in `docker/Dockerfile` to the new tag
2. Rebuild: `./scripts/build.sh <new-version>`
3. Test locally, then push and deploy
