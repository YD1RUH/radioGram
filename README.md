# radioGram
pemanfaatan minimodem untuk pengiriman radiogram pada frekuensi radio

install minimodem pada komputer/laptop : 
- ```sudo apt-get install minimodem```

kemudian buat virtual_sink audio pada pulse audio : 
- buka terminal kemudian ketik ```pacmd load-module module-null-sink sink_name=Virtual_Sink sink_properties=device.description=Virtual_Sink```
- ```sudo nano /etc/pulse/default.pa```
- pada akhir file tambahkan ```load-module module-null-sink sink_name=Virtual_Sink sink_properties=device.description=Virtual_Sink```

untuk encode text menjadi audio termodulasi jalankan :
- ```sudo chmod + RadioGR.sh```
- ```./RadioGR.sh```

untuk mendecode buka terminal baru kemudian jalankan :
- ```minimodem --rx mode_yang_digunakan -q```
