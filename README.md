# Healthcare Claims Status API — Azure DevOps CI/CD Pipeline

[![Build Status](https://dev.azure.com/cslpin5/healthcare-claims-api/_apis/build/status%2Fsreelasya22.healthcare-claims-api?branchName=dev)](https://dev.azure.com/cslpin5/healthcare-claims-api/_build/latest?definitionId=1&branchName=main)

## What This Project Does
A Java Spring Boot REST API that simulates a healthcare insurance claims
status system — similar to systems used in real healthcare IT platforms
like Trizetto. The focus is the professional-grade Azure DevOps CI/CD
pipeline that builds, tests, and deploys it automatically.

## Architecture
GitHub (source code)  
→ Azure DevOps (pipeline trigger)  
→ Build Stage (compile + unit tests + JAR)  
→ Dev Deploy (Azure App Service — Dev environment)  
→ Cert Deploy (Azure App Service — Cert, with approval gate)

## Tech Stack
| Technology   | Version | Purpose                          |
|--------------|---------|----------------------------------|
| Java         | 17      | Application language             |
| Spring Boot  | 3.2.x   | REST API framework               |
| Maven        | 3.9.x   | Build and dependency management  |
| Azure DevOps | -       | CI/CD pipelines + Boards         |
| Azure App Svc| -       | Cloud hosting (Dev + Cert)       |

## Pipeline Stages
1. **Build** — Triggered on every push. Compiles code, runs unit tests,
   packages JAR, publishes artifact.
2. **Deploy Dev** — Triggered on merge to dev. Deploys to Dev App Service.
3. **Deploy Cert** — Triggered on merge to main. Requires manual approval.
   Deploys to Cert App Service.

## API Endpoints
| Endpoint     | Method | Response                  |
|--------------|--------|---------------------------|
| /health      | GET    | { "status": "UP" }        |
| /claims      | GET    | List of all claim records |
| /claim/{id}  | GET    | Single claim by ID        |

## Run Locally
```bash
mvn spring-boot:run
# Visit http://localhost:8080/health
