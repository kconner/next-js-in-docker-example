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
- [ ] Allow running CI tools at the test stage

## How this setup uses Docker

- `docker-compose.yml` prepares a release archive and runs a production web server.
- `docker-compose.debug.yml` prepares a test container and runs a debuggable web server.
- `docker-compose.storybook.yml` prepares a test container and runs Storybook.
- `Dockerfile` describes a multi-stage build.
    - The test stage includes a copy of the checked out workspace with all packages installed. The build for the debug container stops here. The release case could run CI tools at this stage. 
    - The build stage continues by removing development packages and preparing a release build.
    - The archive stage starts fresh and copies in just what's needed at runtime for a small release container.

## How to use this setup

- Clone the repo.
- Install Docker and VS Code.
- Open `app.code-workspace`. VS Code will recommend a Docker plugin if you don't have it, so install that.
- To build and run, right-click `docker-compose.yml` for release mode or `docker-compose.debug.yml` for debug mode and select Compose Up.
- With either container running, visit localhost:3000 to view the site.
- With the debug container running, save a code file to hot-reload the browser.
- With the debug container running, select Start Debugging from the Debug menu to attach the debugger. Then click in VS Code's gutter to set breakpoints.
- Right-click again and select Compose Down to stop.
- Use `docker-compose.storybook.yml` to run Storybook at localhost:6006. It may take a moment for the server to start after the container launches.
