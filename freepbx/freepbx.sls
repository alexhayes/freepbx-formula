freepbx-get:
  git.latest:
    - name: http://git.freepbx.org/scm/freepbx/framework.git
    - target: /usr/src/freepbx
    - rev: {{ salt['pillar.get']('freepbx:version', 'release/12.0.9') }}
#    - require:
#      - sls: freepbx.cleanup

restart-asterisk:
  cmd.run:
    - name: |
        ./start_asterisk restart
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - git: freepbx-get

install-amp:
  cmd.run:
    - name: |
        ./install_amp --scripted --installdb --username={{ salt['pillar.get']('mysql:user:asterisk:user', 'asterisk') }} --password={{ salt['pillar.get']('mysql:user:asterisk:password', 's3cr3t') }} --force-overwrite --install-moh
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - timeout: 1800
    - require:
      - cmd: restart-asterisk

amportal-download-manager:
  cmd.run:
    - name: |
        amportal a ma download manager
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - cmd: restart-asterisk
      
amportal-install-manager:
  cmd.run:
    - name: |
        amportal a ma install manager
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - cmd: amportal-download-manager
      
amportal-installall:
  cmd.run:
    - name: |
        amportal a ma installall
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - cmd: amportal-install-manager
      
amportal-reload:
  cmd.run:
    - name: |
        amportal a reload
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - cmd: amportal-installall
      
amportal-chown:
  cmd.run:
    - name: |
        amportal chown
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - cmd: amportal-reload

/var/lib/asterisk/mohmp3:
  file.symlink:
    - target: /var/lib/asterisk/moh
    - force: True
    - require:
      - cmd: amportal-chown

#link-moh:
#  cmd.run:
#    - name: |
#        ln -s /var/lib/asterisk/moh /var/lib/asterisk/mohmp3
#    - cwd: /usr/src/freepbx
#    - shell: /bin/bash
      
amportal-restart:
  cmd.run:
    - name: |
        amportal restart
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - file: /var/lib/asterisk/mohmp3
