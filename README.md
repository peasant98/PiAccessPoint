# PiAccessPoint

Create your own stand alone access point with the Raspberry Pi!

**Requirements**:
- Raspberry Pi
- A way to run the script on the Pi

**Instructions**:
- If you haven't yet setup the Raspberry Pi as a stand alone access point, run the init script:
- `chmod <permissions you want> init.sh`
- Choose your own Passkey and SSID for the standalone network.
- `./init.sh <SSID> <Passkey>`
- Upon completion, the Pi should reboot, and the next time, you should see the name of the new network!

- The other script, `network.sh`, is for switching from the stand alone network to the original settings, and vice versa.

- Running `./network.sh 1` will bring you to the stand alone network.
- Running `./network.sh 0` will essentially reverse the steps from above. 


**Note**:

If my Pi automatically connects to my home's Wi-Fi, running `./network.sh 1` will disconnect it and create the access point, whereas `./network.sh 0` will reverse the steps and bring me right back to connecting with the home Wi-Fi.
