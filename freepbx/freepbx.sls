freepbx-get:
  git.latest:
    - name: http://git.freepbx.org/scm/freepbx/framework.git
    - target: /usr/src/freepbx
    - rev: {{ salt['pillar.get']('freepbx:version', 'release/12.0.9') }}
    - require:
      - sls: freepbx.cleanup

freepbx-install:
  cmd.run:
    - name: |
        ./start_asterisk start
        ./install_amp --installdb --username={{ salt['pillar.get']('mysql:user:asterisk:user', 'asteriskuser') }} --password={{ salt['pillar.get']('mysql:user:asterisk:password', 's3cr3t') }}
        amportal a ma download manager
        amportal a ma install manager
        amportal a ma installall
        amportal a reload
        amportal chown
        ln -s /var/lib/asterisk/moh /var/lib/asterisk/mohmp3
        amportal start
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - timeout: 300
    - require:
      - git: freepbx-get