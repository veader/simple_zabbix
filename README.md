SimpleZabbix
============

*A very simple Zabbix API client in ruby.*

I'm building this out mostly as a query tool against the Zabbix API.

```ruby
require 'simple_zabbix'
client = SimpleZabbix.client
client.url = 'https://zabbix.domain.com'
client.authenticate('username', 'ultra-secure-password')
client.query_api('host.get', output: 'extend')
```

__TODO__: Well... the rest of it.

