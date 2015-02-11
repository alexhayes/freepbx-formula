freepbx-get:
  git.latest:
    - name: http://git.freepbx.org/scm/freepbx/framework.git
    - target: /usr/src/freepbx
    - rev: {{ salt['pillar.get']('freepbx:version', 'release/12.0.21') }}
#    - require:
#      - sls: freepbx.cleanup

restart-asterisk:
  cmd.run:
    - name: |
        service asterisk restart
        sleep 10
        /usr/sbin/asterisk -rx "core restart now"
        sleep 3
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - timeout: 120
    - require:
      - git: freepbx-get

install-amp:
  cmd.run:
    - name: |
        ./install_amp --installdb --scripted --dbhost={{ salt['pillar.get']('mysql:user:asterisk:host', 'localhost') }} --username={{ salt['pillar.get']('mysql:user:asterisk:user', 'asterisk') }} --password={{ salt['pillar.get']('mysql:user:asterisk:password', 's3cr3t') }} --force-overwrite --install-moh 2>&1
        ./install_amp --update-links
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - timeout: 1800
    - require:
      - cmd: restart-asterisk
      
amportal-chown-after-install:
  cmd.run:
    - name: |
        amportal chown
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - cmd: install-amp

amportal-download-manager:
  cmd.run:
    - name: |
        amportal a ma download manager
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - cmd: amportal-chown-after-install
      
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
    # Yep, we run this twice for good luck...
    - name: |
        amportal a ma installall 2>&1
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
      
amportal-refresh-signatures:
  cmd.run:
    - name: |
        amportal a ma refreshsignatures
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - cmd: amportal-reload
      
amportal-chown:
  cmd.run:
    - name: |
        amportal chown
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - cmd: amportal-refresh-signatures

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
  cmd.script:
    # For some very frustrating reason amportal-restart exits 1 even if it's successful
    - name: salt://freepbx/scripts/amportal-restart.sh
    - cwd: /usr/src/freepbx
    - shell: /bin/bash
    - require:
      - file: /var/lib/asterisk/mohmp3
