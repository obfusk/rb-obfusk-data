# --                                                            ; {{{1
#
# File        : _data.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-02-11
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'obfusk/data'

module Obfusk::Data__Spec

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

  Foo = Obfusk::Data.data other_fields: ->(x) { %r{^data_}.match x }

  Tree = Obfusk::Data.union :type do |_tree|
    data :empty
    data :leaf do
      field :value, []
    end
    data :node do
      field [:left, :right], [], isa: [_tree]
    end
  end

  # --

  Address = Obfusk::Data.data do
    field [:street, :number, :postal_code, :town], [is_string]
    field :country, [is_string], optional: true
  end

  Person = Obfusk::Data.data do
    field [:first_name, :last_name, :phone_number], [is_string]
    field :email, [is_string, is_email]
    field :address, [], isa: [Address]
  end

  # --

  Collection = Obfusk::Data.data do
    field :_id  , [is_object_id]
    field :app  , [is_string]
    field :icon , [is_object_id]
    field :items, [is_id_seq]
    field :title, [is_string], optional: true
  end

  Item = Obfusk::Data.data do
    field :_id            , [is_object_id]
    field :type           , [is_string]
    field :icon           , [is_object_id], nil: true
    field :data           , []            , optional: true
    field :title          , [is_string]   , optional: true
    field :url            , [is_url]      , optional: true
    field [:refs, :files] , [is_id_map]   , optional: true

    # (not= (contains? x :url)
    #       (contains? (get x :files {}) :url))                 ; TODO
  end

  Item_files = Obfusk::Data.data do
    field :url, [is_url], optional: true
  end

  Image_item = Obfusk::Data.data isa: [Item] do
    field :icon , [:nil?]
    field :data , [:nil?], optional: true
    field :files, isa: [Item_files]
  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
