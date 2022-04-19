ARG PYTHON_VERSION=3.8
ARG CUDA_VERSION=10.1
ARG CUDNN_VERSION=7
ARG UBUNTU_VERSION=18.04

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-runtime-ubuntu${UBUNTU_VERSION} as base_image

LABEL maintainer "Jerry Kim <jaeyeol2931@gmail.com>"

RUN apt-get update
RUN apt-get install -y \
        build-essential \
        cmake \
        git \
        curl \
        wget \
        ca-certificates \
        libjpeg-dev \
        libpng-dev

RUN apt-get update && apt-get -y upgrade

# 2020.10.11 내용 추가
# Docker container에 ssh로 접속하고 싶다면....
# RUN mkdir /var/run/sshd
RUN echo 'root:{개인 비밀번호}' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

RUN rm -rf /var/lib/apt/lists/*

RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh

RUN chmod +x ~/miniconda.sh && \
    ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN /opt/conda/bin/conda install -y python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl mkl-include ninja cython typing opencv matplotlib tqdm && \
    /opt/conda/bin/conda install -y jupyter jupyterlab seaborn pillow pandas pylint scikit-learn scikit-image && \
    /opt/conda/bin/conda update -y --all && \
    /opt/conda/bin/conda clean -ya

ENV PATH /opt/conda/bin:$PATH