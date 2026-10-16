SHELL := /bin/sh
.SHELLFLAGS := -eu -c

SKILL_DIRS := skills/claude-motion-design skills/claude-motion

.PHONY: update

update:
	@set -eu; \
	for skill_dir in $(SKILL_DIRS); do \
		if [ ! -d "$$skill_dir/.git" ]; then \
			echo "技能目录不是 Git 仓库: $$skill_dir" >&2; \
			exit 1; \
		fi; \
		echo "更新 $$skill_dir"; \
		git -C "$$skill_dir" pull --ff-only; \
	done
