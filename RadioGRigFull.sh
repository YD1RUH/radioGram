clear
echo ""
rigctl --version
echo ""

echo "read config.json:"
cat config.json
dari=$(cat config.json | jq -r '.callsign')
com=$(cat config.json | jq -r '.cat_port')
rig=$(cat config.json | jq -r '.radio_id')
frek=$(cat config.json | jq -r '.tx_freq')
echo ""
echo "===================================="
echo "callsign  : $dari"
echo "port      : $com"
echo "rig model : $rig"
echo "TX freq.  : $frek"
echo "===================================="
echo ""
read -p "is it ok [enter] ? if you want manual input type [N] or [n] ..." param

if [ "$param" = "N" ]; then
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
    read -p "message from        : " dari
elif [ "$param" = "n" ]; then
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
    read -p "message from        : " dari
fi

rigctl -m $rig -r $com F $frek M FM 1

read -p "send messages to    : " ke
read -p "baudrate, ex:200    : " modulasi
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
echo ""
echo "callsign from "$dari" to "$ke" category "$kategori_fix", with modulation : "$modulasi
echo "1. for send weater information, type 'weather'"
echo "2. for send .txt file, type 'file' then drag n drop your .txt to terminal"
echo ""
echo "input your message: ";read pesan

if [ "$pesan" = "weather" ]; then
    clear
    read -p "masukkan lokasi : " loc
    echo "..........................................." > radioWeater
    echo "..........................................." >> radioWeater
    echo "..........................................." >> radioWeater
    echo "..........................................." >> radioWeater
    curl -s wttr.in/$loc?1 >> radioWeater
    sed '23,$ d' radioWeater > radioWeater_fix
    echo "..........................................." >> radioWeater_fix
    echo "..........................................." >> radioWeater_fix
    echo "..........................................." >> radioWeater_fix
    rigctl -m $rig -r $com T 3
    sleep 1
    cat radioWeater_fix | minimodem --tx $modulasi -a
    rigctl -m $rig -r $com T 0
    rm radioWeater radioWeater_fix
elif [ "$pesan" = "file" ]; then
    clear
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
else
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
    echo "..........................................." >> radiogram
    echo "..........................................." >> radiogram
    rigctl -m $rig -r $com T 3
    sleep 1
    cat radiogram | minimodem --tx $modulasi -a
    rigctl -m $rig -r $com T 0
    rm radiogram
fi

done
