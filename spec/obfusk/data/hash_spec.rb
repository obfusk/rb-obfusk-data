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

  class Bar < Obfusk::Data::ValidHash
    data other_fields: ->(x) { /other/.match x } do
      field :bar, [->(x) { /bar/.match x }], optional: true
    end
  end

  class Baz < Obfusk::Data::ValidHash
    data do
      field :baz, []
    end
  end

  E = Obfusk::Data::ValidHash::InvalidError

  # --

  describe Obfusk::Data::ValidHash do

    context 'Bar' do                                            # {{{1
      it 'valid empty Bar' do
        Bar.new
      end
      it 'valid Bar' do
        Bar.new bar: 'bar?!'
      end
      it 'valid Bar w/ other field' do
        Bar.new some_other_field: 37
      end
      it 'invalid Bar' do
        expect { Bar.new baz: 42 }.to raise_error E
      end
      it 'invalid Bar merge' do
        b = Bar.new
        expect { b.merge baz: 42 }.to raise_error E
      end
      it 'invalid Bar []=' do
        b = Bar.new
        expect { b[:bar] = 'hi!' }.to raise_error E
      end
    end                                                         # }}}1

    context 'Baz' do                                            # {{{1
      it 'invalid Baz clear' do
        b = Baz.new baz: 'ok'
        expect { b.clear }.to raise_error E
      end
    end                                                         # }}}1

    # ... TODO ...

  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :