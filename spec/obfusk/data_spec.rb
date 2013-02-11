# --                                                            ; {{{1
#
# File        : obfusk/data_spec.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-02-11
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require './spec/_data'

module Obfusk::Data__Spec

  describe Obfusk::Data do

    context 'Foo' do                                            # {{{1
      it 'valid empty Foo' do
        should be_valid Foo, {}
      end
      it 'valid Foo' do
        should be_valid Foo, { data_bar: 37 }
      end
      it 'invalid Foo' do
        should_not be_valid Foo, { baz: 42 }
      end
    end                                                         # }}}1

    context 'Tree' do                                           # {{{1
      it 'valid empty Tree' do
        should be_valid Tree, { type: :empty }
      end
      it 'invalid empty Tree' do
        should_not be_valid Tree, { type: :empty, Foo: 'hi!' }
      end
      it 'valid Tree leaf' do
        should be_valid Tree, { type: :leaf, value: 3.14 }
      end
      it 'invalid Tree leaf' do
        should_not be_valid Tree, { type: :leaf }
      end
      it 'valid Tree node' do
        should be_valid Tree,
          { type: :node,
            left: { type: :empty },
            right: { type: :leaf, value: 'spam!' } }
      end
      it 'invalid Tree node' do
        should_not be_valid Tree,
          { type: :node, left: { type: :empty }, right: nil }
      end
    end                                                         # }}}1

    context 'Address' do                                        # {{{1
      it 'valid Address' do
        should be_valid Address,
          { street: 'baker street', number: '221b',
            town: 'london', postal_code: '???', country: 'uk' }
      end
      it 'invalid Address' do
        should_not be_valid Address,
          { street: 'baker street', number: 404 }
      end
    end                                                         # }}}1

    # ... TODO ...

  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
