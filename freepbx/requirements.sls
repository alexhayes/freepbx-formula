include:
  - freepbx.packages
  - git
  {% if 'cdr_mysql' in salt['pillar.get']('asterisk:modules', []) or 'app_mysql' in salt['pillar.get']('asterisk:modules', []) or 'res_config_mysql' in salt['pillar.get']('asterisk:modules', []) %}
  - mysql
  - mysql.dev
  {% endif %}
  {% if 'cdr_postgres' in salt['pillar.get']('asterisk:modules', []) %}
  - postgres
  {% endif %}
  - apache
  - users
  - php
  - php.cli
  - php.curl
  - php.mysql
  - php.pear
  - php.gd