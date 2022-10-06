---
title: Type Challenges 解答集
description: >-
  このプロジェクトは、型システムの仕組みをより深く理解すること、自らユーティリティを書けるようになること、そして各課題を楽しむことを目的としています。
keywords: "type, challenges, solutions, typescript, javascript"
lang: ja
comments: false
---

Type Challenges をご存知でしょうか? 
[Type Challenges](https://github.com/type-challenges/type-challenges) は、Anthony Fu により開発・メンテナンスされているプロジェクトです。
このプロジェクトの主要な目的は、TypeScript に関する面白い課題を集め、そして提供することです。
しかし、その課題にはちょっとした特徴があります。
それは、課題を解く際にランタイムを使用することができないということです。
コードを書く唯一の場所は、TypeScript の型システムの中にあります。
つまり、Type Challenges は、TypeScript の型システムによってのみ解くことができるような課題であるといえます。

型や TypeScript に関して不慣れである場合、一部の課題を難しく感じることがあるかもしれません。
そこでこのサイトでは、各課題への解答と、解法に関する説明を提供しようと思います。
解説の後ろには、より深く理解するために役立つ参考資料のリストがあります。
 (このサイトの解法とは異なるような) 他の方法で課題を解いた場合は、コメント欄にその方法を残してみてください。

質問や問題などがあれば、[リポジトリにて issue を開きましょう](https://github.com/ghaiklor/type-challenges-solutions/issues)。

まずは「ウォームアップ」から始めて、「エクストリーム」レベルまで順に進んでいくことをおすすめします。
最初は「課題」のリンクを開いて、自分で解いてみましょう。
わからなかった場合は、ここに戻って「解答」のリンクを開いてみてください。

それでは、ごゆっくりと各課題をお楽しみください!

{% assign challenges = site.pages | where: "lang", "ja" %}
{% include challenges.html challenges = challenges %}
