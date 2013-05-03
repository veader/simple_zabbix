require_relative '../../test_helper'

describe SimpleZabbix::Associations do
  def setup
    @client = SimpleZabbix::Client.new(nil,nil,nil)
    @client.stubs(:authenticate).returns(true)
  end

  it 'should create instance method for association' do
    host = SimpleZabbix::Host.new({})
    assert host.respond_to?(:items)
    items = host.items
    items.must_be_kind_of SimpleZabbix::Association
  end

  it 'should pass along client to all resulting objects' do
    @client.stubs(:query_api).returns([[{id: 1},{id: 2},{id: 3}], nil])
    host = SimpleZabbix::Host.new({id: 'foo'})
    host.client = @client

    items = host.items.all
    items.size.must_equal 3
    items.first.client.must_equal @client
  end

  it 'should set parameters on each resulting object' do
    @client.stubs(:query_api)
           .returns([[{id: 1, hostid: 1},
                      {id: 2, hostid: 2},
                      {id: 3, hostid: 3}], nil])
    group = SimpleZabbix::HostGroup.new({id: 'foo'})
    group.client = @client

    hosts = group.hosts.all
    hosts.each do |host|
      items_assoc = host.items
      items_assoc.parent_params[:hostid].must_equal host.id
    end
  end

end