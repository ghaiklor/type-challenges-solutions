all: clean build test lint

clean:
	bundle exec jekyll clean

build:
	bundle exec jekyll build

test: build
	bundle exec htmlproofer --url-ignore "/fonts.gstatic.com/" ./_site

lint: clean
	find . -name '*.md' ! -path './vendor/*' | xargs bundle exec mdl
	bundle exec ruby _scripts/ensure-markdown-structure.rb

serve:
	bundle exec jekyll serve
