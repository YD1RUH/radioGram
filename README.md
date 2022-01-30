# radioGram
the use of minimodem for sending radiograms on radio frequencies

## developed & tested by
1. YD1RUH
2. YD0NXX
3. YD0AVJ
4. YD0AVI
5. YG3FEO
6. YD9CKH

## Dependencies
1. minimodem (sudo apt-get install minimodem)
2. hamlib (sudo apt-get install hamradio-rigcontrol, or install manually https://github.com/Hamlib/Hamlib)
3. jq (sudo apt-get install jq)

## without transciever or transciever with vox mode
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
1. install minimodem on your computer/laptop : 
   + ```sudo apt-get install minimodem```

2. open pavucontrol and select usb sound interface detected as a default device :

3. run program to encode text into modulated audio and trasmited via RF :
   + ```sudo chmod +X RadioGRig.sh```
   + ```./RadioGRig.sh```

4. for decode the modulated audio, open terminal and run this command :
   + ```minimodem --rx type_mode_that_you're_using -q```

## training decode minimodem
I've just add 3 example sound .wav. there is with baudrate 300, 1000, and 1200. If you're trying to decode this .wav just try this command on your terminal:
```minimodem --read baud_rate_that_you_want -f example-baud_rate_tested.wav```

## build and combined with
1. linux
2. bash (shell script)
3. hamlib
4. minimodem
5. json
6. wttr.in
7. pulse audio
