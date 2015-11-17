FILES  = zsh-utilities.org              \
	 zsh-utilities-alias.org	\
	 zsh-utilities-configure.org    \
	 zsh-utilities-functions.org	\
	 zsh-utilities-modules.org	\
	 zsh-utilities-pkgtools.org	\
	 zsh-utilities-settings.org     \
	 zsh-utilities-work.org
FILESO = $(FILES:.org=.zsh)

all: zsh

zsh: $(FILESO)

%.zsh: %.org
	@echo "Tangling $< file"
	@sed -e '/:tangle\s\+/d' $< | sed -n '/BEGIN_SRC/,/END_SRC/p' | sed -e '/END_SRC/d' -e '/BEGIN_SRC/d' > $@

html:
	@zsh -i -c "org-pages --recursive --html --generate-home-link --generate-github-link generate"

publish:
	@zsh -i -c "org-pages --recursive --html --generate-home-link --generate-github-link publish"

clean:
	rm -f *.aux *.tex *.pdf zsh-utilities-*.zsh zsh-utilities-*.html doc/*html *~
	rm -rf doc
