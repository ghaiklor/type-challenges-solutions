---
title: Welcome!
lang: en
---

You can find here a collection of challenges to test yourself and their solutions!
How well do you know a TypeScript and its type system?

Before opening the challenges by links below, try to solve them first by navigating to [type-challenges](https://github.com/type-challenges/type-challenges) repository.
This website is actually a collection of solutions\explanations to them, so you could be interested to solve them first there.

If you tried and could not solve it, you can open the challenge here and read a detailed explanation on how to solve it.
Further, I’m providing references to TypeScript documentation where you can read more in details about specific type features I’ve used to solve the challenge.

Take your time and enjoy the challenges!

{% assign warm = site.pages | where: "lang", "en" | where: "level", "warm" %}
{% assign easy = site.pages | where: "lang", "en" | where: "level", "easy" %}
{% assign medium = site.pages | where: "lang", "en" | where: "level", "medium" %}
{% assign hard = site.pages | where: "lang", "en" | where: "level", "hard" %}
{% assign extreme = site.pages | where: "lang", "en" | where: "level", "extreme" %}

## Warm Up

{% for challenge in warm %}
  [{{ challenge.title }}]({{ challenge.url | absolute_url }})
{% endfor %}

## Easy

{% for challenge in easy %}
  [{{ challenge.title }}]({{ challenge.url | absolute_url }})
{% endfor %}

## Medium

{% for challenge in medium %}
  [{{ challenge.title }}]({{ challenge.url | absolute_url }})
{% endfor %}

## Hard

{% for challenge in hard %}
  [{{ challenge.title }}]({{ challenge.url | absolute_url }})
{% endfor %}

## Extreme

{% for challenge in extreme %}
  [{{ challenge.title }}]({{ challenge.url | absolute_url }})
{% endfor %}
