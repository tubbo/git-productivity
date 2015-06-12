DOCS = $(wildcard doc/man/*.1.md)
MANPAGES = $(patsubst doc/man/%.md,share/man/man1/%,$(DOCS))
VERSION = $(shell semver tag)
TYPE ?= patch

all: vendor/bundle $(MANPAGES)

.PHONY: all clean

clean:
	@rm -rf share/man/man1

vendor/bundle:
	@bundle install

# Generate a command.
bin/%:
	cp doc/template/bin.sh bin/%@

# Generate a manpage.
doc/man/%.1.md: bin/%
	cp doc/template/man.md doc/man/$@.1.md

# Convert manpage from Markdown to Man.
share/man/man1/%.1: doc/man/%.1.md
	@mkdir -p share/man/man1
	@kramdown-man $< > $@

# Generate a tag with Semver.
.git/refs/tags/%:
	@git tag -a $* -m "Release $*"

# Increment the version with Semver.
version:
	@semver inc $(TYPE)

# Create a new tag in Git for the current version.
tag: .git/refs/tags/$(VERSION)

# Release a new version.
release:
	@make version
	@make tag
	@git push --tags


