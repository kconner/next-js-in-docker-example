# Mess with Node in Docker

I want to set up a Node application that runs in Docker and that I can debug from VS Code.

Then I'd like to implement both development and production branches of this behavior. I think that will mean multi-stage Docker builds for compact deployment containers.

Then I'd like to try this with a Next.js app, which changes the nature of how you build and run.

Check my commit messages to see the tutorial articles I'm following.

## Plans

- [x] Node app in Docker
- [x] Debuggable in VS Code
- [x] Debug and Release container variants
- [x] Next.js
- [x] TypeScript
- [x] Allow launching Storybook at the test stage
- [x] Allow running CI tools at the test stage
- [x] Allow debugging individual tests
- [x] Use multi-stage Docker builds
- [x] Use layer caching for efficient builds
- [x] Deploy to Kubernetes with kubectl

## How this setup uses Docker

- `Dockerfile` describes a multi-stage build.
    - The test stage includes a copy of the checked out workspace with all packages installed. The builds for the CI and debug services stop here.
    - The build stage continues by removing development packages and preparing a release build.
    - The archive stage starts fresh and copies in just what's needed at runtime for a small release container.
- `docker-compose.yml` prepares a development environment including a debuggable web server and a Storybook server.
- `scripts/build-image.sh` performs a build to any stage listed in the Dockerfile and optionally pushes the build and archive images to the container registery.
- `scripts/deploy-image.sh` deploys a container from a registry to a Kubernetes cluster with `kubectl apply`, or optionally deletes it with `kubectl delete`.

## How to use this setup

- Clone the repo.
- Install Docker and VS Code.
- Open `app.code-workspace`. VS Code will recommend a Docker plugin if you don't have it, so install that.
- To develop in Docker, right-click `docker-compose.yml` and select Compose Up.
    - Canonically, `docker-compose up` will start debug mode too. Add `--build` if you have made changes since last time.
    - In VS Code's activity bar, click the Docker icon to view running containers.
    - Visit localhost:3000 to view the site.
    - Visit localhost:6006 to view Storybook. It may take a moment for the Storybook server to start after docker-compose launches its container.
    - Save a code file to hot-reload the browser.
    - Select Start Debugging from the Debug menu to attach the debugger. Then click in VS Code's gutter to set breakpoints. In this example, only the web server is debuggable, not Storybook.
    - To stop, right-click again and select Compose Down, or use `docker-compose down`.
- In addition to the Docker debugger attachment launcher, VS Code launchers also exist for debugging locally, including the web server, all unit tests, and a single unit test file.
- To build, test, and deploy in a continuous integration environment:
    - Use `./scripts/build-image.sh` with `--image` and `--target test-target` to build a CI test image.
    - Use `./scripts/test-image.sh` to run tests in the CI test image.
    - Use `./scripts/build-image.sh` with `--image`, `--version`, and `--push` to build a release archive and push to the registry. Pushing at this step also caches the build image's layers for later incremental builds.
    - Use `./scripts/deploy-image.sh` with `--image` and `--version` to deploy the built release archive.
