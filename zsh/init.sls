#!jinja|yaml

{% from "zsh/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('zsh:lookup')) %}

include: {{ datamap.sls_include|default([]) }}
extend: {{ datamap.sls_extend|default({}) }}

zsh:
  pkg:
    - installed
    - pkgs: {{ datamap.pkgs }}

{% if datamap.ohmyzsh.setup|default(False) %}
ohmyzsh:
  git:
    - latest
    - name: {{ datamap.ohmyzsh.src }}
    - rev: master
    - target: /usr/local/share/oh-my-zsh
{% endif %}

{% for u in salt['pillar.get']('zsh:config:manage:users', []) %}
  {% set homedir = salt['user.info'](u).home|default('/home/' ~ u) %}

ohmyzsh_custom_{{ u }}:
  file:
    - recurse
    - name: {{ homedir }}/.ohmyzsh
    - source: salt://zsh/files/custom
    - user: {{ u }}

zshrc_{{ u }}:
  file:
    - managed
    - name: {{ homedir }}/.zshrc
    - source: salt://zsh/files/.zshrc
    - user: {{ u }}
    - group: {{ u }}
    - mode: 644
    - template: jinja
{% endfor %}
