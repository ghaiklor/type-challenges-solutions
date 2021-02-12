---
title: TypeScript Type Challenges
lang: en
---

You can find here a collection of challenges to test yourself!
How well do you know a TypeScript and its type system?

## Challenges

{% assign warm = site.pages | where: "lang", "en" | where: "level", "warm" %}
{% assign easy = site.pages | where: "lang", "en" | where: "level", "easy" %}
{% assign medium = site.pages | where: "lang", "en" | where: "level", "medium" %}
{% assign hard = site.pages | where: "lang", "en" | where: "level", "hard" %}
{% assign extreme = site.pages | where: "lang", "en" | where: "level", "extreme" %}

### Warm Up

{% for challenge in warm %}
 [{{ challenge.title }}]({{ challenge.url }})
{% endfor %}

### Easy

{% for challenge in easy %}
 [{{ challenge.title }}]({{ challenge.url }})
{% endfor %}

### Medium

{% for challenge in medium %}
 [{{ challenge.title }}]({{ challenge.url }})
{% endfor %}

### Hard

{% for challenge in hard %}
 [{{ challenge.title }}]({{ challenge.url }})
{% endfor %}

### Extreme

{% for challenge in extreme %}
 [{{ challenge.title }}]({{ challenge.url }})
{% endfor %}
