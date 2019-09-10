# Mess with Node in Docker

I want to set up a Node application that runs in Docker and that I can debug from VS Code.

Then I'd like to implement both development and production branches of this behavior. I think that will mean multi-stage Docker builds for compact deployment containers.

Then I'd like to try this with a Next.js app, which changes the nature of how you build and run.

Check my commit messages to see the tutorial articles I'm following.

---

I got this working in Next.js, for debug mode.

For release mode, I need to:

- npm run build
- copy .next from the build container to the release container
- maybe prune nonproduction packages? is it correct to leave build-related packages out of the production set?
