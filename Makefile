DOCS = $(wildcard doc/man/*.1.md)
MANPAGES = $(patsubst doc/man/%.md,share/man/man1/%,$(DOCS))
VERSION = $(shell semver tag)

all: vendor/bundle $(MANPAGES)

.PHONY: all clean

clean:
	rm -rf share/man/man1

vendor/bundle:
	bundle install

# Generate a command.
bin/%:
	cp doc/template/bin.sh bin/%@

# Generate a manpage.
doc/man/%.1.md: bin/%
	@cp doc/template/man.md doc/man/$@.1.md

# Convert manpage from Markdown to Man.
share/man/man1/%.1: doc/man/%.1.md
	@mkdir -p share/man/man1
	@kramdown-man $< > $@

# Generate a tag with Semver
tag:
	git tag -a $(VERSION) -m "Release $(VERSION)"

# Release a new version
release: tag
	git push --tags
