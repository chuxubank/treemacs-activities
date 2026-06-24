# treemacs-activities

`treemacs-activities` integrates [treemacs](https://github.com/Alexander-Miller/treemacs) with [activities.el](https://github.com/alphapapa/activities.el) by adding an activity-based treemacs scope.

Each activity gets its own treemacs workspace and treemacs buffer.  When an activity is resumed, switched, renamed, or discarded, the matching treemacs workspace is selected, renamed, or removed.

## Installation

With `use-package` and `straight.el`:

```elisp
(use-package treemacs-activities
  :straight (:host github :repo "chuxubank/treemacs-activities")
  :after (treemacs activities)
  :config
  (treemacs-set-scope-type 'Activities))
```

With `package-vc-install`:

```elisp
(package-vc-install "https://github.com/chuxubank/treemacs-activities")
(require 'treemacs-activities)
(treemacs-set-scope-type 'Activities)
```

## Behavior

New activity workspaces are populated from project roots discovered in the activity's buffers.

When activity buffers do not yield a project root, the package falls back to the current project before copying treemacs' fallback workspace.  This avoids making multiple activities accidentally inherit the same treemacs contents when activity buffer tracking has not caught up yet.

## Development

Run tests:

```sh
emacs --batch \
  --eval "(progn (require 'package) (package-initialize))" \
  -L . \
  -l treemacs-activities-test.el \
  -f ert-run-tests-batch-and-exit
```

Byte-compile:

```sh
emacs --batch \
  --eval "(progn (require 'package) (package-initialize))" \
  -L . \
  -f batch-byte-compile treemacs-activities.el treemacs-activities-test.el
```

## License

GPL-3.0-or-later
