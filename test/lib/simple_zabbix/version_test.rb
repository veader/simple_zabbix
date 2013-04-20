require_relative '../../test_helper'

describe SimpleZabbix do
  it 'should have defined version' do
    SimpleZabbix::VERSION.wont_be_nil
    SimpleZabbix::VERSION.must_be_kind_of String
  end
end