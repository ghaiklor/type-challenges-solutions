---
title: Welcome!
---

You can find here a collection of challenges to test yourself and their solutions!
How well do you know a TypeScript and its type system?

> High-quality types can help to improve projects’ maintainability while avoiding potential bugs.
> This project is aimed at helping you better understand how the type system works, writing your own utilities, or just having fun with the challenges.
> We are also trying to form a community that you can ask questions and get answers you have faced in the actual world - they may become part of the challenges!
> (c) [type-challenges](https://github.com/type-challenges/type-challenges)

Try to solve the challenge first and if you could not solve it, you can open the solution and read a detailed explanation on how to solve it. Further in the solution, I’m providing references to TypeScript documentation where you can read more in details about specific type features I’ve used to solve the challenge.

Take your time and enjoy the challenges!

{% assign challenges = site.pages | where: "lang", "en" | sort: "title" %}

| Challenge | Solution |
| :-------: | :------: |
{%- for challenge in challenges %}
| [Challenge "{{ challenge.title }}"]({{ challenge.challenge_url }}) | [Solution "{{ challenge.title }}"]({{ challenge.url }}) |
{%- endfor %}
