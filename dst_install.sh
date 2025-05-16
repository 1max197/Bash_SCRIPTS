#!/bin/bash
shared_folder="/media/sf_Share_Linux_Connect" #Здесть надо указать путь до рашаренной папки на WIN
echo -e "\e[32mДанный скрипт ищет DST файлы в папке /home и расшаренной папке на WIN, чтобы указать путь до расшаернной папке на WIN, зайдите в скрипт и отредактируйет переменную shared_folder\e[0m"

while IFS= read -r -d '' file; do
    files+=("$file")
done < <(find /home $shared_folder -name "*.dst" -print0)
#echo "${files[@]}"

echo -e "\e[32mВыбертие DST который хотите установить\e[0m"
select choise in "${files[@]}"; do
    #echo ${choise%/*}
    if vipnetclient info | grep -i -x "Keys have not been installed"; then
        vipnetclient stop
        sleep 5
        if cat "${choise%/*}"/.*txt; then
            echo -e "\e[32mЭто ваш пароль, можете вписать его ниже\e[0m"
            cat "${choise%/*}"/.*txt
        else
            echo -e "\e[32mТекстовый файл с паролем в папке не найден, придется ввести вручную\e[0m"
        fi
        vipnetclient installkeys "$choise"
    else
        vipnetclient stop
        sleep 5
        vipnetclient deletekeys
        if cat "${choise%/*}"/*.txt; then
            echo -e "\e[32mЭто ваш пароль, можете вписать его ниже\e[0m"
        else
            echo -e "\e[32mТекстовый файл с паролем в папке не найден, придется ввести вручную\e[0m"
        fi
        vipnetclient installkeys "$choise"
    fi
vipnetclient start
done

