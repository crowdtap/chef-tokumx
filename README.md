# Description

Installs/Configures tokumx

# Requirements

## Platform:

* Ubuntu (>= 12.04)

## Cookbooks:

* apt

# Attributes

* `node['tokumx']['repo']['name']` -  Defaults to `"tokumx"`.
* `node['tokumx']['repo']['uri']` -  Defaults to `"http://s3.amazonaws.com/tokumx-debs"`.
* `node['tokumx']['package']` -  Defaults to `"tokumx"`.

# Recipes

* [tokumx::default](#tokumxdefault)
* [tokumx::hugepagesok](#tokumxhugepagesok) - Installs TokuMX with workarounds to allow running with transparent hugepages (primarily for hosted CI environments).
* [tokumx::package](#tokumxpackage) - Installs Tokutek on Ubuntu using the apt repositories provided by Tokutek.

## tokumx::default

Installs tokumx; currently only on ubuntu by including 'package' recipe

## tokumx::hugepagesok

Installs TokuMX with workarounds to allow running with transparent hugepages
(primarily for hosted CI environments).

TokuMX requires transparent huge pages to be disabled at the kernel level.
Indeed, it attempts to force the issue during boot. In some cases, however
you may be running in a container where you don't control the kernel - this
happens to us (Crowdtap) in CircleCI. Tokutek begrudgingly pointed out the
existence of a variable to prevent the failure assertion in the mongod itself.
This recipe takes other various workaround to make it actually install
and start in spite of this setting.


## tokumx::package

Installs Tokutek on Ubuntu using the apt repositories provided by Tokutek.

# License and Maintainer

Maintainer:: Crowdtap, Inc. (<cookbooks@crowdtap.com>)

License:: All rights reserved
