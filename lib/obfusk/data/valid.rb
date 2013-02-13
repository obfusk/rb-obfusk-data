# --                                                            ; {{{1
#
# File        : obfusk/data/valid.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-02-13
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'obfusk/data'

module Obfusk
  module Data

    # @todo document
    module Valid

      class InvalidError < RuntimeError; end

      def self.included (base)
        base.extend ClassMethods
      end

      module ClassMethods

        def data (*a, &b)
          const_set :VALIDATOR, Obfusk::Data.data(*a, &b)
        end

        def union (*a, &b)
          const_set :VALIDATOR, Obfusk::Data.union(*a, &b)
        end

      end

      def validate!
        e = Obfusk::Data.validate self.class::VALIDATOR, self
        raise self.class::InvalidError, e.join('; ') if e
        self
      end

      def valid?
        Obfusk::Data.valid? self.class::VALIDATOR, self
      end

    end

  end
end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
