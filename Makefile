LATEX    = xelatex
STY      = $(wildcard src/*.sty)
DESTDIR ?= $(shell kpsewhich -var-value=TEXMFHOME)
INSTDIR  = $(DESTDIR)/tex/latex/jacquenetta

export TEXINPUTS := $(shell pwd)/src:${TEXINPUTS}

.PHONY: example clean install uninstall

example: example/example.tex $(STY)
	cd example && $(LATEX) example.tex && $(LATEX) example.tex

install: $(STY)
	mkdir -p $(INSTDIR)
	cp $(STY) $(INSTDIR)
	texhash $(DESTDIR)

uninstall:
	rm -rf $(INSTDIR)
	texhash $(DESTDIR)

clean:
	cd example && rm -f *.aux *.log *.nav *.out *.snm *.toc *.vrb *.listing *.fls *.fdb_latexmk *.synctex.gz *.pdf
