# Vim with coc inside container

## Setup:

1. setup Docker
2. run `docker build -t myvim --build-arg UID=$UID .`

## To run:

`docker run -it --rm --name vim -v $PWD:/home/jerry/src myvim`
