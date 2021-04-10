# Contributing

## What this repository is about

This repository is a collection of Markdown files where we store the solutions for Type Challenges with explanations and comments.

## Repository structure

The structure here is pretty simple.
In the root, we have folders that are split by language codes.
In each folder there is must be a single Markdown file per challenge, named as it is named in Type Challenges repository `<level>-<challenge>.md`.

## Template

The Markdown file itself must comprise the following content:

```md
---
id: <CHALLENGE_ID>
title: <CHALLENGE_TITLE>
lang: <CHALLENGE_LANGUAGE>
level: <CHALLENGE_LEVEL>
tags: <CHALLENGE_TAGS>
---

## Challenge

<CHALLENGE_DESCRIPTION_FROM_TYPE_CHALLENGES>

## Solution

<CHALLENGE_SOLUTION_WITH_COMMENTS>

## References

<CHALLENGE_REFERENCES_TO_READ_MORE>
```

## Serving Locally

I use Jekyll to build the site and deploy to GitHub Pages.
So if you want to experiment with the repository and serve the content locally, make sure that you have installed the dependencies and call the serve recipe:

```shell
bundle install
make serve
```

If you want to run the whole pipeline with tests and linter, just call make:

```shell
make
```

## What solutions are missing

You can sync up with the original repository `type-challenges` to know what solution is missing in the repository.
To do that, there is a script called `sync-challenges.rb` in [`_scripts`](../_scripts/sync-challenges.rb) folder.

Calling that script via `ruby` will print all the challenges that are exists in `type-challenges` repo but are missing in ours.

```shell
ruby _scripts/sync-challenges.rb
```

E.g. it prints out `en/easy-awaited.md`.
In that case, it means that there is a challenge `easy-awaited`, but you don’t have a solution for it in English.
