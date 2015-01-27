pjproject-get:
  git.latest:
    - name: https://github.com/asterisk/pjproject.git
    - target: /usr/src/pjproject
    - rev: {{ salt['pillar.get']('pjproject:version', 'master') }}
#    - require:
#      - sls: freepbx.libpri

pjproject-install:
  cmd.run:
    - name: |
        ./configure --enable-shared --disable-sound --disable-resample --disable-video --disable-opencore-amr
        make dep
        make
        make install
    - cwd: /usr/src/pjproject
    - shell: /bin/bash
    - timeout: 300
    - require:
      - git: pjproject-get