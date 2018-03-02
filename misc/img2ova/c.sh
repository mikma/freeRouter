#!/bin/sh
qemu-img create ../../binImg/rtr.dsk 1G
parted ../../binImg/rtr.dsk mklabel msdos
parted ../../binImg/rtr.dsk mkpart primary ext4 1 1020
parted ../../binImg/rtr.dsk set 1 boot on
mkfs.ext4 -q -b 1024 -E offset=1048576 -F ../../binImg/rtr.dsk 950000
mount -o loop,offset=1048576 ../../binImg/rtr.dsk /mnt
mkdir /mnt/rtr
cp ../../binImg/rtr.krn /mnt/rtr.krn
gunzip -d -c -k ../../binImg/rtr.ird > /mnt/rtr.tmp
echo `cd /mnt/;cpio --quiet -H newc -i </mnt/rtr.tmp`
rm /mnt/rtr.tmp
echo `cd /mnt/;csplit -s init /^###rootfs###$/`
mv /mnt/xx00 /mnt/init
echo mount -t ext4 /dev/sda1 /mnt >> /mnt/init
echo exec switch_root /mnt /init2 >> /mnt/init
echo "#!/bin/sh" > /mnt/init2
echo sh /init.sys >> /mnt/init2
cat /mnt/xx01 >> /mnt/init2
chmod +x /mnt/init*
rm /mnt/xx0*
echo `cd /mnt/;find init*>filist`
echo `cd /mnt/;find dev/>>filist`
echo `cd /mnt/;find sys/>>filist`
echo `cd /mnt/;find proc/>>filist`
echo `cd /mnt/;find mnt/>>filist`
echo `cd /mnt/;find run/>>filist`
echo `cd /mnt/;find lib/>>filist`
echo `cd /mnt/;find bin/>>filist`
echo `cd /mnt/;find sbin/>>filist`
echo `cd /mnt/;find usr/>>filist`
echo `cd /mnt/;cpio --quiet -H newc -O cpio -o <filist`
gzip /mnt/cpio
mv /mnt/cpio.gz /mnt/rtr.ird
cp ../image/boot.cfg /mnt/syslinux.cfg
dd if=/dev/zero of=/mnt/zzz bs=1M
rm /mnt/zzz
extlinux -i /mnt
umount /mnt
dd bs=440 count=1 conv=notrunc if=/usr/lib/syslinux/mbr/mbr.bin of=../../binImg/rtr.dsk
qemu-img convert -O qcow2 ../../binImg/rtr.dsk ../../binImg/rtr.qcow2
qemu-img convert -O vmdk -o subformat=streamOptimized ../../binImg/rtr.dsk ../../binImg/rtr.vmdk
hashFile()
{
sum=`sha1sum $1 | awk '{ print $1 }'`
echo SHA1\($2\)= $sum >> ../../binImg/rtr.mf
}
echo -n "" > ../../binImg/rtr.mf
hashFile ../../binImg/rtr.qcow2 rtr.qcow2
hashFile ../../binImg/rtr.vmdk rtr.vmdk
hashFile package.ovf package.ovf
hashFile package.ver package.ver
hashFile package.yaml package.yaml
tar cvf ../../binImg/rtr.ova package.ovf package.ver package.yaml
echo `cd ../../binImg/;tar rvf rtr.ova rtr.qcow2`
echo `cd ../../binImg/;tar rvf rtr.ova rtr.vmdk`
echo `cd ../../binImg/;tar rvf rtr.ova rtr.mf`
chmod 666 ../../binImg/*
