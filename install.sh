#!/bin/bash

# https://x.com/facontidavide/status/1848989454943363360/photo/1
echo setting up cyclone DDS config

echo "" | tee -a ~/.bashrc
echo export ROS_DOMAIN_ID=113 | tee -a ~/.bashrc
echo export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp | tee -a ~/.bashrc
echo export ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST | tee -a ~/.bashrc
echo export 'CYCLONEDDS_URI=${CYCLONEDDS_URI:-"<CycloneDDS><Domain><General><Interfaces><NetworkInterface name=\"lo\"/></Interfaces><AllowMulticast>true</AllowMulticast></General><Discovery><ParticipantIndex>none</ParticipantIndex></Discovery></Domain></CycloneDDS><Gen><Allow>spdp</Allow></Gen>"}' | tee -a ~/.bashrc


# https://autowarefoundation.github.io/autoware-documentation/main/installation/additional-settings-for-developers/network-configuration/enable-multicast-for-lo/
echo setting up multicast on loopback
echo "[Unit]
Description=Enable Multicast on Loopback

[Service]
Type=oneshot
ExecStart=/usr/sbin/ip link set lo multicast on

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/multicast-lo.service

sudo systemctl daemon-reload
sudo systemctl enable multicast-lo.service
sudo systemctl start multicast-lo.service
sudo systemctl status multicast-lo.service


echo setting up rmem_max
sudo sysctl -w net.core.rmem_max=2147483647 | sudo tee -a /etc/sysctl.conf