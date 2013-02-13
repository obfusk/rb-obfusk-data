# --                                                            ; {{{1
#
# File        : obfusk/data/hamster_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-02-13
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'obfusk/data/hamster'

module Obfusk::Data::Hamster__Spec

  class Bar < Obfusk::Data::ValidHamster
    data other_fields: ->(x) { /other/.match x } do
      field :bar, [->(x) { /bar/.match x }], optional: true
    end
  end

  class Baz < Obfusk::Data::ValidHamster
    data do
      field :baz  , []
      field :maybe, [], optional: true
    end
  end

  E = Obfusk::Data::Valid::InvalidError

  # --

  describe Obfusk::Data::ValidHamster do

    context 'Bar' do                                            # {{{1
      it 'valid empty Bar (2x)' do
        Bar.new; Bar.empty
      end
      it 'valid Bar' do
        Bar.new bar: 'bar?!'
      end
      it 'valid Bar w/ other field' do
        Bar.new some_other_field: 37
      end
      it 'invalid Bar' do
        expect { Bar.new baz: 42 }.to raise_error(E)
      end
      it 'invalid Bar merge' do
        b = Bar.new
        expect { b.merge Hamster.hash baz: 42 }.to raise_error(E)
      end
      it 'invalid Bar put' do
        b = Bar.new
        expect { b.put :bar, 'hi!' }.to raise_error(E)
      end
    end                                                         # }}}1

    context 'Baz' do                                            # {{{1
      it 'valid Baz' do
        Baz.new baz: 'ok!'
      end
      it 'valid Baz except' do
        b = Baz.new baz: 1, maybe: 2
        b.except :maybe
      end
      it 'invalid empty Baz (new)' do
        expect { Baz.new }.to raise_error(E)
      end
      it 'invalid empty Baz (empty)' do
        expect { Baz.empty }.to raise_error(E)
      end
      it 'invalid Baz except' do
        b = Baz.new baz: 1, maybe: 2
        expect { b.except :baz }.to raise_error(E)
      end
    end                                                         # }}}1

    # ... TODO ...

  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
