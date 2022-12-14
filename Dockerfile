FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y \
    sudo \
    neovim

ARG USERNAME=jerry
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER jerry

ARG DEBIAN_FRONTEND=noninteractive

RUN sudo apt-get install -y \
	git \
	pip \
	wget \
    curl

WORKDIR /home/jerry
COPY nvim-config /home/jerry/nvim-config
RUN bash /home/jerry/nvim-config/docs/nvim_setup_linux.sh 
