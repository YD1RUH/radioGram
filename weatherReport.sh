clear
echo ""
rigctl --version
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
read -p "baudrate, ex:200                     : " modulasi
read -p "id hamlib rig type                   : " rig
echo ""
echo "default frequency 146400000........... "

read -p "[enter] default, [N] input manual    : " param
if [ "$param" = "N" ]; then
    read -p "frequency use, ex:144100000          : " frek
elif [ "$param" = "n" ]; then
    read -p "frequency use, ex:144100000          : " frek
else
    frek="146400000"
fi
rigctl -m $rig -r $com F $frek M FM 1
echo ""
echo "every on second"
read -p "duration update weather infromation  : " detik
read -p "input your location for weather info : " loc
count=4
while true
do
if [[ $count -ne 0 ]]; then
	echo "" > radioWeater
	echo "" >> radioWeater
        echo "" >> radioWeater
        echo "" >> radioWeater
	curl -s wttr.in/$loc?0 >> radioWeater
	echo "$count turn before full information" >> radioWeater
	echo "" >> radioWeater
        echo "" >> radioWeater
        echo "" >> radioWeater
	rigctl -m $rig -r $com T 1
	sleep 1
	cat radioWeater | minimodem --tx $modulasi -a
	rigctl -m $rig -r $com T 0
	rm radioWeater
	sleep $detik
	count=$(($count-1))
else
	echo "" > radioWeater
        echo "" >> radioWeater
        echo "" >> radioWeater
        echo "" >> radioWeater
	curl -s wttr.in/$loc?1 >> radioWeater
	sed '23,$ d' radioWeater > radioWeater_fix
	echo "" >> radioWeater_fix
        echo "" >> radioWeater_fix
        echo "" >> radioWeater_fix
        rigctl -m $rig -r $com T 1
        sleep 1
	cat radioWeater_fix | minimodem --tx $modulasi -a
        rigctl -m $rig -r $com T 0
        rm radioWeater
	rm radioWeater_fix
        sleep $detik
	count=4
fi
done
