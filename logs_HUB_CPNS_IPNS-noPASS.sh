#!/bin/bash
OS=$(lsb_release -a 2>/dev/null)
if [[ $OS == *"ALT"* ]]; then
	echo -e "\e[32mЭто ALT Linux\e[0m"
	#if dpkg --list | grep "sshpass"; then
	if rpm -q sshpass &>/dev/null; then
		echo "..... sshpass установлен"
	else
		echo -e "\e[32mДля удобной работы с парлем будет установлен 'sshpass'\e[0m"
		apt-get install sshpass 
	fi
else
	echo -e "\e[32mЭто Debian\e[0m"
	if dpkg --list | grep "sshpass"; then
		echo "..... sshpass установлен"
	else
		echo -e "\e[32mДля удобной работы с парлем будет установлен 'sshpass'\e[0m"
		apt-get install sshpass 
	fi
fi



echo -e "\e[32mВведите пароль от удаленной машины\e[0m"
while read password
do
    if [ $password != "qweasdzxc" ]; then
        echo -e "\e[32mПароль невреный. Введите еще раз\e[0m"
    else [ $password != "qweasdzxc" ];
        break
    fi
done

echo -e "\e[32mChoose a variant\e[0m"
#echo -e "\e[32mlogs will be placed in /opt\e[0m"
#echo -e "\e[32mЧтобы не водить пароль в дальнейшем. Введи пароль сейчас 1 раз\e[0m"
select choise in "HUB" "IPNS" "CPNS" "START OR STOP HUB"; do
    case $choise in
        "HUB")
            echo -e "\e[32mЛог будет помещен в архив HubCore.zip на удаленной машине\e[0m"
            sshpass -p "qweasdzxc" ssh root@10.10.88.43 "zip -j /opt/HubCore.zip /root/.local/share/InfoTeCS/hub_server/HubCore.log"
            echo -e "\e[32mHubCore.zip будет скачан в /opt на ваше устройство\e[0m"
            sshpass -p "qweasdzxc" scp root@10.10.88.43:/opt/HubCore.zip /opt
            echo -e "\e[32mФайл скачана, проверьте папку 'opt'\e[0m"
			unzip /opt/HubCore.zip -d /opt/
            echo -e "\e[32mДля выхода из программы нажмите Ctrl+C или введите номер для сбора слудющих логов\e[0m"
        ;;
        "IPNS")
            echo -e "\e[32mЛог будет помещен в архив infotecs-pns.zip на удаленной машине\e[0m"
            sshpass -p "qweasdzxc" ssh root@10.10.88.42 "zip -j /opt/infotecs-pns.zip /opt/infotecs-pns/logs/infotecs-pns.log"
            echo -e "\e[32mЛог infotecs-pns.zip будет скачан в /opt на ваше устройство\e[0m"
            sshpass -p "qweasdzxc" scp root@10.10.88.42:/opt/infotecs-pns.zip /opt
            echo -e "\e[32mФайл скачана, проверьте папку 'opt'\e[0m"
			unzip /opt/HubCore.zip -d /opt/
            echo -e "\e[32mДля выхода из программы нажмите Ctrl+C или введите номер для сбора слудющих логов\e[0m"
        ;;
        "CPNS")
            echo -e "\e[32mЛог будет помещен в архив customer-pns.log.zip на удаленной машине\e[0m"
            sshpass -p "qweasdzxc" ssh root@10.10.88.44 "zip -j /opt/customer-pns.zip /opt/customer-pns/logs/customer-pns.log"
            echo -e "\e[32mЛог customer-pns.zip будет скачан в /opt на ваше устройство\e[0m"
            sshpass -p "qweasdzxc" scp root@10.10.88.44:/opt/customer-pns.zip /opt
            echo -e "\e[32mФайл скачана, проверьте папку 'opt'\e[0m"
			unzip /opt/HubCore.zip -d /opt/
            echo -e "\e[32mДля выхода из программы нажмите Ctrl+C или введите номер для сбора слудющих логов\e[0m"
        ;;
        #"FILE_SERVER")
        #    scp root@10.10.88.49:/root/.local/share/InfoTeCS/hub_server/HubCore.log /opt
        #;;
        "START OR STOP HUB")
            echo -e "\e[32mЗапуск/Остановка HUB(если остановлен,будет запущен иначе наоборот)\e[0m"
            #if ssh root@10.10.88.43 "service hubserver status | grep Active"; then
            sshpass -p "qweasdzxc" ssh root@10.10.88.43 "if service hubserver status | grep -qw 'running'; then echo 'Служба HUB запущена. Останавливаю...'; service hubserver stop; else echo 'Служба HUB остановлена. Запускаю...'; service hubserver start; fi"
        ;;

    esac
done
