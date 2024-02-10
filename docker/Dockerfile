# Base image
FROM debian:latest

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
    python3-venv && \
    apt-get clean

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip
RUN pip3 install --upgrade pip

# Install specific versions of the necessary Python packages
RUN /opt/venv/bin/python -m pip install --no-cache-dir dataclasses pydantic referencing

# Install Jupyter, Q#, qiskit, and necessary packages
RUN pip3 install --no-cache-dir jupyter -U jupyterlab notebook_shim \
    qsharp \
    azure-quantum \
    qiskit \
    qiskit-ibm-runtime \
    qiskit[visualization] \
    amazon-braket-sdk \
    cirq \
    ipykernel \
    ipympl

# Install optional packages for specific quantum frameworks (uncomment as needed)
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
#   amazon-braket-algorithm-library
#   strangeworks \
#   pyEPR-quantum \
#   quantum-viz

# Expose port for Jupyter Notebook
EXPOSE 8888

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

# Make sure that Jupyter is on the notebook users' path.
ENV PATH=$PATH:/usr/local/bin
ENV JUPYTER_ROOT=/usr/local/bin

USER appuser

# Start Jupyter Notebook
CMD ["jupyter", "notebook", "--notebook-dir=/notebooks", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
