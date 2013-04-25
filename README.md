SimpleZabbix
============

*A very simple Zabbix API client in ruby.*

I'm building this out mostly as a query tool against the Zabbix API.
A lot of it is modeled after [Arel](https://github.com/rails/arel) syntax.

-----------------------------------------------------------------------------

Interact with the  API directly via `query_api` on the client object.
Alternatively, interact with the "friendlier" convenience methods.

```ruby
require 'simple_zabbix'
client = SimpleZabbix.client
client.url = 'https://zabbix.domain.com'
client.authenticate('username', 'ultra-secure-password')

# Get all hosts
client.query_api('host.get', output: 'extend') # raw call
client.hosts

# Get specific host
client.query_api('host.get', output: 'extend', filter: { name: 'www' })
client.hosts.find('www')

# Get items for a host
client.query_api('item.get', output: 'extend', filter: { host: 'ftp'})
client.hosts.find('ftp').items

# Search/filtering/limiting
client.hosts.find('foo').items.where(units: 'B')
client.hosts.find('bar').items.where(units: 'B', delta: '0')
client.hosts.find('baz').items.where(units: 'B').where(delta: '0') # supports chaining
client.hosts.find('bat').items.limit(10)

```

Search
-----
Available using the `where` method on the associations.

  - The `where` calls are chainable allowing the query to be built as you go.
  - The query is not performed until the result is acted upon or `all` is called.

-----------------------------------------------------------------------------

__TODO__: Well... the rest of it.

