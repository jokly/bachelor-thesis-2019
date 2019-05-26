-include local.mk

PWD = $(shell pwd)

USE_DOCKER ?= yes
ifeq ($(USE_DOCKER), yes)
include make/docker.mk
endif

LATEXMK ?= latexmk

build:
	@$(LATEXMK) -xelatex -synctex=1 -jobname=bachelor-thesis main.tex

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
		*.toc

prune: clean
	@rm -rf *.pdf
