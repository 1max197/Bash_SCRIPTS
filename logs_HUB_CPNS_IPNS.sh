#!/bin/bash
echo -e "\e[32mChoose a variant\e[0m"
echo -e "\e[32mlogs will be placed in /opt\e[0m"
select choise in "HUB" "IPNS" "CPNS" "FILE_SERVER"; do
    case $choise in
        "HUB")
            echo -e "\e[32mВведите пароль, лог будет помещен в архив HubCore.log.tar.gz\e[0m"
            ssh root@10.10.88.43 "zip /opt/HubCore.zip /root/.local/share/InfoTeCS/hub_server/HubCore.log"
            echo -e "\e[32mВведите еще раз пароль, лог HubCore.log.tar.gz будет скачан в /opt\e[0m"
            scp root@10.10.88.43:/opt/HubCore.zip /opt
			echo -e "\e[32mФайл скачан, проверьте папку 'opt'\e[0m"
			unzip /opt/HubCore.zip -d /opt/
            echo -e "\e[32mДля выхода из программы нажмите Ctrl+C или введите номер для сбора слудющих логов\e[0m"
        ;;
       "IPNS")
            echo -e "\e[32mВведите пароль, лог будет помещен в архив infotecs-pns.zip на удаленной машине\e[0m"
            ssh root@10.10.88.42 "zip -j /opt/infotecs-pns.zip /opt/infotecs-pns/logs/infotecs-pns.log"
            echo -e "\e[32mЛог infotecs-pns.zip будет скачан в /opt на ваше устройство\e[0m"
            scp root@10.10.88.42:/opt/infotecs-pns.zip /opt
            echo -e "\e[32mФайл скачан, проверьте папку 'opt'\e[0m"		
			unzip /opt/infotecs-pns.zip -d /opt/
            echo -e "\e[32mДля выхода из программы нажмите Ctrl+C или введите номер для сбора слудющих логов\e[0m"
        ;;
        "CPNS")
            echo -e "\e[32mВведите пароль, лог будет помещен в архив customer-pns.zip на удаленной машине\e[0m"
            ssh root@10.10.88.44 "zip -j /opt/customer-pns.zip /opt/customer-pns/logs/customer-pns.log"
            echo -e "\e[32mЛог customer-pns.zip будет скачан в /opt на ваше устройство\e[0m"
            scp root@10.10.88.44:/opt/customer-pns.zip /opt
            echo -e "\e[32mФайл скачан, проверьте папку 'opt'\e[0m"
			unzip /opt/customer-pns.zip -d /opt/
            echo -e "\e[32mДля выхода из программы нажмите Ctrl+C или введите номер для сбора слудющих логов\e[0m"
        ;;
        "FILE_SERVER")
            echo -e "\e[32mВведите пароль, лог будет помещен в архив file-server.zip на удаленной машине\e[0m"
            ssh root@7.0.68.230 "zip -j /opt/file-server.zip /var/log/nginx/error.log"
            echo -e "\e[32mЛог file-server.zip будет скачан в /opt на ваше устройство\e[0m"
            scp root@7.0.68.230:/opt/file-server.zip /opt
            echo -e "\e[32mФайл скачан, проверьте папку 'opt'\e[0m"
			unzip /opt/file-server.zip -d /opt/
            echo -e "\e[32mДля выхода из программы нажмите Ctrl+C или введите номер для сбора слудющих логов\e[0m"
        ;;
    esac
done
