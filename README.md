# PiAccessPoint

Create your own stand alone access point with the Raspberry Pi!

**Requirements**:
- Raspberry Pi with either Rasbpian Stretch or Ubuntu Mate (tested on)
- A way to run the script on the Pi (example: already ssh'ed in)

**Instructions**:
- `git clone https://github.com/peasant98/PiAccessPoint.git`
- Based on your OS:
- **Raspbian**:
    - `cd Raspbian`
- **Ubuntu Mate**:
    - `cd Ubuntu_Mate`
- If you haven't yet setup the Raspberry Pi as a stand alone access point, run the init script:
- `chmod <permissions you want> init.sh`
- Choose your own Passkey and SSID for the standalone network.
- `./init.sh <SSID> <Passkey>`
- Upon completion, the Pi should reboot, and the next time, you should see the name of the new network!

- The other script, `network.sh`, is for switching from the stand alone network to the original settings, and vice versa.

- Running `./network.sh 1` will bring you to the stand alone network.
- Running `./network.sh 0` will essentially reverse the steps from above. 


**Note**:

If your Pi automatically connects to your home's Wi-Fi, running `./network.sh 1` will disconnect it and create the access point, whereas `./network.sh 0` will reverse the steps and bring you right back to connecting with the home Wi-Fi.
