iksemel-get:
  archive:
    - extracted
    - name: /usr/src/
    - source: https://iksemel.googlecode.com/files/iksemel-{{ salt['pillar.get']('iksemel:version', '1.4') }}.tar.gz
    - source_hash: {{ salt['pillar.get']('iksemel:hash', 'sha1=722910b99ce794fd3f6f0e5f33fa804732cf46db') }}
    - archive_format: tar
    - tar_options: zx
    - if_missing: /usr/src/iksemel-{{ salt['pillar.get']('iksemel:version', '1.4') }}/
    - require:
      - sls: freepbx.pear

iksemel-install:
  cmd.run:
    - name: |
        ./configure
        make
        make check
        make install
    - cwd: /usr/src/iksemel-{{ salt['pillar.get']('iksemel:version', '1.4') }}
    - shell: /bin/bash
    - timeout: 300
    - require:
      - archive: iksemel-get