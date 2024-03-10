c = get_config()

# Set options for Jupyter Notebook
c.NotebookApp.token = ''
# c.NotebookApp.password = ''  # Commented out to leave the password blank; you can uncomment this line and set the password if you wish to do so
c.NotebookApp.allow_root = True  # Allow the notebook server to be run by the root user
c.NotebookApp.ip = '0.0.0.0'
c.NotebookApp.port = 8888
c.NotebookApp.allow_origin = '*'
c.NotebookApp.open_browser = False

# Set options for JupyterLab
c.ServerApp.jpserver_extensions = {
    'jupyterlab': True,
    'other_extension': True,
}
