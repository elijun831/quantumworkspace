# Version 3.0.0
# Base image
FROM ubuntu:latest

# Set environment variables
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

# Install necessary packages
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3-pip \
    build-essential \
    curl \
    vim \
    vim-common \
    vim-runtime \
    nano \
    flameshot \
    keepassxc \
    bleachbit \
    g++ \
    git \
    libblas-dev \
    libffi-dev \
    liblapack-dev \
    libssl-dev \
    texlive-latex-base \
    latexmk \
    make \
    wget \
    zlib1g-dev \
    bash \
    tree \
    && apt-get clean

# Install Rust, update it, create a directory, and set the working directory to the new Rust application directory
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init.sh
RUN chmod +x rustup-init.sh
RUN ./rustup-init.sh -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Create Rust project directory (if necessary)
RUN mkdir -p /usr/local/src/webapp/rust

# Set up work directory for Python application
WORKDIR /app

# Install Pipenv
RUN python3.11 -m pip install pipenv

# Copy Pipfile and Pipfile.lock
COPY Pipfile Pipfile.lock /app/

# Create and activate the virtual environment
RUN python3.11 -m venv /venv
ENV PATH="/venv/bin:${PATH}"

# Install dependencies 
RUN pipenv install --deploy --python 3.11
RUN pipenv run pip install jupyter notebook jupyterlab voila

# Expose ports
EXPOSE 8888
EXPOSE 5678
EXPOSE 8080
EXPOSE 80

# Create a directory for notebooks
RUN mkdir /notebooks

# Specify the directory as a volume
VOLUME /notebooks

# Create non-root user for security
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app

# Change ownership of the notebooks directory to appuser
RUN chown -R appuser:appuser /notebooks

# Switch to appuser
USER appuser

# Change permissions of the directories to ensure appuser can write to them
RUN chmod -R 755 /app && chmod -R 755 /notebooks

# Start JupyterLab (Modified CMD)
CMD ["/venv/bin/pipenv", "run", "jupyter", "lab", "--notebook-dir=/notebooks", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
