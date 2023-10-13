FROM nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu22.04

RUN apt update && apt upgrade -y
RUN apt install -y python3 python3-pip git

RUN pip install --upgrade --no-cache-dir torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu117
RUN pip install vllm

ARG model
ARG gpu
ENV model=$model
ENV gpu=$gpu

CMD python -m vllm.entrypoints.api_server --model $model --tensor-parallel-size $gpu