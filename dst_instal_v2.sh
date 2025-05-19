#!/bin/bash
shared_folder="/media/sf_Share_Linux_Connect" #Здесть надо указать путь до рашаренной папки на WIN
OS=$(lsb_release -a 2>/dev/null)
echo -e "\e[32mДанный скрипт ищет DST файлы в папке /home и расшаренной папке на WIN, чтобы указать путь до расшаернной папке на WIN, зайдите в скрипт и отредактируйет переменную shared_folder\e[0m"
echo $OS

if [[ $OS == *"ALT"* ]]; then
    while IFS= read -r -d '' file; do           #получаем список dst из расшаренной папки и в системе
        files+=("$file")
    done < <(find /home $shared_folder -name "*.dst" -print0)

    echo -e "\e[32mВыбертие DST который хотите установить\e[0m"
    select choise in "${files[@]}"; do
        echo ${choise}
        if vipnetclient info | grep -i -x "Keys have not been installed"; then
            vipnetclient stop
            sleep 5


            dst_path="/opt/$(basename "${choise}")" #Возврщает последню часть пути
            echo $dst_path
            echo -e "\e[32mВаша система ALt Linux. DST скопирован в /opt, установка будет происходить оттуда\e[0m"
            cp "${choise}" /opt
            cp "${choise%/*}" /opt
            if cat /opt/"${choise%/*}"/.*txt; then
                echo -e "\e[32mЭто ваш пароль, можете вписать его ниже\e[0m"
            else
                echo -e "\e[32mТекстовый файл с паролем в папке не найден, придется ввести вручную\e[0m"
            fi



            vipnetclient installkeys $dst_path
        else
            vipnetclient stop
            sleep 5
            vipnetclient deletekeys
            if cat "${choise%/*}"/*.txt; then
                echo -e "\e[32mЭто ваш пароль, можете вписать его ниже\e[0m"
            else
                echo -e "\e[32mТекстовый файл с паролем в папке не найден, придется ввести вручную\e[0m"
            fi

            echo $dst_path
            vipnetclient installkeys "$dst_path"
        fi
        vipnetclient start
    done

else
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(sudo find /home $shared_folder -name "*.dst" -print0)

    echo -e "\e[32mВыбертие DST который хотите установить\e[0m"
    select choise in "${files[@]}"; do
        echo ${choise}
        if vipnetclient info | grep -i -x "Keys have not been installed"; then
            vipnetclient stop
            sleep 5
            cp "${choise%/*}" /opt

            pass_path="${choise%/*}"
            pass_path=$(echo "$pass_path" | awk -F'/' '{print $(NF-0)}') #парсинг предполследнго пути
            #echo "$pass_path"

            if sudo cat /opt/"$pass_path"/*.txt; then
                echo -e "\e[32mЭто возможно ваш пароль, можете вписать его ниже\e[0m"
            else
                echo -e "\e[32mТекстовый файл с паролем в папке не найден, придется ввести вручную\e[0m"
            fi
            vipnetclient installkeys /opt/"$pass_path"/*.dst
        else
            vipnetclient stop
            sleep 5
            vipnetclient deletekeys
            sudo cp -r "${choise%/*}" /opt

            pass_path="${choise%/*}"
            pass_path=$(echo "$pass_path" | awk -F'/' '{print $(NF-0)}') #парсинг предполследнго пути
            #echo "$pass_path"

            if sudo cat /opt/"$pass_path"/*.txt; then
                echo -e "\e[32mЭто возможно ваш пароль, можете вписать его ниже\e[0m"
            else
                echo -e "\e[32mТекстовый файл с паролем в папке не найден, придется ввести вручную\e[0m"
            fi
            vipnetclient installkeys /opt/"$pass_path"/*.dst
            #vipnetclient start
        fi
    done
fi




