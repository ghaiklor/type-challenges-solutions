all: build test lint

clean:
	bundle exec jekyll clean

build:
	bundle exec jekyll build

test: build
	bundle exec htmlproofer --url-ignore "/fonts.gstatic.com/" ./_site

lint:
	bundle exec mdl en

serve:
	bundle exec jekyll serve
