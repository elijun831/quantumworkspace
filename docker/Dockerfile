# Base image
FROM python:3.11-bullseye

# Set environment variables
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
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
    python3 \
    python3-pip \
    python3-venv \
    apt-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Rust, update it, create a directory, and set the working directory to the new Rust application directory
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    $HOME/.cargo/bin/rustup update
ENV PATH="/root/.cargo/bin:${PATH}"
ENV PROJECT_DIR /usr/local/src/webapp
RUN mkdir -p ${PROJECT_DIR}/rust
WORKDIR ${PROJECT_DIR}/rust

# Upgrade pip
RUN pip3 install --upgrade pip

# Install pipenv
RUN pip3 install pipenv
WORKDIR /app
COPY ../Pipfile ../Pipfile.lock /app/
RUN pipenv install --deploy

# Get the path of the pipenv virtual environment and store it in an environment variable
RUN pipenv --venv > venv_path
RUN echo "export PIPENV_VENV_PATH=$(pipenv --venv)" > ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# Add the pipenv virtual environment to the PATH
ENV PATH=$PATH:/root/.local/share/virtualenvs/app-*/bin

# Expose port for Jupyter Notebook as well as debugging
EXPOSE 8888
EXPOSE 5678

# Set up work directory
WORKDIR /app

# Create a directory for notebooks
RUN mkdir /notebooks

# Specify the directory as a volume for persistent storage
VOLUME /notebooks

# Create non-root user for security
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app

# Change ownership of the notebooks directory to appuser
RUN chown -R appuser:appuser /notebooks

# Change permissions of the directories for appuser
RUN chmod -R 755 /app && chmod -R 755 /notebooks

# Switch to the non-root user
USER appuser

# Install Jupyter packages
RUN pipenv install jupyterlab notebook voila

# Start JupyterLab within Pipenv environment
CMD ["pipenv", "run", "jupyter", "lab", "--notebook-dir=/notebooks", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
