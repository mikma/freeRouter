cd ~
mkdir a
wget -O a/rtr.zip http://src.nop.hu/rtr.zip
unzip a/rtr.zip -d  a/
cd ~/a/misc/p4lang
./c.sh
mv router.json ~/
mv router.txt ~/
cp r.sh ~/
cp f.sh ~/
cp forwarder.py ~/
cp -R p4runtime_lib ~/
cd ~
rm -Rf a/
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get remove apparmor
sudo apt-get autoremove
sudo apt-get clean
sudo dd if=/dev/zero of=/zzz.bin bs=1M
sudo rm /zzz.bin
