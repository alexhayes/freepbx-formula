jansson-get:
  git.latest:
    - name: https://github.com/akheron/jansson.git
    - target: /usr/src/jansson
    - rev: {{ salt['pillar.get']('jansson:version', 'master') }}

jansson-install:
  cmd.run:
    - name: |
        autoreconf -i
        ./configure
        make
        make install
    - cwd: /usr/src/jansson
    - shell: /bin/bash
    - timeout: 300
    - require:
      - git: jansson-get