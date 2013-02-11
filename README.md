[]: {{{1

    File        : README.md
    Maintainer  : Felix C. Stegerman <flx@obfusk.net>
    Date        : 2013-02-11

    Copyright   : Copyright (C) 2013  Felix C. Stegerman
    Version     : 0.0.2.SNAPSHOT

[]: }}}1

## Description
[]: {{{1

  [rb-]obfusk-data - data validation combinator library for ruby

  ...

  https://github.com/obfusk/clj-obfusk-data in ruby.

```ruby
isa       = ->(cls, obj) { cls === obj } .curry
is_string = isa[String]
is_email  = ->(x) { %r{^.*@.*\.[a-z]+$}.match x }

address = Obfusk::Data.data do
  field [:street, :number, :postal_code, :town], [is_string]
  field :country, [is_string], optional: true
end

person = Obfusk::Data.data do
  field [:first_name, :last_name, :phone_number], [is_string]
  field :email, [is_string, is_email]
  field :address, [], isa: [address]
end

tree = Obfusk::Data.union :type do |_tree|
  data :empty
  data :leaf do
    field :value, []
  end
  data :node do
    field [:left, :right], [], isa: [_tree]
  end
end

Obfusk::Data.valid? tree,
  { type: :node,
    left: { type: :empty },
    right: { type: :leaf, value: "spam!" } }
# => true
```

[]: }}}1

## Specs & Docs
[]: {{{1

    $ rake spec
    $ rake docs

[]: }}}1

## TODO
[]: {{{1

  * add more ruby-ish api ?

#

  * write more specs
  * write more docs
  * show isa errors
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
