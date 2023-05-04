# refers to https://github.com/IDEA-Research/Grounded-Segment-Anything/blob/main/Dockerfile
NVCC := $(shell which nvcc)
ifeq ($(NVCC),)
	# NVCC not found
	USE_CUDA := 0
	NVCC_VERSION := "not installed"
else
	NVCC_VERSION := $(shell nvcc --version | grep -oP 'release \K[0-9.]+')
	USE_CUDA := $(shell echo "$(NVCC_VERSION) > 11" | bc -l)
endif

# Add the list of supported ARCHs
ifeq ($(USE_CUDA), 1)
	TORCH_CUDA_ARCH_LIST := "3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX"
	BUILD_MESSAGE := "I will try to build the image with CUDA support"
else
	TORCH_CUDA_ARCH_LIST :=
	BUILD_MESSAGE := "CUDA $(NVCC_VERSION) is not supported"
endif


build-image:
	@echo $(BUILD_MESSAGE)
	docker build --build-arg USE_CUDA=$(USE_CUDA) \
	--build-arg TORCH_ARCH=$(TORCH_CUDA_ARCH_LIST) \
	-t s3aa:v0 .

run: build-image
	docker run --gpus all -it --rm --net=host --privileged \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ${PWD}/input:/home/Semantic-Segment-Anything/input \
	-v ${PWD}/output:/home/Semantic-Segment-Anything/output \
	-v ${PWD}/simple_visualizer.py:/home/Semantic-Segment-Anything/simple_visualizer.py \
	-e DISPLAY=$DISPLAY \
	--name=s3aa \
	--ipc=host -it s3aa:v0

annotate-single-gpu:
	python scripts/main_ssa_engine.py \
	--data_dir=input \
	--out_dir=output \
	--world_size=1 \
	--save_img \
	--sam 
	--ckpt_path=ckp/sam_vit_h_4b8939.pth
