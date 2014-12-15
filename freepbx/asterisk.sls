asterisk-get:
  archive:
    - extracted
    - name: /usr/src/
    - source: http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-{{ salt['pillar.get']('asterisk:version', '12.7.2') }}.tar.gz
    - source_hash: {{ salt['pillar.get']('asterisk:hash', 'sha1=3bd6c62bcc646cdb28669bd200b69134eb08b240') }}
    - archive_format: tar
    - tar_options: xz
    - if_missing: /usr/src/asterisk-{{ salt['pillar.get']('asterisk:version', '12.7.2') }}/

asterisk-install:
  cmd.run:
    - name: |
        ./configure
        {% if 'format_mp3' in salt['pillar.get']('asterisk:modules', []) %}
        contrib/scripts/get_mp3_source.sh
        {% endif %}
        make menuselect.makeopts
        {% for module in salt['pillar.get']('asterisk:modules', []) %}
        menuselect/menuselect --enable {{ module }} menuselect.makeopts
        {% endfor %}
        make
        make install
        make config
        ldconfig
        make progdocs
    - cwd: /usr/src/asterisk-{{ salt['pillar.get']('asterisk:version', '12.7.2') }}/
    - shell: /bin/bash
    - timeout: 300
    - require:
      - archive: asterisk-get