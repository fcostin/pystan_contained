pystan-contained
================

Demo command-line workflow for running [pystan](https://pystan.readthedocs.io/en/latest/) models inside a container.


### pre-reqs

*	command line environment with `make`, `bash`, `tee` on the path
*	docker daemon installed and running. `docker` on the path
*	an internet connection
	-	necessary to pull base container image from `hub.docker.com`
	-	necessary to install debian & python packages while building the container image


### demo of usage

Clone this repo (or otherwise copy all the files into a working directory).

open a terminal with working directory containing all the files in this repo

type `make`

this should trigger the following steps:

1.	docker will build the `pystan.3.9.7.Dockerfile` container image. This will take a while the first time.
2.	docker will create and run a container named `pystanenv` using the container image
3.	inside the `pystanenv` container, the command `python3 src/example.py | tee example.log` will be run
4.	`pystan` will build the model defined inside `src/example.py`. This will take a while the first time.
5.	output from the python script (and docker build) will be written to `example.log`

### usage without involving a `Makefile`

To run a script such as `src/example.py` within the container without using `Make`, you can run

```
./pystanenv.sh python3 src/example.py
```


### what works

*	`pystan 3.3.0` installs atop `python 3.9` and `debian 11 bullseye` inside a container
*	host machine can share python scripts and other files in `src` directory with container through volume mount
*	model cache persisted on host filesystem between container runs, shared with host through `httpstan_cache` volume mount

### what doesn't work

*	some command line arguments containing spaces get mangled when passed into container

