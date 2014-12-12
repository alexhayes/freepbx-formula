===============
freepbx-formula
===============

Install and configure a FreePBX server.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Requirements
============

The following formulas are required to use this formula;

- `users <https://github.com/saltstack-formulas/users-formula>`_
- `git <https://github.com/saltstack-formulas/git-formula>`_
- `mysql <https://github.com/saltstack-formulas/mysql-formula>`_
- `postgres <https://github.com/saltstack-formulas/postgres-formula>`_
- `php <https://github.com/saltstack-formulas/php-formula>`_
- `apache <https://github.com/saltstack-formulas/apache-formula>`_

Available states
================

.. contents::
    :local:

``freepbx``
----------

Installs the Apache package and starts the service.

