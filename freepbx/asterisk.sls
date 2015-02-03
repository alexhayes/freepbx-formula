asterisk-dir:
  file.directory:
    - name: /usr/src/asterisk-{{ salt['pillar.get']('asterisk:version', '12-current') }}
#    - require:
#      - sls: freepbx.jansson

asterisk-get:
  archive:
    - extracted
    - name: /usr/src/asterisk-{{ salt['pillar.get']('asterisk:version', '12-current') }}/
    - source: http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-{{ salt['pillar.get']('asterisk:version', '12-current') }}.tar.gz
    - source_hash: http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-12-current.sha1
    - archive_format: tar
    - tar_options: xz --strip-components=1
    - if_missing: /usr/src/asterisk-{{ salt['pillar.get']('asterisk:version', '12-current') }}/Makefile
    - require:
      - file: asterisk-dir

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
    - cwd: /usr/src/asterisk-{{ salt['pillar.get']('asterisk:version', '12-current') }}/
    - shell: /bin/bash
    - timeout: 1800
    - require:
      - archive: asterisk-get