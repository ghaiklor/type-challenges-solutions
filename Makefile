all: test
test:
	bundle exec jekyll build
	bundle exec htmlproofer ./_site
