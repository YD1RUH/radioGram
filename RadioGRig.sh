clear
sudo rigctl --version
echo ""
read -p "masukkan modulasi     : " modulasi
read -p "id hamlib rig type    : " rig
read -p "masukkan frekuensi    : " frek
read -p "pesan dari            : " dari
read -p "untuk                 : " ke
echo ""
echo "kategori berita [1] biasa, [2] darurat"
read -p "pilih kategori berita : " kategori
if [ "$kategori" = "1" ]; then
    kategori_fix="biasa"
elif [ "$kategori" = "2" ]; then
    kategori_fix="darurat"
else
    clear
    echo "."
    sleep 1
    echo "pilihan anda tidak ada dalam program.."
    sleep 1
    echo "."
    sleep 1
    echo "mengulang program.."
    sleep 2
    bash RadioGR.sh
fi
nomor=0
while true
do
clear
echo "callsign from "$dari" to "$ke" kategori "$kategori_fix", with modulation : "$modulasi
echo ""
echo "masukkan isi pesan : ";read pesan
waktu=$(date)
nomor=$(($nomor+1))
echo "..........................................." > radiogram
echo "..........................................." >> radiogram
echo "..........................................." >> radiogram
echo "">> radiogram
echo "Dari         : $dari" >> radiogram
echo "Kepada       : $ke" >> radiogram
echo "Klasifikasi  : $kategori_fix" >> radiogram
echo "Waktu        : $waktu" >> radiogram
echo "" >> radiogram
echo "Isi Berita   : " >> radiogram
echo "$pesan" >> radiogram
echo "" >> radiogram
echo "..........................................." >> radiogram
echo "" >> radiogram

sudo rigctl -m $rig -r /dev/ttyUSB0 F $frek M PKTFM 1
sudo rigctl -m $rig -r /dev/ttyUSB0 T 1
cat radiogram | minimodem --tx $modulasi -a
sudo rigctl -m $rig -r /dev/ttyUSB0 T 0

rm radiogram
done
