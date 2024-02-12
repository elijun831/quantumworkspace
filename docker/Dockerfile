# Base image
FROM python:3.12-bullseye

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
    make \
    wget \
    zlib1g-dev \
    python3 \
    python3-pip \
    python3-venv && \
    apt-get clean

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
COPY Pipfile Pipfile.lock /app/
RUN pipenv install --deploy

# Install Jupyter
RUN pipenv run pip install jupyter

# Get the path of the pipenv virtual environment and store it in an environment variable
RUN echo "export PIPENV_VENV_PATH=$(pipenv --venv)" >> ~/.bashrc
RUN /bin/bash -c "source ~/.bashrc"

# Add the pipenv virtual environment to the PATH
ENV PATH=$PATH:$PIPENV_VENV_PATH/bin

# Install optional packages for specific quantum frameworks (uncomment as needed)
# # Uncomment the following lines and add them to your Pipfile to install these packages:
# RUN pip3 install azure-quantum[qiskit]
# RUN pip3 install azure-quantum[cirq]
#   cirq \
#   cirq-core[contrib] \
#   scipy \
#   pyquil \
#   projectq \
#   qutip \
#   qulacs \
#   strawberryfields \
#   PennyLane \
#   pulser-pasqal \
#   pytket \
#   bloqade \
#   braket \
#   strangeworks \
#   pyEPR-quantum \
#   quantum-viz

# Expose port for Jupyter Notebook
EXPOSE 8888
EXPOSE 5678

# Set up work directory
WORKDIR /app

# Create a directory for notebooks
RUN mkdir /notebooks

# Specify the directory as a volume
VOLUME /notebooks

# Create non-root user for security
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app

# Change ownership of the notebooks directory to appuser
RUN chown -R appuser:appuser /notebooks

# Change permissions of the directories to ensure appuser can write to them
RUN chmod -R 755 /app && chmod -R 755 /notebooks

# Make sure that Jupyter is on the notebook users' path.
# ENV PATH=$PATH:/usr/local/bin:$(pipenv--venv)/bin
# ENV JUPYTER_ROOT=/usr/local/bin

USER appuser

# Start Jupyter Notebook
CMD ["pipenv", "run", "jupyter", "notebook", "--notebook-dir=/notebooks", "--ip=0.0.0.0", "--port=8888", "--no-browser"]

# Start Jupyter Notebook
CMD ["jupyter", "notebook", "--notebook-dir=/notebooks", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
