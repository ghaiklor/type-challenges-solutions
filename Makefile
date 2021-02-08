all: build test

build:
	bundle exec jekyll build

test: build
	bundle exec htmlproofer ./_site
