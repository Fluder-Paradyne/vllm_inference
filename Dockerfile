FROM python:3.10-slim-buster

RUN apt-get update && \
    apt-get install --no-install-recommends -y wget libpq-dev gcc g++ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install vllm

ARG model
ARG gpu
ENV model=$model
ENV gpu=$gpu

CMD python -m vllm.entrypoints.api_server --model $model --tensor-parallel-size $gpu