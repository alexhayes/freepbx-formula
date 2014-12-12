dahdi-get:
  archive:
    - extracted
    - name: /usr/src/
    - source: http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-{{ salt['pillar.get']('dahdi:version', '2.10.0.1+2.10.0.1') }}.tar.gz
    - source_hash: {{ salt['pillar.get']('dahdi:hash', 'sha1=a7fc17c20243a8b84824cca25ebad25f46b10031') }}
    - archive_format: tar
    - tar_options: xz
    - if_missing: /usr/src/dahdi-linux-complete-{{ salt['pillar.get']('dahdi:version', '2.10.0.1+2.10.0.1') }}/

dahdi-install:
  cmd.run:
    - name: |
        make all
        make install
        make config
    - cwd: /usr/src/dahdi-linux-complete-{{ salt['pillar.get']('dahdi:version', '2.10.0.1+2.10.0.1') }}/
    - shell: /bin/bash
    - timeout: 300
    - require:
      - archive: dahdi-get