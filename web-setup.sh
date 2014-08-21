#!/bin/bash

if [ ! -f /etc/network/if-up.d/custom-network-config ]; then

  apt-get update

  /usr/bin/apt-get -y install apache2 curl elinks sysstat

  cat >> /etc/security/limits.conf <<EOF
  *       -       nofile          20480
EOF

  cat > /var/www/index.html <<EOD
<html><head><title>${HOSTNAME}</title></head><body><h1>${HOSTNAME}</h1>
<p>This is the default web page for ${HOSTNAME}.</p>
</body></html>
EOD
    
  a2enmod status info

  # Log the X-Forwarded-For
  perl -pi -e  's/^LogFormat "\%h (.* combined)$/LogFormat "%h %{X-Forwarded-For}i $1/' /etc/apache2/apache2.conf

  /usr/sbin/service apache2 restart

  perl -pi -e 's|ENABLED="false"|ENABLED="true"|' /etc/default/sysstat

  perl -pi -e 's|\Q5-55/10 * * * * root command -v debian-sa1\E|* * * * * root command -v debian-sa1|' /etc/cron.d/sysstat

#  net.ipv4.tcp_syncookies = 0
#  net.ipv4.tcp_max_syn_backlog = 12000

fi

