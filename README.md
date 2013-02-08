[]: {{{1

    File        : README.md
    Maintainer  : Felix C. Stegerman <flx@obfusk.net>
    Date        : 2013-02-08

    Copyright   : Copyright (C) 2013  Felix C. Stegerman
    Version     : 0.0.1.dev

[]: }}}1

## Description
[]: {{{1

  [rb-]obfusk-data - data validation combinator library for ruby

  ...

```ruby
isa   = ->(cls) { ->(obj) { cls === obj } }
email = ->(x) { %r{^.*@.*\.[a-z]+$}.match x }

class Address < Obfusk::Data::Data
  field %w{ street number postal-code town }, [isa[String]]
  field :country, [isa[String]], optional: true
end

class Person < Obfusk::Data::Data
  field %w{ first_name last_name phone_number }, [isa[String]]
  field :email, [isa[String], email]
  field :address, [], isa: [Address]
end

class Tree < Obfusk::Data::Union
  union :type
  data :empty
  data :leaf do
    field :value, []
  end
  data :node do
    field %w{ left right }, [], isa: Tree
  end
end

Tree.valid? {
  type: :node,
  left: { type: :empty },
  right: { type: :leaf, value: "spam!" } }
}
; => true
```

[]: }}}1

## Specs & Docs
[]: {{{1

  ...

[]: }}}1

## TODO
[]: {{{1

  * ...

[]: }}}1

## License
[]: {{{1

  GPLv2 [1] or EPLv1 [2].

[]: }}}1

## References
[]: {{{1

  [1] GNU General Public License, version 2
  --- http://www.opensource.org/licenses/GPL-2.0

  [2] Eclipse Public License, version 1
  --- http://www.opensource.org/licenses/EPL-1.0

[]: }}}1

[]: ! ( vim: set tw=70 sw=2 sts=2 et fdm=marker : )
