<h1>Hello World <img src="https://img.shields.io/badge/-warm--up-teal" alt="warm-up"/> </h1>

## Challenge

Hello, World!

In Type Challenges, we uses the type system itself to do the assertion. 

For this challenge, you will need to change the following code to make the tests pass (no type check errors).

```ts
// expected to be string
type HelloWorld = any
```

```ts
// you should make this work
type test = Expect<Equal<HelloWorld, string>>
```

## Solution

Just a warm up challenge where we are going to use types.
In our case, the type is `string`:

```ts
type HelloWorld = string
```

In case you are a newcomer into TypeScript world, I highly recommend reading their [handbook](https://www.typescriptlang.org/docs/handbook/intro.html).
You will find anything needed to write TypeScript code there.
