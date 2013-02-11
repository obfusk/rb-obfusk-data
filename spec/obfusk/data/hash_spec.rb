# --                                                            ; {{{1
#
# File        : obfusk/data/hash_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-02-11
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'obfusk/data/hash'

module Obfusk::Data::Hash__Spec

  class Bar < Obfusk::Data::Hash
    data other_fields: ->(x) { /other/.match x } do
      field :bar, [->(x) { /bar/.match x }], optional: true
    end
  end

  E = Obfusk::Data::Hash::InvalidHashError

  # --

  describe Obfusk::Data::Hash do

    context 'Bar' do                                            # {{{1
      it 'valid empty Bar' do
        Bar.new
      end
      it 'valid Bar #1' do
        Bar.new some_other_field: 37
      end
      it 'valid Bar #2' do
        Bar.new bar: 'bar?!'
      end
      it 'invalid Bar #1' do
        b = Bar.new
        expect { b.merge baz: 42 }.to raise_error E
      end
      it 'invalid Bar #2' do
        b = Bar.new
        expect { b[:bar] = 'hi!' }.to raise_error E
      end
    end                                                         # }}}1

    # ... TODO ...

  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
