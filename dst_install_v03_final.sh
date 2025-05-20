#!/bin/bash
shared_folder="/media/sf_Share_Linux_Connect" #Здесть надо указать путь до рашаренной папки на WIN
OS=$(lsb_release -a 2>/dev/null)
echo -e "\e[32mДанный скрипт ищет DST файлы в папке /home и расшаренной папке на WIN, чтобы указать путь до расшаернной папке на WIN, зайдите в скрипт и отредактируйет переменную shared_folder\e[0m"
echo $OS

if [[ $OS == *"ALT"* ]]; then
	#получаем список dst из расшаренной папки и в системе
    while IFS= read -r -d '' file; do           
        files+=("$file")
    done < <(find /home $shared_folder -name "*.dst" -print0)

    echo -e "\e[32mВыбертие DST который хотите установить\e[0m"
    select choise in "${files[@]}"; do

        #echo "${choise}"
		#Создаем папку в /opt для dst и тесктового файлы с паролем
		path="${choise}"
		file_name=$(basename -- "$path")       
		folder_name="${file_name%.*}"          
		mkdir -p -- /opt/"$folder_name"
		echo -e "\e[32mСоздана папка /opt/$folder_name куда будут скачаны dst и текстовый файл с паролем\e[0m"

      	#Копируем dst и текстовый файл с паролем с папку /opt/"$file_name"
		echo -e "\e[32mВаш DST - ${choise}\e[0m"
		cp -r "${choise}" /opt/"$folder_name"			
       	pass_path="${choise%/*}"
		echo -e "\e[32mВ этой папке возможно ваш пароль от DST - $pass_path\e[0m"	
		cp -r "$pass_path"/*.txt /opt/"$folder_name"

		#Вывод пароля в консоль
        if vipnetclient info | grep -i -x "Keys have not been installed"; then
            vipnetclient stop
            sleep 5
			#Чтение пароля из файла
            if cat /opt/"$folder_name"/*.txt; then
                echo -e "\e[32mЭто возможно ваш пароль, можете вписать его ниже\e[0m"
            else
                echo -e "\e[32mТекстовый файл с паролем в папке не найден, придется ввести вручную\e[0m"
            fi

            vipnetclient installkeys /opt/"$folder_name"/*.dst
        else
            vipnetclient stop
            sleep 5
            vipnetclient deletekeys
			#Чтение пароля из файла
            if cat /opt/"$folder_name"/*.txt; then
                echo -e "\e[32mЭто возможно ваш пароль, можете вписать его ниже\e[0m"
            else
                echo -e "\e[32mТекстовый файл с паролем в папке не найден, придется ввести вручную\e[0m"
            fi

			vipnetclient installkeys /opt/"$folder_name"/*.dst
            #vipnetclient start
        fi

    done

else
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(sudo find /home $shared_folder -name "*.dst" -print0)

	echo -e "\e[32mВыбертие DST который хотите установить\e[0m"
    select choise in "${files[@]}"; do

		#Создаем папку в /opt для dst и тесктового файлы с паролем
		path="${choise}"
		file_name=$(basename -- "$path")
		folder_name="${file_name%.*}"
		sudo mkdir -p -- /opt/"$folder_name"
		echo -e "\e[32mСоздана папка /opt/$folder_name куда будут скачаны dst и текстовый файл с паролем\e[0m"

      	#Копируем dst и текстовый файл с паролем с папку /opt/"$file_name"
		echo -e "\e[32mВаш DST - ${choise}\e[0m"
		sudo cp -r "${choise}" /opt/"$folder_name"
       	pass_path="${choise%/*}"
		echo -e "\e[32mВ этой папке возможно ваш пароль от DST - $pass_path\e[0m"
		#sudo cp "$pass_path"/*.txt /opt/$folder_name
        #pass_path=$(dirname -- "$choise")
        sudo find "$pass_path" -maxdepth 1 -name "*.txt" -exec cp {} "/opt/$folder_name/" \; # просто копирование по шаблону не работает

		#Вывод пароля в консоль
        if vipnetclient info | grep -i -x "Keys have not been installed"; then
            vipnetclient stop
            sleep 5
			#Чтение пароля из файла
            if sudo cat /opt/"$folder_name"/*.txt; then
                echo -e "\e[32mЭто возможно ваш пароль, можете вписать его ниже\e[0m"
            else
                echo -e "\e[32mТекстовый файл с паролем в папке не найден, придется ввести вручную\e[0m"
            fi
			vipnetclient installkeys /opt/"$folder_name"/*.dst
        else
            vipnetclient stop
            sleep 5
            vipnetclient deletekeys
			#Чтение пароля из файла
            if sudo cat /opt/"$folder_name"/*.txt; then
                echo -e "\e[32mЭто возможно ваш пароль, можете вписать его ниже\e[0m"
            else
                echo -e "\e[32mТекстовый файл с паролем в папке не найден, придется ввести вручную\e[0m"
            fi
			vipnetclient installkeys /opt/"$folder_name"/*.dst
        fi

    done
fi




