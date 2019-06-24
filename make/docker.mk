LATEX_IMAGE = latex:bachelor-thesis

DOCKER_RUN = docker run --rm --init \
	-v $(PWD):/src \
	-v $(PWD)/fonts:/root/.fonts \
	-v $(PWD)/fefu/source:/root/texmf/tex/latex/fefu

LATEXMK = $(DOCKER_RUN) $(LATEX_IMAGE) latexmk

build_latex_image:
	docker build -t $(LATEX_IMAGE) .

docker_console:
	@$(DOCKER_RUN) -it $(LATEX_IMAGE) /bin/bash
