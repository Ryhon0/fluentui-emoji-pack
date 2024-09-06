# Fluent Emoji Pack
This repository is used to generate the Fluent emoji pack for [hchat](https://github.com/Ryhon0/hchat).  
The resulting images follow the same naming scheme as in [emoji-data](https://github.com/iamcal/emoji-data)  

To run the script, install rdmd (included with LDC2 or DMD) and Inkscape and add them to your PATH
```
cd scripts
./pack.d
```
The script will start rendering the emojis into the `pack` directory in repo root. Inside it there will be 3 directories containing emojis for the 3 different styles offered by Fluent (3d, color, flat).  

Skin variations are currently not handled.  