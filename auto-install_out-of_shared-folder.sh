#!/bin/bash
shared_folder="mnt/shared" Здесть надо указать путь до рашаренной папки на WIN в программе ниже

#монтиронваие для alt linux oracle
#sudo mkdir -p /mnt/shared
#sudo mount -t vboxsf shared_folder /mnt/shared


declare -A dict
echo -e "\e[32mДанный скрипт устанавливает последнню сборку Connect из расшаренной папке на WIN, чтобы указать путь до расшаернной папке на WIN, зайдите в скрипт и отредактируйет переменную shared_folder\e[0m"
echo -e "\e[32mУкажиет первые 3 цифры сборки \"Пример = 3.2.0\"\e[0m"
read build
echo -e "\e[32mУкажите типо пакета \"Пример = deb or rpm\"\e[0m"
read type_of_package
#echo $type_of_package
if [[ "$type_of_package" == ".deb" || "$type_of_package" == "deb"  ]]; then
	shared_folder="/media/sf_Share_Linux_Connect" #Здесть надо указать путь до рашаренной папки на WIN для deb
    while IFS= read -r -d '' package; do
        dict[("${package##*/}")]="$package"

    done < <(find $shared_folder -name "*.deb" -print0)

    #echo "${!dict[@]}"
    for connect in "${!dict[@]}"; do
        if grep -i -q "linux" < <(echo "$connect")  && grep -i -q  "3.2.0" < <(echo "$connect"); then
            number="${dict[$connect]##*_}"
            number="${number#*-}"
            number="${number%%-*}"
            numbers_of_builds+=($number)
        fi
    done

    #echo "${numbers_of_builds[@]}"
    #echo ${!numbers_of_builds[@]}
    for i in ${!numbers_of_builds[@]}; do
        for (( j = i + 1; j < ${#numbers_of_builds[@]}; j++ )); do
            if (( ${numbers_of_builds[i]} <= ${numbers_of_builds[j]} )); then
                number2=${numbers_of_builds[i]}
                numbers_of_builds[i]=${numbers_of_builds[j]}
                numbers_of_builds[j]=$number2
            fi
        done
    done

    for i in "${!dict[@]}"; do
        #echo $i
        if [[ $i == *"${numbers_of_builds[0]}"* ]]; then
            dpkg -i "${dict[$i]}"
            #echo "000000000"
        fi
    done

else
    #echo "Тип пакета Rpm"
	shared_folder="/mnt/shared" #Здесть надо указать путь до рашаренной папки на WIN для deb
    while IFS= read -r -d '' package; do
        dict[("${package##*/}")]="$package"

    done < <(find $shared_folder -name "*.rpm" -print0)

    #echo "${!dict[@]}"
    for connect in "${!dict[@]}"; do
        if grep -i -q "linux" < <(echo "$connect")  && grep -i -q  "3.2.0" < <(echo "$connect"); then
            number="${dict[$connect]##*/}"
            #echo "$number"
            number="${number#*_}"
            number="${number#*-}"
            number="${number%%-*}"
           # echo "$number"
#             number="${number%%-*}"
#             echo "$number"
            numbers_of_builds+=($number)
        fi
    done

    #echo "${numbers_of_builds[@]}"
    #echo ${!numbers_of_builds[@]}
    for i in ${!numbers_of_builds[@]}; do
        for (( j = i + 1; j < ${#numbers_of_builds[@]}; j++ )); do
            if (( ${numbers_of_builds[i]} <= ${numbers_of_builds[j]} )); then
                number2=${numbers_of_builds[i]}
                numbers_of_builds[i]=${numbers_of_builds[j]}
                numbers_of_builds[j]=$number2
            fi
        done
    done

    for i in "${!dict[@]}"; do
        if [[ $i == *"${numbers_of_builds[0]}"* ]]; then
			OS=$(lsb_release -a 2>/dev/null)
			if [[ $OS == *"ALT"* ]]; then
				echo -e "\e[32mВаша система ALt Linux. Сборка скопировано в /opt. Если возникли ошибки, установите вручную\e[0m"
				cp "${dict[$i]}" /opt
				rpm -i /opt/*"${numbers_of_builds[0]}"*
			else
            	rpm -i "${dict[$i]}"
			fi

        fi
    done

fi


echo "------------------------------"

