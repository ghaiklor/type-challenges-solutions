all: test
test:
	jekyll build && htmlproofer ./_site
