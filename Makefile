EMACS ?= emacs
BATCH = $(EMACS) --batch --quick
LOAD_PATH = -L .

# Package archives setup
ARCHIVES = --eval "(require 'package)" \
           --eval "(add-to-list 'package-archives '(\"melpa\" . \"https://melpa.org/packages/\") t)" \
           --eval "(package-initialize)"

.PHONY: help install-deps lint build test clean

help:
	@echo "Targets:"
	@echo "  install-deps  - Install package dependencies and package-lint"
	@echo "  lint          - Run package-lint and checkdoc"
	@echo "  build         - Byte-compile the package"
	@echo "  test          - Run ERT tests"
	@echo "  clean         - Remove .elc files"

install-deps:
	$(BATCH) $(ARCHIVES) \
	  --eval "(package-refresh-contents)" \
	  --eval "(dolist (pkg '(dash activities treemacs package-lint)) \
	            (unless (package-installed-p pkg) \
	              (package-install pkg)))"

lint:
	$(BATCH) $(ARCHIVES) $(LOAD_PATH) \
	  --eval "(require 'package-lint)" \
	  --eval "(package-lint-batch-and-exit)" \
	  treemacs-activities.el
	$(BATCH) $(LOAD_PATH) \
	  --eval "(checkdoc-file \"treemacs-activities.el\")"

build:
	$(BATCH) $(ARCHIVES) $(LOAD_PATH) \
	  --eval "(setq byte-compile-error-on-warn t)" \
	  --eval "(byte-compile-file \"treemacs-activities.el\")" \
	  --eval "(byte-compile-file \"treemacs-activities-test.el\")"

test:
	$(BATCH) $(ARCHIVES) $(LOAD_PATH) \
	  -l treemacs-activities.el \
	  -l treemacs-activities-test.el \
	  --eval "(ert-run-tests-batch-and-exit)"

clean:
	rm -f *.elc
