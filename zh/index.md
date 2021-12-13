---
title: Type Challenges Solutions
description: >-
  该项目旨在帮助您更好地理解类型系统是如何工作的，编写自己的实用工具，或者只是为了享受挑战。
keywords: 'type, challenges, solutions, typescript, javascript'
lang: zh
comments: false
---

什么是 Type Challenges?
[Type Challenges](https://github.com/type-challenges/type-challenges) 是一个由[Anthony Fu](https://github.com/antfu)开发和维护的项目。
该项目的主要目标是收集并提供有趣的TypeScript挑战。这些挑战不能使用运行时，必须通过使用TypeScript类型系统才能解出。

这些挑战有时会很困难，尤其是如果你是类型和TypeScript的初学者。

所以，这个网站提供了一个地方，在那里你可以找到解出这些挑战的方法，并解释它们是如何被解出的。
如果想更深入地研究，可以阅读下方提供的参考资料。
如果你通过其它方式解出了这个挑战(不同于本网站)，你可以在评论中留言。

如果你有任何疑问或发现问题，请在本仓库[提交一个issue](https://github.com/ghaiklor/type-challenges-solutions/issues)。

现在，我建议你从"热身"开始，逐渐地向"很难"级别前进。
首先，打开"挑战"链接并尝试自己解出。
如果你无法解出，请返回此处并打开"解法"。

事不宜迟，慢慢来，享受挑战！

{% assign challenges = site.pages | where: "lang", "zh" %}
{% include challenges.html challenges = challenges %}
