require_relative '../../test_helper'

describe SimpleZabbix::Association do
  it 'should use default search params when doing basic find' do
    name = 'foo'
    assoc = SimpleZabbix::Association.new(nil)
    assoc.stubs(:default_search_param).returns(:name)
    assoc.expects(:where).with(:name => name).returns([])

    assoc.find(name)
  end

  it 'should map any array/enumerable method to results of where' do
    assoc = SimpleZabbix::Association.new(nil)
    assoc.expects(:where).returns([])
    assoc.each { |o| o }

    assoc.expects(:where).returns([])
    assoc.collect { |o| o }

    # etc...
  end

  it 'should map all to results of where' do
    assoc = SimpleZabbix::Association.new(nil)
    where_results = [:a, :b, :c]
    assoc.expects(:where).returns(where_results)
    assoc.all.must_equal(where_results)
  end

end