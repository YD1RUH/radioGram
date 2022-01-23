clear
echo ""
sudo rigctl --version
echo ""
read -p "baudrate, ex:200            : " modulasi
read -p "id hamlib rig type          : " rig
read -p "frequency use, ex:144100000 : " frek
echo ""
read -p "message from       : " dari
read -p "to                 : " ke
echo ""
echo "message category [1] usual, [2] emergency"
read -p "choose category use : " kategori
if [ "$kategori" = "1" ]; then
    kategori_fix="usual"
elif [ "$kategori" = "2" ]; then
    kategori_fix="emergency"
else
    clear
    echo "."
    sleep 1
    echo "your choice not listed on programm.."
    sleep 1
    echo "."
    sleep 1
    echo "restart program.."
    sleep 2
    bash RadioGR.sh
fi
nomor=0
while true
do
clear
echo "callsign from "$dari" to "$ke" category "$kategori_fix", with modulation : "$modulasi
echo ""
echo "input your message: ";read pesan
waktu=$(date)
nomor=$(($nomor+1))
echo "..........................................." > radiogram
echo "..........................................." >> radiogram
echo "..........................................." >> radiogram
echo "">> radiogram
echo "From           : $dari" >> radiogram
echo "To             : $ke" >> radiogram
echo "Classification : $kategori_fix" >> radiogram
echo "Time           : $waktu" >> radiogram
echo "" >> radiogram
echo "message        : " >> radiogram
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
