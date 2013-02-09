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

    class DatasHelper                                           # {{{1
      def initialize
        @_datas = {}
      end

      def data (value, &block)
        @_datas[value] = Obfusk::Data.data &block
      end

      def _datas
        @_datas
      end
    end                                                         # }}}1

    # --

    def self._blank? (x)
      String === x || Enumerable === x ? x.empty? : false
    end

    def _self._get_keys (x, keys)
      x.values_at *keys.map(&:to_sym)
    end

    def self._error (st, *msg)
      e1 = st.get :errors
      e2 = e1.add msg.join
      st.put :errors, e2
    end

    # --

    # A data validator.  ...
    def self.data (opts = {}, &block)                           # {{{1
      o_flds  = opts[:other_fields].to_proc
      isa     = opts.fetch :isa, []

      fields  = block ? block[FieldsHelper.new]._fields : []
      st      = Hamster.hash errors: Hamster.vector,
                  processed: Hamster.set

      ->(x ; st_, ks, pks, eks) {
        if !isa.empty? && isa.any? { |x| validate x }
          _error st '[data] has failed isa'                     # TODO
        else
          st_ = fields.reduce(st) { |s, f| f[x, s] }
          ks  = x.keys.to_set
          pks = st_.get :processed
          eks = ks - pks

          if !o_flds && !eks.empty?
            _error st_, '[data] has extraneous fields'
          elsif !eks.all? o_flds
            _error st_, '[data] has invalid other fields'
          else
            st_
          end
        end
      }
    end                                                         # }}}1

    # --

    def self._validate_field (name, predicates, opts, x, st)    # {{{1
      field = x[name]
      preds = predicates.map(&:to_proc)
      isa   = opts.fetch :isa, []

      st_   = st.put :processed, st.get(:processed).add(name)
      err   = ->(*msg) {
        _error st_, (opts.fetch(:message) || msg.join)
      }

      optional, o_nil, blank, o_if, o_if_not =
        _get_keys opts, %w{ optional o_nil blank o_if o_if_not }

      if (o_if && !o_if[x]) || (o_if_not && o_if_not[x])
        st_
      elsif !x.has_key? name
        optional ? st_ : err('[field] not found: ', name)
      elsif field.nil?
        o_nil || optional ? st_ : err('[field] is nil: ', name)
      elsif blank?(field) && !(blank || optional)
        err '[field] is blank: ', name
      elsif ! preds.all? { |p| p[field] }
        err '[field] has failed redicates: ', name
      elsif !isa.empty? && isa.any? { |x| validate x, field }
        err '[field] has failed isa: ', name
      else
        st_
      end
    end                                                         # }}}1

    # A data field.  Predicates are functions that are invoked with
    # the field's value, and must all return true.  ...
    def self.field (names, predicates, opts = {})
      f   = ->(n, x, s) { _validate_field n, predicates, opts, x, s }
      ns  = Enumerable === names ? names : [names]

      ->(x, st) { ns.reduce(st) { |s, name| f[name, x, s] } }
    end

    # --

    # Union of data fields.  ...
    def self.union (key, opts = {}, &block)
      b = block[DatasHelper.new]._datas

      ->(x, st ; fields, fields_) {
        fields  = b.fetch x.fetch(key)
        fields_ = fields + [ field key, [->(x) { Symbol === x }] ]
        fields_.reduce(st) { |s, field| field[x, s] }
      }
    end

    # --

    # Validate; returns nil if valid, errors otherwise.
    def self.validate (f, x)
      e = f[x].get :errors
      e.empty? ? nil : e
    end

    # Validate; returns true/false.
    def self.valid? (f, x)
      validate(f, x).nil?
    end

  end
end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
