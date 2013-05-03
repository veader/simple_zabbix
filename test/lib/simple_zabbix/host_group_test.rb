require_relative '../../test_helper'

describe SimpleZabbix::HostGroup do
  it 'should have many hosts' do
    group = SimpleZabbix::HostGroup.new({})
    assert group.respond_to?(:hosts)
    hosts = group.hosts
    hosts.must_be_kind_of SimpleZabbix::Association
  end

end