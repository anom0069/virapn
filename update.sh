#!/bin/bash

# Written By: anom

if [ "$(id -u)" -ne 0 ]; then
    echo -e "\033[33mPlease run as root\033[0m"
    exit
fi

wait

echo " "

PS3=" Please Select Action: "
options=("Update bot" "Update panel" "Backup" "Delete" "Donate" "Exit")
select opt in "${options[@]}"
do
	case $opt in
		"Update bot")
			echo " "
			read -p "Are you sure you want to update?[y/n]: " answer
			echo " "
			if [ "$answer" != "${answer#[Yy]}" ]; then
			mv /var/www/html/anomxui-timebot/baseInfo.php /root/
			mv /var/www/html/anomxui-timebot/userInfo.json /root/
			sudo apt-get install -y git
			sudo apt-get install -y wget
			sudo apt-get install -y unzip
			sudo apt install curl -y
			echo -e "\n\e[92mUpdating ...\033[0m\n"
			sleep 4
			rm -r /var/www/html/anomxui-timebot/
			echo -e "\n\e[92mWait a few seconds ...\033[0m\n"
			sleep 3
			git clone https://github.com/anomdev/anomxui-timebot.git /var/www/html/anomxui-timebot
			sudo chown -R www-data:www-data /var/www/html/anomxui-timebot/
			sudo chmod -R 755 /var/www/html/anomxui-timebot/
			sleep 3
			mv /root/baseInfo.php /var/www/html/anomxui-timebot/
			mv /root/userInfo.json /var/www/html/anomxui-timebot/
# 			if [ $? -ne 0 ]; then
# 			echo -e "\n\e[41mError: The update failed!\033[0m\n"
# 			exit 1
# 			else
			
			sleep 1
			
			bot_token=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$botToken' | cut -d"'" -f2)
			bot_token2=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$botToken' | cut -d'"' -f2)
			bot_url=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$botUrl' | cut -d'"' -d"'" -f2)
			
			filepath="/var/www/html/anomxui-timebot/baseInfo.php"
			
			bot_value=$(cat $filepath | grep '$admin =' | sed 's/.*= //' | sed 's/;//')
			
			MESSAGE="🤖 anom robot has been successfully updated!"
			
			curl -s -X POST "https://api.telegram.org/bot${bot_token}/sendMessage" -d chat_id="${bot_value}" -d text="$MESSAGE"
			
			curl -s -X POST "https://api.telegram.org/bot${bot_token2}/sendMessage" -d chat_id="${bot_value}" -d text="$MESSAGE"
			
			sleep 1
        
			url="${bot_url}install/install.php?updateBot"
			curl $url
			
			sleep 1
			
			sudo rm -r /var/www/html/anomxui-timebot/webpanel
			sudo rm -r /var/www/html/anomxui-timebot/install
			rm /var/www/html/anomxui-timebot/createDB.php
			
			clear
			
			echo -e "\n\e[92mThe script was successfully updated!\033[0m\n"
			
# 			fi

			else
			  echo -e "\e[41mCancel the update.\033[0m\n"
			fi

			break ;;
		
		"Update panel")
			echo " "
			read -p "Are you sure you want to update?[y/n]: " answer
			echo " "
			if [ "$answer" != "${answer#[Yy]}" ]; then
			
			sudo apt-get install -y php-ssh2
			sudo apt-get install -y libssh2-1-dev libssh2-1

			destination_dir=$(find /var/www/html -type d -name "*wizpanel*" | head -n 1)

			if [ -z "$destination_dir" ]; then
			    RANDOM_NUMBER=$(( RANDOM % 10000000 + 1000000 ))
			    mkdir "/var/www/html/wizpanel${RANDOM_NUMBER}"
			    echo "Directory created: wizpanel${RANDOM_NUMBER}"
			    echo "Folder created successfully!"
			    sudo mkdir /root/updateanom
   			    sleep 1
			    touch /root/updateanom/wizup.txt
			    sudo chmod -R 777 /root/updateanom/wizup.txt
			    sleep 1
			    ASAS="$"
			    echo "${ASAS}path = '${RANDOM_NUMBER}';" >> /root/updateanom/wizup.txt
			else
			    echo "Folder already exists."
			fi
			
			

			 destination_dir=$(find /var/www/html -type d -name "*wizpanel*" | head -n 1)

			 cd /var/www/html/
			 wget -O anompanel.zip https://github.com/anomdev/anomxui-timebot/releases/download/7.5.3/anompanel.zip

			 file_to_transfer="/var/www/html/anompanel.zip"
			 destination_dir=$(find /var/www/html -type d -name "*wizpanel*" | head -n 1)

			 if [ -z "$destination_dir" ]; then
			   echo "Error: Could not find directory containing 'wiz' in '/var/www/html'"
			   exit 1
			 fi

			 mv "$file_to_transfer" "$destination_dir/" && yes | unzip "$destination_dir/anompanel.zip" -d "$destination_dir/" && rm "$destination_dir/anompanel.zip" && sudo chmod -R 755 "$destination_dir/" && sudo chown -R www-data:www-data "$destination_dir/" 


			wait


			echo -e "\n\e[92mUpdating ...\033[0m\n"
			
			bot_token=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$botToken' | cut -d"'" -f2)
			bot_token2=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$botToken' | cut -d'"' -f2)
			
			filepath="/var/www/html/anomxui-timebot/baseInfo.php"
			
			bot_value=$(cat $filepath | grep '$admin =' | sed 's/.*= //' | sed 's/;//')
			
			MESSAGE="🕹 anom panel has been successfully updated!"

			curl -s -X POST "https://api.telegram.org/bot${bot_token}/sendMessage" -d chat_id="${bot_value}" -d text="$MESSAGE"
			curl -s -X POST "https://api.telegram.org/bot${bot_token2}/sendMessage" -d chat_id="${bot_value}" -d text="$MESSAGE"
			
			sleep 1
			
			if [ $? -ne 0 ]; then
			echo -e "\n\e[41mError: The update failed!\033[0m\n"
			exit 1
			else
			
# 			echo -e '\e[31m'

# 			find /var/www/html -type d -name "*wizpanel*" -print | sed "s|/var/www/html|& \n\n\nPanel: https://yourdomain.com|g"
			
# 			echo -e '\033[0m'




# 			echo -e ' '
# 			echo -e ' '

# 			read -p "Enter the domain: " domainname
			
# 			if [ "$domainname" = "" ]; then

# 			exit

# 			else
			
			
# 			DOMAIN_NAME="$domainname"
			
# 			PATHS=$(cat /root/updateanom/wizup.txt | grep '$path' | cut -d"'" -f2)
# 			PATHS=$(cat /root/confanom/dbrootanom.txt | grep '$path' | cut -d"'" -f2)
# 			(crontab -l | grep -v "backupnutif.php") | crontab -
			
# 			(crontab -l ; echo "* * * * * curl https://${DOMAIN_NAME}/wizpanel${PATHS}/backupnutif.php >/dev/null 2>&1") | sort - | uniq - | crontab -
# 			(crontab -l ; echo "* * * * * curl https://${DOMAIN_NAME}/wizpanel${PATHS}/backupnutif.php >/dev/null 2>&1") | sort - | uniq - | crontab -
# 			fi
			
			clear

			echo -e ' '

			
# 			PATHS2=$(cat /root/confanom/dbrootanom.txt | grep '$path' | cut -d"'" -f2)
# 			PATHS3=$(cat /root/updateanom/wizup.txt | grep '$path' | cut -d"'" -f2)
# 			if [ -d "/root/confanom/dbrootanom.txt" ]; then
#                             echo -e "\e[92mPanel: \e[31mhttps://${DOMAIN_NAME}/wizpanel${PATHS}\033[0m\n"
# 			    (crontab -l ; echo "* * * * * curl https://${DOMAIN_NAME}/wizpanel${PATHS}/backupnutif.php >/dev/null 2>&1") | sort - | uniq - | crontab -
# 			else
# 			    echo -e "\e[92mPanel: \e[31mhttps://${DOMAIN_NAME}/wizpanel${PATHS3}\033[0m\n"
# 			    (crontab -l ; echo "* * * * * curl https://${DOMAIN_NAME}/wizpanel${PATHS3}/backupnutif.php >/dev/null 2>&1") | sort - | uniq - | crontab -
# 			fi
			
			
		
			echo -e "\e[92mThe script was successfully updated!\033[0m\n"
			
			fi




			else
			  echo -e "\e[41mCancel the update.\033[0m\n"
			fi

			break ;;
		"Backup")
			echo " "
			
			wait

			BOT_TOKEN=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$botToken' | cut -d'"' -d"'" -f2)
			ROOT_USER=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$dbUserName' | cut -d"'" -f2)
			ROOT_PASSWORD=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$dbPassword' | cut -d"'" -f2)
			BOT_URL=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$botUrl' | cut -d'"' -f2)
			BOT_URL2=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$botUrl' | cut -d"'" -f2)

			filepath="/var/www/html/anomxui-timebot/baseInfo.php"
			ADMIN_ID=$(cat $filepath | grep '$admin =' | sed 's/.*= //' | sed 's/;//')
			
			echo "SELECT 1" | mysql -u$ROOT_USER -p$ROOT_PASSWORD 2>/dev/null

			sleep 1
			ASAS="$"
			if [ $? -eq 0 ]; then

			touch /var/www/html/anomxui-timebot/backup-anom.php

			chmod -R 777 /var/www/html/anomxui-timebot/backup-anom.php

			echo " " >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "<?php" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "include 'settings/jdf.php';" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "function sendDocument(${ASAS}username, ${ASAS}document_path, ${ASAS}caption = null, ${ASAS}parse_mode = 'HTML') {" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "${ASAS}url = 'https://api.telegram.org/bot${BOT_TOKEN}/sendDocument';" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "${ASAS}anom = ['chat_id' => ${ASAS}username,'document' => new CURLFile(${ASAS}document_path),'caption' => ${ASAS}caption,'parse_mode' => ${ASAS}parse_mode];" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "${ASAS}ch = curl_init();" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "curl_setopt_array(${ASAS}ch, [CURLOPT_URL => ${ASAS}url,CURLOPT_RETURNTRANSFER => true,CURLOPT_POSTFIELDS => ${ASAS}anom]);" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "${ASAS}result = curl_exec(${ASAS}ch);curl_close(${ASAS}ch);return ${ASAS}result;}" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "date_default_timezone_set('Asia/Tehran');${ASAS}date = jdate('Y-m-d | H:i:s');" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "sendDocument('${ADMIN_ID}', '/var/www/html/anomxui-timebot/anom.sql', '❤️ db '.${ASAS}date);" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo "?>" >> /var/www/html/anomxui-timebot/backup-anom.php
			echo " " >> /var/www/html/anomxui-timebot/backup-anom.php

			DB_NAME=anom
			backup_path="/var/www/html/anomxui-timebot/"
			backup_filesql="$backup_path$DB_NAME.sql"
			mysqldump --user=$ROOT_USER --password=$ROOT_PASSWORD --host=localhost anom > $backup_filesql
			
			clear
			
			sleep 0.5
			
			url="${BOT_URL}backup-anom.php"
			curl $url
			
			url2="${BOT_URL2}backup-anom.php"
			curl $url2
			
			clear
			
			sleep 1
						
			rm /var/www/html/anomxui-timebot/backup-anom.php
			rm /var/www/html/anomxui-timebot/anom.sql
			
			
			echo -e "\e[92m The backup settings have been successfully completed.\033[0m\n"
			
			else
			    echo "ERROR: MySQL password is incorrect"
			fi

			break ;;
		"Delete")
			echo " "
			
			wait
			
			passs=$(cat /root/confanom/dbrootanom.txt | grep '$pass' | cut -d"'" -f2)
   			userrr=$(cat /root/confanom/dbrootanom.txt | grep '$user' | cut -d"'" -f2)
			pathsss=$(cat /root/confanom/dbrootanom.txt | grep '$path' | cut -d"'" -f2)
			pathsss=$(cat /root/confanom/dbrootanom.txt | grep '$path' | cut -d"'" -f2)
			passsword=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$dbPassword' | cut -d"'" -f2)
   			userrrname=$(cat /var/www/html/anomxui-timebot/baseInfo.php | grep '$dbUserName' | cut -d"'" -f2)
			
			mysql -u $userrr -p$passs -e "DROP DATABASE anom;" -e "DROP USER '$userrrname'@'localhost';" -e "DROP USER '$userrrname'@'%';"

			sudo rm -r /var/www/html/wizpanel${pathsss}
			sudo rm -r /var/www/html/anomxui-timebot
			
			clear
			
			sleep 1
			
			(crontab -l | grep -v "messageanom.php") | crontab -
			(crontab -l | grep -v "rewardReport.php") | crontab -
			(crontab -l | grep -v "warnusers.php") | crontab -
			(crontab -l | grep -v "backupnutif.php") | crontab -
			
			echo -e "\n\e[92m Removed successfully.\033[0m\n"
			break ;;
		"Donate")
			echo " "
			echo -e "\n\e[91mBanksepah ( toran ): \e[36m5892101222351344\033[0m\n\e[91mTron(trx): \e[36mTY8j7of18gbMtneB8bbL7SZk5gcntQEemG\n\e[91mBitcoin: \e[36mbc1qcnkjnqvs7kyxvlfrns8t4ely7x85dhvz5gqge4\033[0m\n"
			exit 0
			break ;;
		"Exit")
			echo " "
			break
			;;
			*) echo "Invalid option!"
	esac
done
