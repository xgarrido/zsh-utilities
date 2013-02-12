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

THEMES  = zsh-utilities-themes.org
THEMESO = $(THEMES:.org=)

all: zsh

zsh: $(FILESO) $(THEMESO)

%.zsh: %.org
	@echo "Tangling $< file"
	@sed -e '/:tangle\s\+no/d' $< | sed -n '/BEGIN_SRC/,/END_SRC/p' | sed -e '/END_SRC/d' -e '/BEGIN_SRC/d' > $@

%: %.org
	@echo "Tangling $< theme file $@"
#	@sed -e '/:tangle\s\+no/d' $< | sed -n '/BEGIN_SRC/,/END_SRC/p' | sed -e '/END_SRC/d' -e '/BEGIN_SRC/d' > $@

doc: doc/index.html

doc/index.html:
	mkdir -p doc
	$(EMACS) --batch -Q --eval '(org-babel-load-file "zsh-utilities-publish.org")'
	rm zsh-utilities-publish.el
	cp doc/zsh-utilities.html doc/index.html
	echo "Documentation published to doc/"

clean:
	rm -f *.aux *.tex *.pdf zsh-utilities-*.zsh zsh-utilities-*.html doc/*html *~
	rm -rf doc
