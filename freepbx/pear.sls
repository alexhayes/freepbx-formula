install-pear:
  cmd.run:
    - name: |
        pear uninstall db
        pear install db-{{ salt['pillar.get']('pear-db:version', '1.7.14') }}
    - cwd: /tmp
    - shell: /bin/bash
    - timeout: 300
    - unless: test `pear info db | fgrep 'Release Version' | grep -o -E '[0-9\.]+'` = {{ salt['pillar.get']('pear-db:version', '1.7.14') }}
    - require:
      - sls: freepbx.requirements