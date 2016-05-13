[![Gem Version](https://img.shields.io/gem/v/knife-chef-inventory.svg?style=flat-square)](https://rubygems.org/gems/knife-chef-inventory)
[![Gem Dowloads](https://img.shields.io/gem/dt/knife-chef-inventory.svg?style=flat-square)](https://rubygems.org/gems/knife-chef-inventory)
[![Travis branch](https://img.shields.io/travis/bigbam505/knife-chef-inventory/master.svg?style=flat-square)](https://travis-ci.org/bigbam505/knife-chef-inventory)
[![Code Climate](https://img.shields.io/codeclimate/github/bigbam505/knife-chef-inventory.svg?style=flat-square)](https://codeclimate.com/github/bigbam505/knife-chef-inventory)
[![Gemnasium](https://img.shields.io/gemnasium/bigbam505/knife-chef-inventory.svg?style=flat-square)](https://gemnasium.com/github.com/bigbam505/knife-chef-inventory)

Knife Chef Inventory
=======================

The main purpose of this knife plugin is to find objects that are not being used
on the chef server so they can be cleaned up


## Installation
Installation is easy just as any other knife plugin, just install with the gem
command

```bash
# You can install to your chefdk environment
chef gem install knife-chef-inventory

# Or to a regular ruby environment
gem install knife-chef-inventory
```

## Usage

Everything suppose to be organized in an easy to navigate way.  Everything is
nested under `knife inventory` and the commands should be self documenting.
Below are some simple examples

```bash
knife inventory

** INVENTORY COMMANDS **
knife inventory chef_client
knife inventory cookbook
```


### Cookbooks
You can look into a single cookbook below to see what versions are active.  Then
once you see which ones are active you can dig in by specifying a version number
to drill into.

```bash
# Looking into the usage of the apache2 cookbook
knife inventory cookbook apache2
Total Nodes using Cookbook: 3
3.1.0 is used by 1 hosts
3.2.1 is used by 1 hosts
3.2.2 is used by 1 hosts
```

```bash
# Looking into the usage of the apache2 cookbook for version 3.1.0
knife inventory cookbook apache2 3.1.0
Cookbook Versions being used for apache2
server1.domain.com - 12312 Minutes
```

```bash
# We can also do wilcard to look at lets say version 3.2.x
knife inventory cookbook apache2 3.2.x
Cookbook Versions being used for apache2
server2.domain.com - 13 Minutes
server3.domain.com - 13 Minutes
```

```bash
# We can also pass in the "--env-constraints" option to look at any environment constaints that are specified
knife inventory cookbook apache2 --env-constraints
Total Nodes using Cookbook: 3
3.1.0 is used by 1 hosts
3.2.1 is used by 1 hosts
3.2.2 is used by 1 hosts
Environment Version Constraints for apache2
staging - ~> 3.2
production - = 3.2.1
```

### Chef Clients
You can also index chef client versions to see what is being used over all of
your infrastructure

```bash
# You can get a list of different client versions
knife inventory chef_client
11.6.8 is used by 1 hosts
11.7.0 is used by 1 hosts
12.6.0 is used by 20 hosts
12.7.2 is used by 14 hosts
12.8.1 is used by 9 hosts
12.9.38 is used by 2 hosts
12.9.41 is used by 11 hosts
```

```bash
# You can then drill into each node with wildcards to see what hosts are using each version
knife inventory chef_client 11.*
Client Versions being used
server2.domain.com - 13 Minutes
server3.domain.com - 13 Minutes
```


### TODO
There are still several things that need to be included, for example
environments, clients, users, nodes, and I guess roles.
