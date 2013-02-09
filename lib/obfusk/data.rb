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

    # this proxy allows us to define recursive types
    class Proxy                                                 # {{{1
      # init
      def initialize
        @f = nil
      end

      # bind
      def bind (f)
        @f = f
      end

      # call
      def call (*args)
        raise 'unbound Proxy called!' unless @f                 # TODO
        @f.call *args
      end

      # call
      def [] (*args)
        call *args
      end
    end                                                         # }}}1

    # this helper allows us to run field in the block passed to data
    class FieldsHelper                                          # {{{1
      # init
      def initialize
        @_fields = []
      end

      # add field
      def field (*args)
        @_fields << Obfusk::Data.field(*args)
      end

      # get fields
      def _fields
        @_fields
      end
    end                                                         # }}}1

    # this helper allows us to run data in the block passed to union
    class DatasHelper                                           # {{{1
      # init
      def initialize
        @_datas = {}
      end

      # add data
      def data (value, &block)
        @_datas[value] = Obfusk::Data._blk_flds block
      end

      # get datas
      def _datas
        @_datas
      end
    end                                                         # }}}1

    # --

    # empty sequence?
    def self._blank? (x)
      String === x || Enumerable === x ? x.empty? : false
    end

    # add error
    def self._error (st, *msg)
      e1 = st.get :errors
      e2 = e1.add msg.join
      st.put :errors, e2
    end

    # --

    # if only we had clojure's :keys ;-(
    def self._get_keys (x, keys)
      x.values_at *keys.map(&:to_sym)
    end

    # run block in instance of helper
    def self._blk_hlp (cls, block, *args)
      x = cls.new
      x.instance_exec *args, &block
      x
    end

    # turn block into fields using FieldsHelper
    def self._blk_flds (block, *args)
      block ? _blk_hlp(FieldsHelper, block, *args)._fields : []
    end

    # --

    # data validator w/o block magic
    def self.data_ (fields, opts = {})                          # {{{1
      o_flds  = opts[:other_fields]
      isa     = opts.fetch :isa, []
      st      = Hamster.hash errors: Hamster.vector,
                  processed: Hamster.set

      ->(x ; st_, ks, pks, eks) {
        if isa.any? { |x| validate x }
          _error st '[data] has failed isa'                     # TODO
        else
          st_ = fields.reduce(st) { |s, f| f[x, s] }
          ks  = x.keys.to_set
          pks = st_.get :processed
          eks = ks - pks

          if !o_flds && !eks.empty?
            _error st_, '[data] has extraneous fields'
          elsif !eks.all?(&o_flds)
            _error st_, '[data] has invalid other fields'
          else
            st_
          end
        end
      }
    end                                                         # }}}1

    # A data validator.  ...
    def self.data (opts = {}, &block)
      proxy = Proxy.new
      data  = data_ _blk_flds(block, proxy), opts
      proxy.bind data
      data
    end

    # --

    # validate a field
    def self._validate_field (name, predicates, opts, x, st)    # {{{1
      field = x[name]
      preds = predicates.map(&:to_proc)
      isa   = opts.fetch :isa, []

      st_   = st.put :processed, st.get(:processed).add(name)
      err   = ->(*msg) { _error st_, (opts[:message] || msg.join) }

      optional, o_nil, blank, o_if, o_if_not =
        _get_keys opts, %w{ optional o_nil blank o_if o_if_not }

      if (o_if && !o_if[x]) || (o_if_not && o_if_not[x])
        st_
      elsif !x.has_key? name
        optional ? st_ : err['[field] not found: ', name]
      elsif field.nil?
        o_nil || optional ? st_ : err['[field] is nil: ', name]
      elsif _blank?(field) && !(blank || optional)
        err['[field] is blank: ', name]
      elsif !preds.all? { |p| p[field] }
        err['[field] has failed predicates: ', name]
      elsif isa.any? { |x| validate x, field }
        err['[field] has failed isa: ', name]
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

    # union w/o block magic and data wrapping
    def self.union__ (key, datas)
      f = field key, [->(x) { Symbol === x }]

      ->(x, st ; fields) {
        fields = datas.fetch(x.fetch(key)) + [f]
        fields.reduce(st) { |s, field| field[x, s] }
      }
    end

    # union w/o block magic
    def self.union_ (key, datas, opts = {})
      data_ [union__(key, datas)], opts
    end

    # Union of data fields.  ...
    def self.union (key, opts = {}, &block)
      proxy = Proxy.new
      datas = _blk_hlp(DatasHelper, block, proxy)._datas
      data  = union_ key, datas, opts
      proxy.bind data
      data
    end

    # --

    # Validate.
    # @return [nil]       if valid
    # @return [<String>]  errors otherwise
    def self.validate (f, x)
      e = f[x].get :errors
      e.empty? ? nil : e.to_a
    end

    # Validate.
    def self.valid? (f, x)
      validate(f, x).nil?
    end

  end
end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
