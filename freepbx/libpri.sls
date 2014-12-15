libpri-get:
  archive:
    - extracted
    - name: /usr/src
    - source: http://downloads.asterisk.org/pub/telephony/libpri/libpri-{{ salt['pillar.get']('libpri:version', '1.4.15') }}.tar.gz
    - source_hash: {{ salt['pillar.get']('libpri:hash', 'sha1=d1877f9d772eecb4aba2bcb9d03478d88aac163c') }}
    - archive_format: tar
    - tar_options: xz
    - if_missing: /usr/src/libpri-{{ salt['pillar.get']('libpri:version', '1.4.15') }}/

libpri-install:
  cmd.run:
    - name: |
        make
        make install
    - cwd: /usr/src/libpri-{{ salt['pillar.get']('libpri:version', '1.4.15') }}/
    - shell: /bin/bash
    - timeout: 300
    - require:
      - archive: libpri-get