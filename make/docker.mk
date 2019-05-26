LATEX_IMAGE = latex:bachelor-thesis

DOCKER_RUN = docker run --rm --init -v $(PWD):/src

LATEXMK = $(DOCKER_RUN) $(LATEX_IMAGE) latexmk

build_latex_image:
	docker build -t $(LATEX_IMAGE) .

console:
	$(DOCKER_RUN) -it /bin/bash
