FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ARG MAX_JOBS

WORKDIR /workspace

RUN apt update && \
  apt install -y python3-pip python3-packaging \
  git ninja-build && \
  pip3 install -U pip

# Tweak this list to reduce build time
# https://developer.nvidia.com/cuda-gpus
ENV TORCH_CUDA_ARCH_LIST "7.0;7.5;8.0;8.6;8.9;9.0+PTX"
ENV PIP_DEFAULT_TIMEOUT=100

# We have to manually install Torch otherwise apex & xformers won't build
RUN pip3 install "torch==2.0.1" --extra-index-url https://download.pytorch.org/whl/cu118

# This build is slow but NVIDIA does not provide binaries. Increase MAX_JOBS as needed.
RUN git clone https://github.com/NVIDIA/apex && \
  cd apex && git checkout 2386a912164b0c5cfcd8be7a2b890fbac5607c82 && \
  sed -i '/check_cuda_torch_binary_vs_bare_metal(CUDA_HOME)/d' setup.py && \
  python3 setup.py install --cpp_ext --cuda_ext

RUN pip3 install "xformers==0.0.22" "transformers==4.34.0" "fschat==0.2.23"

RUN git clone --single-branch --depth 1 --branch main https://github.com/vllm-project/vllm.git && \
  cd vllm && \
  pip3 install -e .


COPY entrypoint.sh .

RUN chmod +x /workspace/entrypoint.sh

VOLUME [ "/root/.cache/huggingface" ]

ENTRYPOINT ["/workspace/entrypoint.sh"]