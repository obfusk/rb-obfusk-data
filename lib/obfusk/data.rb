module Obfusk
  module Data

    def self._validate_field (name, predicates, opts, x, st)
      # ...
    end

    def self.field (names, predicates, opts = {})
      f   = ->(n, x, s) { _validate_field n, predicates, opts, x, s }
      ns  = Array === names ? names : [names]

      ->(x, st) { names.reduce(st) { |s, name| f[name, x, s] } }
    end

    # --

    def self.data (opts = {}, &block)
      st = { errors: [], processed: ... }
    end

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
