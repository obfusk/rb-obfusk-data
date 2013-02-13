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
    # @todo what to do about defaults !?
    class ValidHashBase < Hash                                  # {{{1

      include Valid

      TRANSFORMATIONS = %w{
        []= clear delete merge! replace shift store update
      }.map(&:to_sym)

      TRANSFORMATIONS_ENUMERATORS = %w{
        delete_if keep_if reject! select!
      }.map(&:to_sym)

      UNIMPLEMENTED = %w{
        compare_by_identity default= default_proc=
      }.map(&:to_sym)

      UNIMPLEMENTED.each do |m|
        define_method m do |*a, &b|
          raise NotImplementedError
        end
      end

      def self.[] (*a, &b)
        # NB: we must validate b/c super uses allocate instead of new
        super.validate!
      end

      def initialize (data = {}, &b)
        super(&b); self.merge! data
      end

      # @return [Hash]
      def invert
        Hash[self].invert
      end

      def merge (*a, &b)
        super.validate!
      end

      def reject (*a, &b)
        return to_enum :reject, *a unless b
        super.validate!
      end

      def select (*a, &b)
        return to_enum :select, *a unless b

        # NB: super returns a Hash; implementing select manually is
        # problematic b/c new() and []=; this is the simplest (but not
        # the most efficient -- b/c copying) implementation

        self.class[super]                                       # TODO
      end

      # @return [Hash]
      def to_hash
        Hash[self]
      end

    end                                                         # }}}1

    # @todo document
    class ValidHash < ValidHashBase                             # {{{1

      alias_method  :__validhash__original_replace__, :replace
      private       :__validhash__original_replace__

      def __validhash__validate_and_rollback__ (c, r)
        begin
          validate!; r
        rescue InvalidError
          __validhash__original_replace__ c; raise
        end
      end
      private :__validhash__validate_and_rollback__

      TRANSFORMATIONS.each do |m|
        define_method m do |*a, &b|
          __validhash__validate_and_rollback__ dup, super(*a, &b)
        end
      end

      TRANSFORMATIONS_ENUMERATORS.each do |m|
        define_method m do |*a, &b|
          return to_enum m, *a unless b
          __validhash__validate_and_rollback__ dup, super(*a, &b)
        end
      end

    end                                                         # }}}1

    # @todo document
    class UnsafeValidHash < ValidHashBase                       # {{{1

      TRANSFORMATIONS.each do |m|
        define_method m do |*a, &b|
          r = super(*a, &b); validate!; r
        end
      end

      TRANSFORMATIONS_ENUMERATORS.each do |m|
        define_method m do |*a, &b|
          return to_enum m, *a unless b
          r = super(*a, &b); validate!; r
        end
      end

    end                                                         # }}}1

  end
end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
