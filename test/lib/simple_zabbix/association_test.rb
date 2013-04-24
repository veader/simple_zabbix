require_relative '../../test_helper'

describe SimpleZabbix::Association do
  it 'should use default search params when doing basic find' do
    name = 'foo'
    assoc = SimpleZabbix::Association.new(nil)
    assoc.stubs(:default_search_param).returns(:name)
    assoc.stubs(:search_key_mappings).returns(name: 'name')
    assoc.expects(:execute_query).returns([])

    assoc.find(name)
    assoc.built_up_params[:filter].must_equal('name' => name)
  end

  it 'should map any array/enumerable method to results of where' do
    assoc = SimpleZabbix::Association.new(nil)
    assoc.expects(:execute_query).returns([])
    assoc.each { |o| o }

    assoc.expects(:execute_query).returns([])
    assoc.collect { |o| o }

    # etc...
  end

  it 'should map all to results of where' do
    assoc = SimpleZabbix::Association.new(nil)
    where_results = [:a, :b, :c]
    assoc.expects(:execute_query).returns(where_results)
    assoc.all.must_equal(where_results)
  end

  it 'should chain where calls to combine filters' do
    assoc = SimpleZabbix::Association.new(nil)
    assoc.stubs(:search_key_mappings).returns(name: 'name', host: 'host')
    assoc.where(name: 'foo')
    assoc.where(host: 'bar')
    assoc.built_up_params[:filter]. \
          must_equal('name' => 'foo', 'host' => 'bar')
  end

  it 'should allow limiting of api output' do
    assoc = SimpleZabbix::Association.new(nil)
    assoc.limit(5)
    assoc.built_up_params[:limit].must_equal 5
  end

end