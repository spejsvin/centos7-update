#!/bin/bash

# made by spacevin


crvena='\033[0;31m'
zelena='\033[0;32m'
zuta='\033[1;33m'
bez_boje='\033[0m'


if [[ $EUID -ne 0 ]]; then
   echo -e "${crvena}ova skripta mora da se pokrene kao root${bez_boje}"
   exit 1
fi


ispis_status() {
    echo -e "${zuta}[*] $1${bez_boje}"
}


ispis_uspeh() {
    echo -e "${zelena}[+] $1${bez_boje}"
}


ispis_greska() {
    echo -e "${crvena}[-] $1${bez_boje}"
}


ispis_status "pravim rezervnu kopiju originalnih repozitorijum fajlova..."
mkdir -p /etc/yum.repos.d/backup
cp -f /etc/yum.repos.d/*.repo /etc/yum.repos.d/backup/
ispis_uspeh "repozitorijum fajlovi su kopirani u /etc/yum.repos.d/backup/"


ispis_status "uklanjam postojece repozitorijum fajlove..."
rm -f /etc/yum.repos.d/*.repo
ispis_uspeh "postojeci repozitorijum fajlovi su uklonjeni"


ispis_status "kreiram novi centos-base.repo fajl..."
cat > /etc/yum.repos.d/centos-base.repo << 'eol'
[base]
name=centos-$releasever - base
baseurl=http://vault.centos.org/7.9.2009/os/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/rpm-gpg-key-centos-7

[updates]
name=centos-$releasever - updates
baseurl=http://vault.centos.org/7.9.2009/updates/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/rpm-gpg-key-centos-7

[extras]
name=centos-$releasever - extras
baseurl=http://vault.centos.org/7.9.2009/extras/$basearch/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/rpm-gpg-key-centos-7

[centosplus]
name=centos-$releasever - plus
baseurl=http://vault.centos.org/7.9.2009/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/rpm-gpg-key-centos-7
eol
ispis_uspeh "novi centos-base.repo fajl je kreiran"


ispis_status "kreiram novi epel repo fajl..."
cat > /etc/yum.repos.d/epel.repo << 'eol'
[epel]
name=extra packages for enterprise linux 7 - $basearch
baseurl=https://archives.fedoraproject.org/pub/archive/epel/7/$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/rpm-gpg-key-epel-7
eol
ispis_uspeh "novi epel repo fajl je kreiran"


ispis_status "cistim yum kes..."
yum clean all
if [ $? -eq 0 ]; then
    ispis_uspeh "yum kes je uspesno ociscen"
else
    ispis_greska "neuspelo ciscenje yum kesa"
fi


ispis_status "azuriram ca-sertifikate..."
yum -y install ca-certificates
if [ $? -eq 0 ]; then
    ispis_uspeh "ca sertifikati su uspesno azurirani"
else
    ispis_greska "neuspelo azuriranje ca sertifikata"
fi


ispis_status "kreiram novi yum kes..."
yum makecache
if [ $? -eq 0 ]; then
    ispis_uspeh "yum kes je uspesno kreiran"
else
    ispis_greska "neuspelo kreiranje yum kesa"
fi


ispis_status "azuriram sistemske pakete..."
yum -y update
if [ $? -eq 0 ]; then
    ispis_uspeh "sistem je uspesno azuriran"
else
    ispis_greska "neuspelo azuriranje sistema"
fi

ispis_uspeh "popravka repozitorijuma i azuriranje sistema je zavrseno!"
ispis_status "ako i dalje imate problema, proverite vasu internet konekciju i dns podesavanja."

ispis_status "proveravam dns podesavanja..."
if ! grep -q "nameserver 8.8.8.8" /etc/resolv.conf; then
    ispis_status "dodajem google dns servere..."
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    echo "nameserver 8.8.4.4" >> /etc/resolv.conf
    ispis_uspeh "google dns serveri su dodati"
fi


echo -e "${zuta}da li zelite da restartujete sistem sada? (d/n)${bez_boje}"
read -r odgovor
if [[ $odgovor =~ ^[dD]$ ]]; then
    ispis_status "restartujem sistem..."
    reboot
fi

