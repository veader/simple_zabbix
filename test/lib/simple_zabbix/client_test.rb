require_relative '../../test_helper'

describe SimpleZabbix::Client do
  it 'should not be authenticated by default' do
    client = SimpleZabbix::Client.new
    client.authenticated?.must_equal false
  end

  it 'should not authenticate with incorrect credentials' do
    client = SimpleZabbix::Client.new
    client.url = 'http://domain.com'
    client.last_error.must_be_nil

    client.expects(:make_http_request)
          .returns('{"jsonrpc":"2.0","error":{"code":-32602,"message":"Invalid params.","data":"Login name or password is incorrect."},"id":5667}')

    client.authenticate('wrong', 'creds').must_equal false
    client.last_error.wont_be_nil
  end

  it 'should authenticate with correct credentials' do
    client = SimpleZabbix::Client.new
    client.url = 'http://domain.com'
    client.last_error.must_be_nil

    client.expects(:make_http_request)
          .returns('{"jsonrpc":"2.0","result":"78de4226c72cb6f204c69a0c14a2eef4","id":59992}')

    client.authenticate('right', 'creds').must_equal true
    client.last_error.must_be_nil
  end

  it 'should add http to url without one' do
    client = SimpleZabbix::Client.new
    url = 'domain.com'
    client.url = url
    client.url.wont_equal url
    client.url.must_match %r{http://}
  end

  it 'should not touch http on url with one' do
    client = SimpleZabbix::Client.new
    url = 'http://domain.com'
    client.url = url
    client.url.wont_equal url
    client.url.must_match url
  end

  it 'should add path to url without one' do
    client = SimpleZabbix::Client.new
    url = 'http://domain.com'
    client.url = url
    client.url.wont_equal url
    client.url.must_match url
    client.url.must_match %r{jsonrpc.php}
  end

  it 'should not add path to url with one' do
    client = SimpleZabbix::Client.new
    url = 'http://domain.com/api_jsonrpc.php'
    client.url = url
    client.url.must_equal url
    client.url.must_match %r{jsonrpc.php}
  end

  it 'should gather API version even without authentication' do
    client = SimpleZabbix::Client.new
    client.url = 'http://domain.com'
    client.authenticated?.must_equal false

    client.expects(:make_http_request)
          .returns('{"jsonrpc":"2.0","result":"1.4","id":6717}')
    client.api_version.must_equal '1.4'
  end
end
