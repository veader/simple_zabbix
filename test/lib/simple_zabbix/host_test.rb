require_relative '../../test_helper'

describe SimpleZabbix::Host do
  it 'should have many items' do
    host = SimpleZabbix::Host.new({})
    assert host.respond_to?(:items)
    items = host.items
    items.must_be_kind_of SimpleZabbix::Association
  end

  it 'should have many host_groups' do
    host = SimpleZabbix::Host.new({})
    assert host.respond_to?(:host_groups)
    host_groups = host.host_groups
    host_groups.must_be_kind_of SimpleZabbix::Association
  end

end
