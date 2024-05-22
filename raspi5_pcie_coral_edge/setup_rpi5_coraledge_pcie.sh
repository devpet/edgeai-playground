#!/bin/bash
sudo apt update
sudo apt -y full-upgrade
sudo apt install rpi-update
sudo rpi-update
sudo reboot

sudo -i
sudo apt -y install git bc bison flex libssl-dev make libncurses5-dev
sudo wget https://raw.githubusercontent.com/jgartrel/rpi-source/master/rpi-source -O /usr/bin/rpi-source
sudo chmod +x /usr/bin/rpi-source
rpi-source --tag-update
rpi-source --default-config

exit

echo "dtparam=pciex1" | sudo tee -a /boot/firmware/config.txt
echo "kernel=kernel8.img" | sudo tee -a /boot/firmware/config.txt
echo "dtoverlay=pineboards-hat-ai" | sudo tee -a /boot/firmware/config.txt

sudo apt update
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

sudo apt-get -y update

sudo apt-get -y install cmake libedgetpu1-std devscripts debhelper dkms dh-dkms

git clone https://github.com/google/gasket-driver.git
cd gasket-driver
sudo debuild -us -uc -tc -b
cd ..
sudo dpkg -i gasket-dkms_1.0-18_all.deb

sudo sh -c "echo 'SUBSYSTEM==\"apex\", MODE=\"0660\", GROUP=\"apex\"' >> /etc/udev/rules.d/65-apex.rules"
sudo groupadd apex
sudo adduser $USER apex
sudo reboot