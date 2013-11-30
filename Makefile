# Name of your emacs binary
EMACS=emacs

BATCH=$(EMACS) --batch --no-init-file					\
  --eval '(require (quote org))'					\
  --eval "(org-babel-do-load-languages 'org-babel-load-languages	\
        '((sh . t)))"							\
  --eval "(setq org-confirm-babel-evaluate nil)"			\

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
	@sed -e '/:tangle\s\+no/d' $< | sed -n '/BEGIN_SRC/,/END_SRC/p' | sed -e '/END_SRC/d' -e '/BEGIN_SRC/d' > $@

doc: html

html:
	@mkdir -p doc/stylesheets
	@$(BATCH) --eval '(org-babel-tangle-file "zsh-utilities-publish.org")'
	@$(BATCH) --eval '(org-babel-load-file	 "zsh-utilities-publish.org")'
	@rm zsh-utilities-publish.el
	@find doc -name *.*~ | xargs rm -f
	@(cd doc && tar czvf /tmp/org-zsh-utilities-publish.tar.gz .)
	@git checkout gh-pages
	@tar xzvf /tmp/org-zsh-utilities-publish.tar.gz
	@if [ -n "`git status --porcelain`" ]; then git commit -am "update doc" && git push; fi
	@git checkout master
	@echo "Documentation published to doc/"

clean:
	rm -f *.aux *.tex *.pdf zsh-utilities-*.zsh zsh-utilities-*.html doc/*html *~
	rm -rf doc
