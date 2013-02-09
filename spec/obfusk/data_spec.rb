# --                                                            ; {{{1
#
# File        : obfusk/data.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-02-08
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'obfusk/data'

# --

isa       = ->(cls, obj) { cls === obj } .curry
is_string = isa[String]

is_email  = ->(x) { %r{^.*@.*\.[a-z]+$}.match x }
is_url    = ->(x) { %r{^https?://.*$}.match x }

is_object_id = ->(x) {
  is_string[x] && x.length == 16 &&
    x.chars.all? { |c| %{^[a-zA-Z0-9]$}.match c }
}

is_id_seq = ->(x) { isa[Enumberable, x] && x.all?(&is_object_id) }
is_id_map = ->(m) {
  isa[Hash, m] && m.all? { |k,v| is_string[k] && is_object_id[v] }
}

# --

foo = Obfusk::Data.data other_fields: ->(x) { %r{^data_}.match x }

tree = Obfusk::Data.union :type do |_tree|
  data :empty
  data :leaf do
    field :value, []
  end
  data :node do
    field [:left, :right], [], isa: [_tree]
  end
end

# --

address = Obfusk::Data.data do
  field [:street, :number, :postal_code, :town], [is_string]
  field :country, [is_string], optional: true
end

person = Obfusk::Data.data do
  field [:first_name, :last_name, :phone_number], [is_string]
  field :email, [is_string, is_email]
  field :address, [], isa: [address]
end

# --

collection = Obfusk::Data.data do
  field :_id  , [is_object_id]
  field :app  , [is_string]
  field :icon , [is_object_id]
  field :items, [is_id_seq]
  field :title, [is_string], optional: true
end

item = Obfusk::Data.data do
  field :_id            , [is_object_id]
  field :type           , [is_string]
  field :icon           , [is_object_id], nil: true
  field :data           , []            , optional: true
  field :title          , [is_string]   , optional: true
  field :url            , [is_url]      , optional: true
  field [:refs, :files] , [is_id_map]   , optional: true

  # (not= (contains? x :url)
  #       (contains? (get x :files {}) :url))                   ; TODO
end

item_files = Obfusk::Data.data do
  field :url, [is_url], optional: true
end

image_item = Obfusk::Data.data isa: [item] do
  field :icon , [:nil?]
  field :data , [:nil?], optional: true
  field :files, isa: [item_files]
end

# --

describe Obfusk::Data do

  context 'foo' do                                              # {{{1
    it 'valid empty foo' do
      should be_valid foo, {}
    end
    it 'valid foo' do
      should be_valid foo, { data_bar: 37 }
    end
    it 'invalid foo' do
      should_not be_valid foo, { baz: 42 }
    end
  end                                                           # }}}1

  context 'tree' do                                             # {{{1
    it 'valid empty tree' do
      should be_valid tree, { type: :empty }
    end
    it 'invalid empty tree' do
      should_not be_valid tree, { type: :empty, foo: 'hi!' }
    end
    it 'valid tree leaf' do
      should be_valid tree, { type: :leaf, value: 3.14 }
    end
    it 'invalid tree leaf' do
      should_not be_valid tree, { type: :leaf }
    end
    it 'valid tree node' do
      should be_valid tree,
        { type: :node,
          left: { type: :empty },
          right: { type: :leaf, value: 'spam!' } }
    end
    it 'invalid tree node' do
      should_not be_valid tree,
        { type: :node, left: { type: :empty }, right: nil }
    end
  end                                                           # }}}1

  context 'address' do                                          # {{{1
    it 'valid address' do
      should be_valid address,
        { street: 'baker street', number: '221b',
          town: 'london', postal_code: '???', country: 'uk' }
    end
    it 'invalid address' do
      should_not be_valid address,
        { street: 'baker street', number: 404 }
    end
  end                                                           # }}}1

  # ... TODO ...

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
