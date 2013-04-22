SimpleZabbix
============

*A very simple Zabbix API client in ruby.*

I'm building this out mostly as a query tool against the Zabbix API.

```ruby
require 'simple_zabbix'
client = SimpleZabbix.client
client.url = 'https://zabbix.domain.com'
client.authenticate('username', 'ultra-secure-password')

# Get all Hosts
client.query_api('host.get', output: 'extend') # raw call
client.hosts

# Get specific Host
client.query_api('host.get', output: 'extend', filter: { name: 'www' })
client.hosts.find('www')

# Get items for a Host
client.query_api('item.get', output: 'extend', filter: { host: 'ftp'})
client.hosts.find('ftp').items

```

__TODO__: Well... the rest of it.

