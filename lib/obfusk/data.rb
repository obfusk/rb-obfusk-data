# --                                                            ; {{{1
#
# File        : obfusk/data.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2013-02-08
#
# Copyright   : Copyright (C) 2013  Felix C. Stegerman
# Licence     : GPLv2 or EPLv1
#
# --                                                            ; }}}1

require 'hamster'
require 'set'

module Obfusk
  module Data

    class FieldsHelper                                          # {{{1
      def initialize
        @_fields = []
      end

      def field (*args)
        @_fields << Obfusk::Data.field *args
      end

      def _fields
        @_fields
      end
    end                                                         # }}}1

    # --

    def self._blank? (x)
      String === x || Enumerable === x ? x.empty? : false
    end

    def self._error (st, *msg)
      e1 = st.get :errors
      e2 = e1.add msg.join
      st.put :errors, e2
    end

    # --

    # A data validator.  ...
    def self.data (opts = {}, &block)                           # {{{1
      o_flds  = opts.get :other_fields
      isa     = opts.get :isa, []

      fields  = block ? block[FieldsHelper.new]._fields : []
      st      = Hamster.hash errors: Hamster.vector,
                  processed: Hamster.set

      ->(x ; st_, ks, pks, eks) {
        if !isa.empty? && isa.any? { |x| validate x }
          _error st '[data] has failed isa'                     # TODO
        else
          st_ = fields.reduce(st) { |s,f| f[x,s] }
          ks  = x.keys.to_set
          pks = st_.get :processed
          eks = ks - pks

          if !o_flds && !eks.empty?
            _error st_, '[data] has extraneous fields'
          elsif Proc === o_flds && !eks.all? o_flds
            _error st_, '[data] has invalid other fields'
          else
            st_
          end
        end
      }
    end                                                         # }}}1


    def self._validate_field (name, predicates, opts, x, st)
      # ...
    end

# ..........

    def self.field (names, predicates, opts = {})
      f   = ->(n, x, s) { _validate_field n, predicates, opts, x, s }
      ns  = Array === names ? names : [names]

      ->(x, st) { names.reduce(st) { |s, name| f[name, x, s] } }
    end

    # --

    def self.union (field, opts = {}, &block)
    end

    # --

    def self.validate (f, x)
      e = f[x][:errors]
      e.empty? ? nil : e
    end

    def self.valid? (f, x)
      ! validate(f, x)
    end

  end
end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
