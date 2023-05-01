FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-devel

# Arguments to build Docker Image using CUDA
ARG USE_CUDA=0
ARG TORCH_ARCH=

ENV AM_I_DOCKER True
ENV BUILD_WITH_CUDA "${USE_CUDA}"
ENV TORCH_CUDA_ARCH_LIST "${TORCH_ARCH}"
ENV CUDA_HOME /usr/local/cuda-11.6/

RUN apt-get update && apt-get install --no-install-recommends wget ffmpeg=7:* \
    libsm6=2:* libxext6=2:* git=1:* nano=2.* \
    vim=2:* -y \
    && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

WORKDIR /home/

# First, install https://github.com/fudan-zvg/Semantic-Segment-Anything.git
RUN git clone https://github.com/fudan-zvg/Semantic-Segment-Anything.git
WORKDIR /home/Semantic-Segment-Anything
SHELL ["/bin/bash", "-c"]
RUN source /opt/conda/etc/profile.d/conda.sh && conda init bash && conda env create -f environment.yaml 
RUN echo "source activate ssa" > ~/.bashrc
ENV PATH /opt/conda/envs/ssa/bin:$PATH
RUN python -m spacy download en_core_web_sm
# next, install meta segment anything
RUN pip install git+https://github.com/facebookresearch/segment-anything.git
RUN pip install opencv-python pycocotools matplotlib onnxruntime onnx
# Last, download the checkpoints
COPY download.sh /home/Semantic-Segment-Anything/
COPY Makefile /home/Semantic-Segment-Anything/
RUN bash download.sh
