#!/bin/ash

NETWORK="default"
CURRENT_CONFIG_FILE="/etc/config/wireless"

LOCAL="/root/nyu_network_conf/"
SD="/mnt/sda1/"

NYU_LOCAL=$LOCAL"config_files/wireless.nyu"
SANDBOX_LOCAL=$LOCAL"config_files/wireless.itp"

SANDBOX_SD=$SD+"config_files/wireless.itp"
NYU_SD=$SD+"config_files/wireless.nyu"

NYU_USERNAME="usr"
NYU_PASSWORD="psswd"


#check for correct wpad pkg
#NOT TESTED
WPAD_MINI=$(opkg list-installed | grep -c wpad-mini)
WPAD=$(opkg list-installed | grep -c wpad\ -\ 20131120-1) 


echo $WPAD_MINI
echo $WPAD
if [ $WPAD_MINI -eq 1 ]; then
  	echo "wpad-mini installed. Deleting and installing wpad..."
  	opkg remove wpad-mini
  	PKG_PATH=$SDwpad_20131120-1_ar71xx.ipk
  	opkg install $PKG_PATH

elif [ $WPAD -eq 1 ]; then 
  	echo "wpad already installed"
fi

#check for directory
#NOT TESTED
if [ ! -d "$LOCAL" ]; then
  	mkdir $LOCAL

  	if [ -d "$SD" ]; then
  		echo $LOCAL" not found."
  		#getting rid of hidden mac folders from sd before copying files over
  		rm -rf $SD".Spotlight-V100/"
  		rm -rf $SD".Trashes/"
  		rm -rf $SD".fseventsd/"
  		echo "Copying files from microSD"		
  		cp -R * $SD $LOCAL

  	else
  		echo $SD+" not found."
  		return 0
	fi
	echo $LOCAL " found."
fi


#run script
if [ $# -eq 1 ] && [ $1 == "itpsandbox" ] ;then
		NETWORK="itpsandbox"
		echo "Connecting to ITP sandbox"
elif [ $# -eq 3 ] && [ $1 == "nyu" ] ;then
		NETWORK="nyu"
		NYU_USERNAME=$2
		NYU_PASSWORD=$3
		echo "connecting to nyu with username :"  $2
else 
	echo "Incorrect params"
	echo "If connecting to sandbox type: "
	echo "./configure itpsandbox "
	echo " "
	echo "If connecting to nyu type:"
	echo "./configure nyu <username> <password> "
fi


if [ $NETWORK == "itpsandbox" ]; then
	
		echo "Removing old config file ..."
		rm $CURRENT_CONFIG_FILE
		echo "Copying sandbox file.."
		cp $SANDBOX_LOCAL $CURRENT_CONFIG_FILE
		echo "restarting wifi interface"
		wifi
		iwconfig
		
elif [ $NETWORK == "nyu" ];then
        echo "Removing old config file ..."
        rm $CURRENT_CONFIG_FILE            
        echo "Copying nyu file.."

        sed  -e "s/usr/$NYU_USERNAME/g" -e "s/psswrd/$NYU_PASSWORD/g" $NYU_LOCAL > wireless
        mv wireless $CURRENT_CONFIG_FILE
        echo "restarting wifi interface"
        wifi    
        iwconfig
fi                             

