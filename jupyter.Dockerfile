FROM jupyter/scipy-notebook
RUN python3 -m pip install requests
RUN python3 -m pip install feature_engine --progress-bar off