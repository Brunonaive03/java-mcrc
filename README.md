# Java Docker Environment

Dockerized environment for a Java practical assignment from the Centro de Informática (CIn/UFPE).

## Overview

The environment keeps Java and the necessary tooling inside a Linux Docker container while the exercise files remain in `workspace/` on the host machine.

The basic workflow is:

```text
Java source (.java)
        │
        │ javac
        ▼
Java bytecode (.class)
        │
        │ java
        ▼
Execution / Output
```

This repository uses **JDK 21** in the container.

## Repository structure

```text
.
├── Dockerfile
├── docker-compose.yml
├── README.md
│
├── scripts/
│   ├── compile-java.bat
│   ├── compile-java.sh
│   ├── run-java.bat
│   ├── run-java.sh
│   ├── run-soot.bat
│   └── run-soot.sh
│
└── workspace/
    └── Test.java
```

`workspace/` is the working area for the exercises. Generated files and additional working material are intentionally kept out of version control, with the exception of `Test.java`.

## Requirements

Only the following are required on the host:

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Git, if you want to clone the repository or the exercise repositories

You **do not need to install Java/JDK on the host**. Java 21 is provided by the Docker image.

Because the container is Linux-based, Docker Desktop must have its Linux container engine running.

Check the Docker installation with:

```powershell
docker version
docker compose version
```

`docker version` should show both the Docker Client and Docker Server sections.

## Docker environment

The container provides the Java/tooling environment used by the exercises. The repository's `workspace/` directory is mounted at `/workspace` inside the container.

Conceptually:

```text
Windows / Linux / macOS host
        │
        │ ./workspace
        ▼
Docker container
        │
        └── /workspace
              ├── Test.java
              └── *.class
```

This means files produced by Java are immediately visible in the host's `workspace/` directory.

## Starting the container

From the repository root, run the following Docker Compose commands:

```bash
# Build the container image
docker compose build

# Start the container in detached mode
docker compose up -d
```

### Do I need to attach?

No. The exercise scripts execute Java commands **from the host through Docker Compose**, so you can normally work without entering the container.

If you want to inspect the Linux environment manually, troubleshoot, or experiment with commands, you can open a Bash shell inside the container:

```bash
docker compose exec java bash
```

## Running Java code

A small Java program is included as a test.

The file should be located at:

```text
workspace/Test.java
```

### Compilation

To compile a specific Java file:

#### Windows

```bat
scripts\compile-java.bat Test.java
```

#### Linux/macOS

```bash
./scripts/compile-java.sh Test.java
```

This produces the compiled class in `workspace/classes/`.

### Execution

To run a specific Java file or class:

#### Windows

```bat
scripts\run-java.bat Test.java
```

#### Linux/macOS

```bash
./scripts/run-java.sh Test.java
```

### Running SOOT

To run the SOOT static analysis tool on a specific file:

#### Windows

```bat
scripts\run-soot.bat Test.java
```

#### Linux/macOS

```bash
./scripts/run-soot.sh Test.java
```

## Equivalent commands inside the container

The scripts are just wrappers around the commands executed by the container. If you need to run them manually:

```bash
cd /workspace

javac -d /workspace /workspace/Test.java
java -cp /workspace Test
```

The important distinction is that `javac` and `java` are running **inside the container**, while `Test.java` and the generated output are stored in the host-mounted `workspace/` directory.

## Useful Docker commands

Check the running container:

```bash
docker compose ps
```

See container logs:

```bash
docker compose logs
```

Open a shell manually:

```bash
docker compose exec java bash
```

Check Java inside the container:

```bash
docker compose exec java java -version
docker compose exec java javac -version
```

Check Maven:

```bash
docker compose exec java mvn -version
```

Stop the environment:

```bash
docker compose down
```

## Why the exercise files live in `workspace/`

The Docker container is treated as the **execution environment**, not as the place where the exercise files permanently live.

This has two useful properties:

- Java/JDK versions and command-line tools are isolated from the host.
- Source code and generated results remain directly accessible from the host/editor.

For example, after compiling and running Java:

```text
workspace/
├── Test.java
└── Test.class
```

## Git and ignored workspace files

The repository intentionally ignores most of `workspace/` because it is a working directory. The tracked exception is:

```text
workspace/Test.java
```

Other files in `workspace/`, including generated `.class` files, build directories, and additional libraries, are ignored unless explicitly added as exceptions in `.gitignore`.

## Shell script permissions

The `.sh` scripts should be committed with executable permissions so that they work after the repository is cloned on Linux/macOS.

From Git Bash on Windows:

```bash
git update-index --chmod=+x scripts/compile-java.sh
git update-index --chmod=+x scripts/run-java.sh
git update-index --chmod=+x scripts/run-soot.sh
```

## First-run checklist

```text
[ ] Docker Desktop is running
[ ] Linux Docker engine is available
[ ] Test.java is in workspace/
[ ] Container image has been built
[ ] Java 21 is available inside the container
[ ] Test.java compiles and runs successfully
```
