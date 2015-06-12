.PHONY: all

vendor/bundle:
	bundle install

share/man/man1/%.1: doc/man/%.1.md
	kramdown-man doc/man/%.1.md > share/man/man1/%.1

all: doc/man/%.1.md
