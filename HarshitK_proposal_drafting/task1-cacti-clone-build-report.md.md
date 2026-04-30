 
# Clone + Build Cacti Report

## Project overview
From my understanding, Hyperledger Cacti is a plaggable tool that lets different blockchains talk to each other and share information without having to merge into a single network.
Basically it solves the problem of fragmentation in blockchain domain, where each ledger is isolated and developers would otherwise have to build custom integrations for every network pairs. 
Cacti uses plugins and connectors, so new ledgers can be supported without redesigning the whole system.

## What I did
I built Hyperledger Cacti by first cloning the repository, then opening it in VS Code and building it inside the Dev Container so the environment would match the project’s expected setup.  
The first issue I hit was the Linux file-watch limit, which surfaced as `ENOSPC` / `Internal watch failed: watch ENOSPC` when the repo became large enough to overwhelm inotify. I confirmed that this is a known Cacti problem from the project FAQ and fixed it by increasing `fs.inotify.max_user_watches` and reloading sysctl, which let the watcher system handle the repository’s size. I feel this should have been mentioned in BUILD.md as troubleshooting steps.
 

I again ran into issue and on analysing the logs, Trivy feature installation was failing inside the Dev Container, where the automated feature download produced a `gzip: stdin: not in gzip format` error. Rather than relying on the broken container feature, I removed that automated Trivy step from  and installed Trivy manually inside the running container using the official package-repository method, which gave me a stable and visible install path. 

After those fixes, I reran `yarn run configure` and completed the build successfully, which compiled the core Cacti packages and prepared the workspace for development. I then generated the API server configuration with `npm run generate-api-server-config` and launched the API server to verify the build end-to-end; the server reported that Cacti API was reachable and launched OK. 
In short, the build process was not a one-click experience, but a careful sequence of environment tuning, dependency stabilization, and verification. I treated each failure as a systems problem, used the project docs and logs to identify the root cause, and kept iterating until the monorepo was fully built and the API server was running. 
### Screenshot 1
![succesfull dev container build](image.png)

### Screenshot 2
![yarn config ran ](Screenshot_TASK1.png)

## Screenshot 3
![run config ](image-1.png)

## Screeshot 4
![ran Cactus API server with .config.json](image-2.png)

 
 ## Screenshot 5 
 ![trivy was failing to install v0.52.1 had to comment out and install latest seperately](image-3.png)