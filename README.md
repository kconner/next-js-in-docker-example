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
- [ ] TypeScript

## How to use this

- Clone the repo.
- Install Docker and VS Code.
- Open app.code-workspace. VS Code will recommend a Docker plugin if you don't have it, so install that.
- `docker-compose.yml` prepares a release archive. Right-click it and select Compose Up to build and run in release mode.
- `docker-compose.debug.yml` prepares a testing container. Right-click it and select Compose Up to build and run in debug mode.
- With either container running, visit localhost:3000 to view the site.
- With the debug container running, save a code file to hot-reload the browser.
- With the debug container running, select Start Debugging from the Debug menu to attach the debugger. Then click in VS Code's gutter to set breakpoints.
- Right click again and select Compose Down to stop.
