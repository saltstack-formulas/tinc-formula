tinc
=========

Formula to set up tinc and manage keys.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``tinc``
-------

Install tinc and related configuration. 

Example Pillar:

.. code:: yaml

    tinc:
      replaceWithYourNetworkName:
	replaceWithYourServerName:
		RSAPublicKey: |
			-----BEGIN RSA PUBLIC KEY-----
			-----END RSA PUBLIC KEY-----
		RSAPrivateKey: |
			-----BEGIN RSA PRIVATE KEY-----
			-----END RSA PRIVATE KEY-----
		host_config:
			Subnet: "192.168.xxx.xxx/xx"
		tinc_config:
			Name: ifEmptyDefaultTo_replaceWithYourServerName
			ConnectTo: [ "server1", "server2", "server3" ]
		tinc_up: |
			ifconfig $INTERFACE 192.168.xxx.xxx netmask 255.255.255.0
		tinc_down: |
			ifconfig $INTERFACE down
