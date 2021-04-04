---
title: Welcome!
lang: en
comments: false
---

You can find here a collection of challenges to test yourself and their solutions!
How well do you know a TypeScript and its type system?

> High-quality types can help to improve projects’ maintainability while avoiding potential bugs.
> This project is aimed at helping you better understand how the type system works, writing your own utilities, or just having fun with the challenges.
> We are also trying to form a community that you can ask questions and get answers you have faced in the actual world - they may become part of the challenges!

If you want to try out solve them yourselves first, go ahead to [type-challenges](https://github.com/type-challenges/type-challenges) repository.
There you can find all the challenges, even those that I didn’t solve (yet!).
In case you are stuck, get back here and open the solution to your challenge.

There you will find an explanation on how to solve it.
Further in the solution, I’m providing references to TypeScript documentation where you can read more in details about specific type features I’ve used to solve it.

If you have questions, go ahead to [issues](https://github.com/ghaiklor/type-challenges-solutions/issues) and raise it there.
Take your time and enjoy!

{% assign challenges = site.pages | where: "lang", "en" %}
{% include draw_challenges_table.html challenges = challenges %}
