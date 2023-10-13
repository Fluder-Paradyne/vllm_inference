FROM nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu22.04

RUN apt update && apt upgrade -y
RUN apt install -y python3 python3-pip git

RUN pip install --upgrade --no-cache-dir torch==2.0.1+cu118 torchvision==0.15.2+cu118 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu118
RUN pip install vllm

ARG model
ARG gpu
ENV model=$model
ENV gpu=$gpu

CMD python -m vllm.entrypoints.api_server --model $model --tensor-parallel-size $gpu