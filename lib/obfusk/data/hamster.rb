# --                                                            ; {{{1
#
# File        : obfusk/data/hamster.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-02-11
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'obfusk/data/base'

module Obfusk
  module Data

    # @todo document
    # @note
    #   getting this to work depends on Hamster implementation details
    #   as well as some black magic ;-(
    class ValidHamster < Hamster::Hash                          # {{{1

      include Base

      class InvalidError < RuntimeError; end

      def self.__from_hamster (x)
        data  = x.instance_eval { [@trie, @default] }
        y     = allocate
        y.instance_eval { @trie, @default = data }
        y
      end

      def self.__to_hamster (x)
        data  = x.instance_eval { [@trie, @default] }
        y     = Hamster::Hash.allocate
        y.instance_eval { @trie, @default = data }
        y
      end

      def self.new (*a, &b)
        x = __from_hamster Hamster::Hash.new(*a, &b)
        x.validate!; x
      end

      def self.empty
        x = @empty ||= new; x.validate!; x
      end

      def except (*a, &b)
        y = self.class.__to_hamster self
        x = self.class.__from_hamster y.except(*a, &b)
        x.validate!; x
      end

      def transform (*a, &b)
        x = super; x.validate!; x
      end

    end                                                         # }}}1

  end
end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
