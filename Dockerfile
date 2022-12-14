FROM ubuntu:20.04

RUN apt-get update

ARG UID
ARG USERNAME=jerry
ARG USER_UID=$UID
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER jerry

RUN sudo apt-get install -y \
	git \
	pip \
	wget \
    curl \
    vim

WORKDIR /home/jerry

ENV NODE_VERSION=16.13.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/home/jerry/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/home/jerry/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

RUN git clone --depth=1 https://github.com/jerry8137/vimrc.git /home/jerry/.vim_runtime
RUN sh /home/jerry/.vim_runtime/install_awesome_vimrc.sh

ADD run.sh /home/jerry/
RUN sh /home/jerry/run.sh

#RUN echo "let g:coc_disable_startup_warning = 1" >> .vim_runtime/my_configs.vim

WORKDIR /home/jerry/src
ENTRYPOINT ["vim"]
