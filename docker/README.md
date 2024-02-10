# QuantumPackage

This repository contains a Dockerfile for setting up a Jupyer notebook environment with QSharp and Azure Quantum, built upon the latest Debian version.

## Prerequisites

You should install Docker in your machine (https://docs.docker.com/desktop/).

## Getting Started

Follow these steps to get the environment up and running.

1. Clone the repository:
```
git clone https://github.com/elijun831/testing
```

2. Navigate to the directory containing the Dockerfile by typing the following in your terminal:
```
cd quantumpackage/Docker
```

3. Build the Docker image:
```
docker build -t quantumpackage .
```

4. Run the Docker container:
```
docker run -p 8888:8888 quantumpackage
```

5. After running the Docker container, you should see a URL in the terminal output that looks like this:
```
http://localhost:8888/tree?token=[[token]]
## or
http://127.0.0.1:8888/tree?token=[[token]]
```
Copy the [[token]] and paste it in your Jupyter log-in webpage to access the Jupyter Notebook server.
