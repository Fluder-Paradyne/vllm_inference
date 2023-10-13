FROM nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu22.04

RUN apt update && apt upgrade -y
RUN apt install -y python3 python3-pip git

RUN pip install transformers==4.33.2
RUN pip install vllm==0.2.0

ARG model
ARG gpu
ENV model=$model
ENV gpu=$gpu

CMD python -m vllm.entrypoints.api_server --model $model --tensor-parallel-size $gpu