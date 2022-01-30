# radioGram
the use of minimodem for sending radiograms on radio frequencies

## developed & tested by
1. YD1RUH
2. YD0NXX
3. YD0AVI
4. YG3FEO
5. YD9CKH

## Dependencies
1. minimodem
2. hamlib

## without transciever
1. install minimodem on your computer/laptop : 
   + ```sudo apt-get install minimodem```

2. after taht create a virtual_sink audio using pulse audio : 
   + open terminal than type ```pacmd load-module module-null-sink sink_name=Virtual_Sink sink_properties=device.description=Virtual_Sink```
   + ```sudo nano /etc/pulse/default.pa```
   + at the end of file add this line ```load-module module-null-sink sink_name=Virtual_Sink sink_properties=device.description=Virtual_Sink```

3. for encode the text into modulated audio run this command :
   + ```sudo chmod +X RadioGR.sh```
   + ```./RadioGR.sh```

4. for decode the modulated audion open terminal and run this command : :
   + ```minimodem --rx type_mode_that_you're_using -q```

## with transciever (tested icom IC-7100)
1. install minimodem pada komputer/laptop : 
   + ```sudo apt-get install minimodem```

2. open pavucontrol and select usb sound interface detected as a default device :

3. run program to encode text into modulated audio and trasmited via RF :
   + ```sudo chmod +X RadioGRig.sh```
   + ```./RadioGRig.sh```

4. for decode the modulated audion open terminal and run this command :
   + ```minimodem --rx type_mode_that_you're_using -q```
