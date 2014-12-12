{% from "apache/map.jinja" import apache with context %}
{% for d in ['/var/run/asterisk', '/etc/asterisk', '/var/lib/asterisk', '/var/log/asterisk', '/var/spool/asterisk', '/usr/lib/asterisk'] %}
{{ d }}:
  file:
    - directory
    - user: {{ salt['pillar.get']('asterisk:user', 'asterisk') }}
    - group: {{ salt['pillar.get']('asterisk:group', 'asterisk') }}
    - mode: 0755
    - recurse:
      - user
      - group
{% endfor %}

/var/www/html:
  file:
    - absent

/etc/php5/apache2/php.ini:
  file.replace:
    - pattern: |
        upload_max_filesize = .*
    - repl: |
        upload_max_filesize = 120M

apache-user:
  file.replace:
    - name: /etc/apache2/envvars
    - pattern: |
        export APACHE_RUN_USER=.+
    - repl: |
        export APACHE_RUN_USER={{ salt['pillar.get']('asterisk:user', 'asterisk') }}
      
apache-group:
  file.replace:
    - name: /etc/apache2/envvars
    - pattern: |
        export APACHE_RUN_GROUP=.+
    - repl: |
        export APACHE_RUN_GROUP={{ salt['pillar.get']('asterisk:group', 'asterisk') }}

apache-restart:
  module.run:
    - name: service.restart
    - m_name: {{ apache.service }}
