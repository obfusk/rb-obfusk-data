# --                                                            ; {{{1
#
# File        : obfusk/data/hamster.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-02-13
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'obfusk/data/valid'

module Obfusk
  module Data

    # @todo document
    # @note depends on Hamster implementation details !!!
    class ValidHamster < Hamster::Hash                          # {{{1

      include Valid

      def self.new (pairs = {}, &b)
        @empty ||= super()
        x = b ? super(&b) : @empty
        pairs.empty? ? x.validate! : x.merge_hash(pairs)
      end

      def self.empty
        @empty ? @empty.validate! : new
      end

      def except (*keys)
        trie = keys.reduce(@trie) { |t, k| t.delete k }
        transform_unless(trie.equal? @trie) { @trie = trie }
      end

      def merge_hash (pairs)
        transform_unless(pairs.empty?) {
          @trie = pairs.reduce(@trie) { |t, p| t.put *p }
        }
      end

      def transform (&b)
        super.validate!
      end

    end                                                         # }}}1

  end
end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
