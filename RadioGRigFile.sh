clear
echo ""
sudo rigctl --version
echo ""
echo "list all USB COM detected :"
ls -la /dev/ttyUSB* | awk -F ' ' '{print $10}'
echo ""
echo "input COM USB that conected         "
read -p "use default COM /dev/ttyUSB0, [N] NO ? " coms
if [ "$coms" = "N" ]; then
    read -p "COM use, ex:/dev/ttyUSB0    : " com
elif [ "$coms" = "n" ]; then
    read -p "COM use, ex:/dev/ttyUSB0    : " com
else
    com="/dev/ttyUSB0"
fi
echo ""
read -p "baudrate, ex:200                  : " modulasi
read -p "id hamlib rig type                : " rig

echo ""
echo "default frequency 146400000........ "

read -p "[enter] default, [N] input manual : " param
if [ "$param" = "N" ]; then
    read -p "frequency use, ex:144100000       : " frek
elif [ "$param" = "n" ]; then
    read -p "frequency use, ex:144100000       : " frek
else
    frek="146400000"
fi
rigctl -m $rig -r $com F $frek M FM 1

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
    bash RadioGRigFile.sh
fi

while true
do
clear
echo ""
echo "callsign from "$dari" to "$ke" category "$kategori_fix", with modulation : "$modulasi
echo ""
echo "drag and drop your .txt file : "; read file
echo $file > file
sed -i "s/[']//g" file
file2=$(cat file)
pesan=$(cat $file2)
waktu=$(date)
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
echo "..........................................." >> radiogram
echo "..........................................." >> radiogram

rigctl -m $rig -r $com T 3
sleep 1
cat radiogram | minimodem --tx $modulasi -a
rigctl -m $rig -r $com T 0

rm radiogram file
done
