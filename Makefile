.PHONY: build presentation bump

-include local.mk

PWD = $(shell pwd)

USE_DOCKER ?= yes
ifeq ($(USE_DOCKER), yes)
include make/docker.mk
endif

LATEXMK ?= latexmk

build:
	@$(LATEXMK) -xelatex -synctex=1 -jobname=bachelor-thesis main.tex

presentation:
	@$(LATEXMK) -xelatex -synctex=1 -jobname=presentation presentation/main.tex

bump:
	@./bump.sh

clean:
	@rm -rf *.aux \
		*.fdb_latexmk \
		*.fls \
		*.lof \
		*.lot \
		*.log \
		*.out \
		*.synctex.gz \
		*.toc \
		*.bbl \
		*.blg \
		*.nav \
		*.snm

prune: clean
	@rm -rf *.pdf
