kochiku-puppet
==============

Puppet manifest to automatically deploy a Kochiku server.

Caveats
-------
This is a work-in-progress, currently only good for spinning up a Vagrant image
for development purposes.  It's my intention to refine this into a production-
worthy Puppet module that users will install directly off the Forge.

Prerequisites
-------------
You need to have the latest versions of [VirtualBox][vbox] and [Vagrant][vagrant]
installed on your workstation.  Instructions on getting started with Vagrant can
be readily found on the site.  The documentation is quite good.

Usage
-----
1. Clone a copy of this repository.

        git clone git@github.com:djbkd/kochiku-puppet.git
        cd ./kochiku-puppet/
        git submodule update --init --recursive

1. Spin up your vagrant nodes.

        vagrant up

1. Build Kochiku!  The vagrant images use /vagrant as the shared folder on your
   host workstation.  It will also clone a copy of the kochiku repository along
   with the version of Ruby required by Kochiku, managed by RVM.  To launch your
   new Kochiku server, simply change to the checked-out kochiku repository
   within the kochiku node and run the rake commands per the
   [kochiku README][kochiku]!

1. Start hacking!

License
-------
Apache Version 2, see LICENSE file for more details.

[vbox]: https://www.virtualbox.org/
[vagrant]: http://www.vagrantup.com/
[kochiku]: https://github.com/square/kochiku
