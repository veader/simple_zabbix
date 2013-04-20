require_relative '../../test_helper'

describe SimpleZabbix do
  it 'should yield client' do
    client = SimpleZabbix.client
    client.must_be_kind_of SimpleZabbix::Client
    client.authenticated?.must_equal false
  end

end