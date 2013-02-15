# Name of your emacs binary
EMACS=emacs

FILES  = zsh-utilities.org              \
	 zsh-utilities-alias.org	\
	 zsh-utilities-configure.org    \
	 zsh-utilities-functions.org	\
	 zsh-utilities-emacs.org	\
	 zsh-utilities-pkgtools.org	\
	 zsh-utilities-svn.org		\
	 zsh-utilities-settings.org     \
	 zsh-utilities-work.org
FILESO = $(FILES:.org=.zsh)

all: zsh

zsh: $(FILESO)

%.zsh: %.org
	@echo "Tangling $< file"
	@sed -e '/:tangle\s\+no/d' $< | sed -n '/BEGIN_SRC/,/END_SRC/p' | sed -e '/END_SRC/d' -e '/BEGIN_SRC/d' > $@

doc: doc/index.html

doc/index.html: $(FILESO) zsh-utilities-publish.org
	mkdir -p doc
	$(EMACS) --batch -Q --eval '(org-babel-load-file "zsh-utilities-publish.org")'
	rm zsh-utilities-publish.el
	cp doc/zsh-utilities.html doc/index.html
	echo "Documentation published to doc/"

clean:
	rm -f *.aux *.tex *.pdf zsh-utilities-*.zsh zsh-utilities-*.html doc/*html *~
	rm -rf doc
