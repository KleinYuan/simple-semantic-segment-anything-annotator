# simple-semantic-segment-anything-annotator

Super simple one line of code to use semantic-segment-anything to auto annotate your datasets.

This repo is 100% based on the amazing [Semantic-Segment-Anything project](https://github.com/fudan-zvg/Semantic-Segment-Anything) but an ultra-simplified version
for those who just wanna run one line of code to annotate your datasets and don't give a heck to the underlying
processes.


### What You Need to Run it ?

The follows are important
- GPU Memory >= 13 GB (as SAM is GPU memory consuming)
- nvidia docker installed
- nvidia driver installed on host machine

This repo is tested at the following environment
- Ubuntu 22.04
- Single GPU 3090 Ti
- NVIDIA Driver 530

### One Line to Set up Environment

```
make run
```

### One Line to Run Demo

In the [input](input), you will see a demo picture:

![demo](input/demo.jpg)

whereas the [output](output) folder is empty.

Once you are inside the container, run:

```
make annotate-single-gpu
```

You will see that the demo image will be annotated and yields results in [output](output) folder.

### One Line to Batch Annotate Your Own Datasets

Put all images that you would like to annotate under [input](input), such as:

```
├── input
│   ├── whatever_name_you_like.jpg
│   ├── whatever_format_you_like.png
│   ├──...
```

Then:

```
make annotate-single-gpu
```

Then, you will get all output in the [output](output) folder. That's it.
