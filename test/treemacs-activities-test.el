;;; treemacs-activities-test.el --- Tests for treemacs-activities -*- lexical-binding: t -*-

;;; Code:

(require 'ert)
(require 'treemacs-activities)

(ert-deftest treemacs-activities-setup-refreshes-after-activities-set ()
  "Refreshing after `activities-set' covers resume/new/revert paths."
  (unwind-protect
      (progn
        (treemacs-scope->setup 'treemacs-activities-scope)
        (should (advice-member-p #'treemacs-activities--on-activity-switch
                                 'activities-set)))
    (treemacs-scope->cleanup 'treemacs-activities-scope)
    (should-not (advice-member-p #'treemacs-activities--on-activity-switch
                                 'activities-set))))

(ert-deftest treemacs-activities-create-workspace-falls-back-to-current-project ()
  "Use current project when activity buffers do not yield project roots."
  (let* ((fallback-project (treemacs-project->create!
                            :name "fallback"
                            :path "/tmp/fallback/"
                            :path-status 'readable))
         (created-workspace (treemacs-workspace->create!
                             :name "Activity test"
                             :projects nil))
         (fallback-workspace (treemacs-workspace->create!
                              :name "Fallback"
                              :projects (list fallback-project)))
         (treemacs--workspaces (list fallback-workspace))
         (current-root "/tmp/current-project/")
         created-projects)
    (cl-letf (((symbol-function 'treemacs-do-create-workspace)
               (lambda (_name) (list 'success created-workspace)))
              ((symbol-function 'treemacs-activities--find-project-roots)
               (lambda () nil))
              ((symbol-function 'treemacs--find-current-user-project)
               (lambda () current-root))
              ((symbol-function 'treemacs--get-path-status)
               (lambda (_path) 'readable)))
      (treemacs-activities--create-workspace "Activity test")
      (setq created-projects (treemacs-workspace->projects created-workspace))
      (should (= 1 (length created-projects)))
      (should (equal current-root
                     (treemacs-project->path (car created-projects)))))))

(provide 'treemacs-activities-test)
;;; treemacs-activities-test.el ends here
