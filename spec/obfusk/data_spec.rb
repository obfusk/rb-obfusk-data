require 'obfusk/data'

isa   = ->(cls) { ->(obj) { cls === obj } }
email = ->(x) { %r{^.*@.*\.[a-z]+$}.match x }

address = Obfusk::Data.data do
  field %w{ street number postal-code town }, [isa[String]]
  field :country, [isa[String]], optional: true
end

person = Obfusk::Data.data do
  field %w{ first_name last_name phone_number }, [isa[String]]
  field :email, [isa[String], email]
  field :address, [], isa: [address]
end

tree = Obfusk::Data.union :type do
  data :empty
  data :leaf do
    field :value, []
  end
  data :node do
    field %w{ left right }, [], isa: tree # TODO
  end
end

# --

describe Obfusk::Data do
  context 'address' do
    it do
      should be_valid address,
        { street: 'baker street', number: '221b',
          town: 'london', postal_code: '???', country: 'uk' }
    end
    it do
      should_not be_valid address,
        { street: 'baker street', number: 404 }
    end
  end

  # ...
end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
