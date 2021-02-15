all: clean build test lint

clean:
	bundle exec jekyll clean

build:
	bundle exec jekyll build

test: build
	bundle exec htmlproofer --url-ignore "/fonts.gstatic.com/" ./_site

lint: clean
	find . -name '*.md' | xargs bundle exec mdl

serve:
	bundle exec jekyll serve
