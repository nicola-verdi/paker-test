#!/bin/bash
## move files to the correct position, adjust permission and restart daemons

chmod +x /tmp/*.sh
sudo chown root:root /tmp/*.sh /tmp/*.service

sudo mv -t /usr/local/bin /tmp/*.sh	
sudo mv -t /etc/systemd/system  /tmp/*.service 

sudo systemctl daemon-reload
sudo systemctl enable initial-extend-fs.service	
sudo systemctl enable initial-network-config.service	
sudo systemctl enable telegraf-config.service
