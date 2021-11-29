---
title: Type Challenges Solutions
description: >-
  이 프로젝트는 타입 시스템이 어떻게 작동하는지 더 잘 이해하는 것을 돕고, 스스로 유틸리티 타입을 만들어보거나 혹은 새롭고 즐거운 문제들을 경험해보는 것을 목표로 합니다. 
keywords: 'type, challenges, solutions, typescript, javascript'
lang: ko
comments: false
---

[Type Challenges](https://github.com/type-challenges/type-challenges)가 무엇인가요?
Type Challenges는 Anthony Fu가 만들고 유지 중인 프로젝트입니다.
본 프로젝트의 목표는 Typescript에 관한 흥미로운 챌린지들을 모아 제공하는 것입니다.
단, 이 챌린지에는 특이점이 있습니다. 
챌린지들을 런타임 내에서 해결할 수 없습니다. 
타입 시스템이 적용되는 단계까지에서 문제를 해결해야합니다.
따라서, Type Challenges는 Typescript의 타입시스템만을 이용해서 해결하는 챌린지들입니다.

타입과 Typescript가 낯설다면 몇개의 챌린지들은 쉽지 않을 것입니다.
그래서 이 웹사이트는 그러한 챌린지들을 어떻게 해결했는지에 대한 설명과 함께 해답을 제공합니다.
이 설명들을 읽으면서 더 깊은 내용을 알 수 있는 유용한 레퍼런스들을 찾을 수 있습니다.
다른 방법(이 웹사이트와는 다른 방법)으로 챌린지를 해결했을 경우에는 댓글로 남겨주세요.

질문, 이슈 등이 있을 때에는 [이 레포지토리에 이슈를 남겨주세요](https://github.com/ghaiklor/type-challenges-solutions/issues).

이제 "Warm Up" 단계부터 "Extreme" 단계까지 차근차근 도전해보세요.
먼저 "챌린지" 링크를 열고 스스로 해결해보세요.
혼자 해결이 어려울 경우에 다시 돌아와서 "해답"을 참고하면 됩니다.

설명은 여기까지입니다. 이제 챌린지에 도전해보세요!

{% assign challenges = site.pages | where: "lang", "ko" %}
{% include challenges.html challenges = challenges %}