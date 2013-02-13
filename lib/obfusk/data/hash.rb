# --                                                            ; {{{1
#
# File        : obfusk/data/hash.rb
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
    class ValidHash < Hash                                      # {{{1

      include Valid

      %w{
        []= clear delete delete_if keep_if merge! reject! replace
        select! shift store update
      }.map(&:to_sym).each do |m|
        define_method m do |*a, &b|
          r = super(*a, &b); validate!; r
        end
      end

      def self.[] (*a, &b)
        x = super; x.validate!; x
      end

      def initialize (data = {}, &block)
        super(&block); self.merge! data
      end

      def compare_by_identity
        raise NotImplementedError
      end

      def invert
        Hash[self].invert
      end

      def merge (*a, &b)
        x = super; x.validate!; x
      end

      def reject (*a, &b)
        x = super; x.validate!; x
      end

      def select (*a, &b)
        x = self.class[super]; x.validate!; x                   # TODO
      end

      def to_hash
        Hash[self]
      end

    end                                                         # }}}1

  end
end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
