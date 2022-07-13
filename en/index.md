---
title: Type Challenges Solutions
description: >-
  This project is aimed at helping you better understand how the type system
  works, writing your own utilities, or just having fun with the challenges.
keywords: "type, challenges, solutions, typescript, javascript"
lang: en
comments: false
---

What is Type Challenges?
[Type Challenges](https://github.com/type-challenges/type-challenges) is a
project developed and maintained by Anthony Fu. The primary goal of the project
is to collect and provide interesting challenges for TypeScript. But, there is a
nuance in these challenges. You can’t use the runtime to solve them. The only
place where you need to write the “code” is in type system. So that, Type
Challenges are the challenges that must be solved only by using TypeScript type
system.

These challenges become hard sometimes, especially if you are a beginner in
types and TypeScript. So that, this website provides a place where you can find
solutions for those challenges with an explanation on how they’ve been solved.
Once you read the explanation, you can find a compiled list of useful references
to dive more in depth. In case you solved the challenge in some other way (not
like on this website) you can leave it in the comments.

If you have any questions, issues, etc, please
[open an issue in the repository](https://github.com/ghaiklor/type-challenges-solutions/issues).

Now, I’m suggesting to you to start from “Warm Up” and go forwards “Extreme”
level, challenge by challenge. First, open the “Challenge” link and try to solve
it yourself. In case you couldn’t manage, come back here and open the
“Solution”.

With no further ado, take your time and enjoy the challenges!

{% assign challenges = site.pages | where: "lang", "en" %}
{% include challenges.html challenges = challenges %}
