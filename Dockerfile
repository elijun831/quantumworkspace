# Base image
FROM python:3.11.8-bookworm

# Upgrade pip
RUN pip3 install --upgrade pip

# Install Jupyter, Q#, Cirq, and Qiskit
RUN pip3 install jupyter -U && pip3 install jupyterlab
RUN pip3 install notebook_shim
RUN pip3 install \
    qsharp \
    azure-quantum \
    cirq \
    'cirq-core[contrib]' \
    qiskit

# Install optional packages for specific quantum frameworks (uncomment as needed)
# RUN pip3 install azure-quantum[qiskit]
# RUN pip3 install azure-quantum[cirq]
#    ipykernel \
#    ipympl \
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
#    quantum-viz \

# Expose port for Jupyter Notebook
EXPOSE 8888

# Set up work directory
WORKDIR /app

# Copy code and notebooks
COPY . /app

# Create non-root user for security
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app

# Make sure that Jupyter is on the notebook users' path.
ENV PATH=$PATH:/usr/local/bin \
    JUPYTER_ROOT=/usr/local/bin

USER appuser

# Start Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
