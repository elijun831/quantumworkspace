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
    python3-venv

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip
RUN pip3 install --upgrade pip

# Install necessary Python packages
RUN /opt/venv/bin/python -m pip install dataclasses==0.6 pydantic==1.8.2 referencing==3.9

# Install Jupyter, Q#, Cirq, and Qiskit, as well as other packages
RUN pip3 install jupyter -U && pip3 install jupyterlab
RUN pip3 install notebook_shim
RUN pip3 install \
    qsharp \
    azure-quantum \
    scipy \
    ipympl 
    ipykernel

# Install optional packages for specific quantum frameworks (uncomment as needed)
# RUN pip3 install azure-quantum[qiskit]
# RUN pip3 install azure-quantum[cirq]
#    pyquil \
#    projectq \
#    qutip \
#    qulacs \
#    strawberryfields \
#    PennyLane \
#    pulser-pasqal \
#    pytket \
#    bloqade \
#    braket \
#    amazon-braket-sdk \
#    strangeworks \
#    pyEPR-quantum \
#    quantum-viz

# Expose port for Jupyter Notebook
EXPOSE 8888

# Set up work directory
WORKDIR /app

# Copy code and notebooks
COPY . /app

# Create non-root user for security
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app

# Make sure that Jupyter is on the notebook users' path.
ENV PATH=$PATH:/usr/local/bin
ENV JUPYTER_ROOT=/usr/local/bin

USER appuser

# Start Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
