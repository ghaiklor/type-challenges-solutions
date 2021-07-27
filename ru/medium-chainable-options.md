---
id: 12
title: Chainable Options
lang: ru
level: medium
tags: application
---

## Проблема

В мире JavaScript, часто используется шаблон последовательного вызова функций, по цепочке.
Но когда речь заходит о TypeScript, можете ли вы правильно реализовать тип для такой возможности?

Реализуйте тип для объекта или класса, неважно.
Этот тип предоставляет два метода `option(key, value)` и `get()`.
Вызывая метод `option(key, value)` мы расширяем текущий тип конфигурации, который получаем через вызов метода `get()`.
Например:

```typescript
declare const config: Chainable

const result = config
  .option('foo', 123)
  .option('name', 'type-challenges')
  .option('bar', { value: 'Hello World' })
  .get()

// expect the type of result to be:
interface Result {
  foo: number
  name: string
  bar: {
    value: string
  }
}
```

Для решения этой проблемы не нужно писать никакой реализации на JavaScript или TypeScript.
Решение этой проблемы должно быть только на уровне типов.

## Решение

Что автор этой проблемы просит нас сделать?
Реализовать два метода `option(key, value)` и `get()`.
Каждый последующий вызов `option(key, value)` аккумулирует информацию о типах `key` и `value`.
Аккумулирование продолжается до тех пор, пока не будет вызван метод `get()`, который вернёт собранную информацию о типах как объект.

Начнём с интерфейса, который автор проблемы и предоставляет:

```typescript
type Chainable = {
  option(key: string, value: any): any
  get(): any
}
```

Прежде чем начнём аккумулировать информацию о типах, это было бы очень кстати начать её получать.
Поэтому заменяем `string` в `key` и `any` в `value` на тип параметры.
Таким образом, TypeScript сможет автоматически вывести типы и присвоить к нашим тип параметрам:

```typescript
type Chainable = {
  option<K, V>(key: K, value: V): any
  get(): any
}
```

У нас есть информация о типах `key` и `value`.
TypeScript выведёт `key` как строчный тип литерал, а `value` как общий тип.
Например, вызывая `option('foo', 123)` TypeScript присвоит к нашим тип параметрам `K = 'foo'` и `V = number`.

Информация есть, да, но где её хранить?
Это должно быть место, которое сохраняет состояние между вызовами методов.
И единственное место, где мы можем это сделать - это на самом типе `Chainable`!

Добавим новый тип параметр `O` к типу `Chainable` и не забудем, что по умолчанию этот тип параметр - пустой объект.

```typescript
type Chainable<O = {}> = {
  option<K, V>(key: K, value: V): any
  get(): any
}
```

Нужно, чтобы `option(key, value)` возвращал сам тип `Chainable` (мы же хотим иметь возможность вызывать методы по цепочке) но с информацией о типах предыдущих вызовов вместе с текущим.
Воспользуемся типами пересечений, чтобы добавлять новые типы в аккумулятор `O`.

```typescript
type Chainable<O = {}> = {
  option<K, V>(key: K, value: V): Chainable<O & { [P in K]: V }>
  get(): any
}
```

Остались мелкие детали!
Получаем ошибку компиляции “Type ‘K’ is not assignable to type ‘string | number | symbol’.“.
Это по той причине, что у нас нету ограничений на тип параметре `K`, которые бы указывали на принадлежность к строке:

```typescript
type Chainable<O = {}> = {
  option<K extends string, V>(key: K, value: V): Chainable<O & { [P in K]: V }>
  get(): any
}
```

Всё готово к финальному аккорду!
Когда разработчик будет вызывать метод `get()`, он [метод] возвращает тип параметр `O` из `Chainable`.
Тот самый `O`, в который мы и накапливали информацию о типах при вызовах `option(key, value)`, используя типы пересечений.

```typescript
type Chainable<O = {}> = {
  option<K extends string, V>(key: K, value: V): Chainable<O & { [P in K]: V }>
  get(): O
}
```

## Что почитать

- [Типы пересечений](https://www.typescriptlang.org/docs/handbook/2/objects.html#intersection-types)
- [Сопоставляющие типы](https://www.typescriptlang.org/docs/handbook/2/mapped-types.html)
- [Общие типы](https://www.typescriptlang.org/docs/handbook/generics.html)
