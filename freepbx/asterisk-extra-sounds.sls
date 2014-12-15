asterisk-extra-sounds-get:
  archive:
    - extracted
    - name: /var/lib/asterisk/sounds
    - source: http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-wav-current.tar.gz
    - source_hash: http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-wav-current.tar.gz.sha1
    - archive_format: tar
    - tar_options: xz
    - if_missing: /var/lib/asterisk/sounds
    - require:
      - sls: freepbx.asterisk

asterisk-extra-sounds-g722-get:
  archive:
    - extracted
    - name: /var/lib/asterisk/sounds
    - source: http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-g722-current.tar.gz
    - source_hash: http://downloads.asterisk.org/pub/telephony/sounds/asterisk-extra-sounds-en-g722-current.tar.gz.sha1
    - archive_format: tar
    - tar_options: xz
    - if_missing: /var/lib/asterisk/sounds
    - require:
      - sls: freepbx.asterisk
