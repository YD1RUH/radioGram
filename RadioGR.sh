clear
export LC_NUMERIC="en_US.UTF-8"
echo ""
rigctl --version
echo ""

echo "read config.json:"
cat config.json
dari=$(cat config.json | jq -r '.callsign')
echo ""
echo "===================================="
echo "callsign  : $dari"
echo "===================================="
echo ""
read -p "is it ok [enter] ? if you want manual input type [N] or [n] ..." param
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
    bash RadioGRvox.sh
fi
xterm -fn 6x10 -geometry 180x19+0-0 -fa 'Monospace' -fs 11 -e "minimodem --rx $modulasi -q" &

nomor=0
while true
do
clear
echo ""
echo "callsign from "$dari" to "$ke" category "$kategori_fix", with modulation : "$modulasi
echo "1. for send weater information, type '1'"
echo "2. get weather info all provincies at Indonesia, type '2' "
echo "3. for send .txt file, type '3' then drag n drop your .txt to terminal"
echo ""
echo "input your message: ";read pesan

if [ "$pesan" = "1" ]; then
    clear
    read -p "masukkan lokasi : " loc
    echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" > radioWeater
    echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" >> radioWeater
    echo "..........................................." >> radioWeater
    echo "..........................................." >> radioWeater
    curl -s wttr.in/$loc?1 >> radioWeater
    sed '23,$ d' radioWeater > radioWeater_fix
    echo "..........................................." >> radioWeater_fix
    echo "..........................................." >> radioWeater_fix
    echo "..........................................." >> radioWeater_fix
    start=$(date +%s.%N)
    cat radioWeater_fix | minimodem --tx $modulasi -a
    duration=$(echo "$(date +%s.%N) - $start" | bc)
    execution_time=`printf "%.2f seconds" $duration`
    echo "transmit berlangsung selama : $execution_time"
    rm radioWeater radioWeater_fix
    sleep 2
elif [ "$pesan" = "2" ]; then
    clear
    echo "getting information..."
    echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" > radioWeater
    echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" >> radioWeater
    echo "..........................................." >> radioWeater
    echo "..........................................." >> radioWeater
    curl -s 'wttr.in/{Aceh,Medan,Padang,Pekanbaru,Tanjungpinang,Jambi,Palembang,Pangkal Pinang,Bengkulu,Bandar Lampung,Jakarta,Serang,Bandung,Semarang,Yogyakarta,Surabaya,Denpasar,Mataram,Kupang,Pontianak,Palangkaraya,Banjarmasin,Samarinda,Tanjung Selor,Manado,Gorontalo,Palu,Mamuju,Makassar,Kendari,Ambon,Sofifi,Manokwari,Jayapura}?format=3' >> radioWeater
    echo "..........................................." >> radioWeater
    echo "..........................................." >> radioWeater
    echo "..........................................." >> radioWeater
    start=$(date +%s.%N)
    cat radioWeater | minimodem --tx $modulasi -a
    duration=$(echo "$(date +%s.%N) - $start" | bc)
    execution_time=`printf "%.2f seconds" $duration`
    echo "transmit berlangsung selama : $execution_time"
    rm radioWeater
    sleep 2
elif [ "$pesan" = "3" ]; then
    clear
    echo "drag and drop your .txt file : "; read file
    echo $file > file
    sed -i "s/[']//g" file
    file2=$(cat file)
    pesan=$(cat $file2)
    waktu=$(date)
    echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" > radiogram
    echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" >> radiogram
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
    start=$(date +%s.%N)
    cat radiogram | minimodem --tx $modulasi -a
    duration=$(echo "$(date +%s.%N) - $start" | bc)
    execution_time=`printf "%.2f seconds" $duration`
    echo "transmit berlangsung selama : $execution_time"
    rm radiogram file
    sleep 2
else
    waktu=$(date)
    nomor=$(($nomor+1))
    echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" > radiogram
    echo "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA" >> radiogram
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
    start=$(date +%s.%N)
    cat radiogram | minimodem --tx $modulasi -a
    duration=$(echo "$(date +%s.%N) - $start" | bc)
    execution_time=`printf "%.2f seconds" $duration`
    echo "transmit berlangsung selama : $execution_time"
    rm radiogram
    sleep 2
fi

done
