/usr/share/nginx:
  file:
    - directory

{% for filename in ('default', 'example_ssl') %}
/etc/nginx/conf.d/{{ filename }}.conf:
  file.absent:
    - require:
      {% if pillar.get('nginx', {}).get('install_from_source') %}
      - cmd: nginx
      {% else %}
      - pkg: nginx
      {% endif %}
    - require_in:
      - service: nginx
{% endfor %}

/etc/nginx:
  file.directory:
    - user: root
    - group: root

/etc/nginx/nginx.conf:
  file:
    - managed
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/templates/config.jinja
    - require:
      - file: /etc/nginx

{% for dir in ('sites-enabled', 'sites-available') %}
/etc/nginx/{{ dir }}:
  file.directory:
    - user: root
    - group: root
{% endfor -%}
