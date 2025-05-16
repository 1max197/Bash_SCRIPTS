#!/bin/bash

# Определяем временное место для создания файлов
DIR="/home/max197/Desktop/tempfile"

# Создаем директорию для временных файлов, если её нет
mkdir -p "$DIR"

# Цикл, который продолжает создавать файлы, пока свободное место не станет <100 MB
while true; do
    # Получаем количество свободного места в KB для /
    free_space_kb=$(df --output=avail / | tail -n 1)

    # Преобразуем в MB
    free_space_mb=$((free_space_kb / 1024))

    # Если свободного места меньше 100 MB, выходим из цикла
    if [ "$free_space_mb" -lt 100 ]; then
        echo "Свободного места стало меньше 100 MB. Завершаем создание файлов."
        break
    fi

    # Генерируем уникальное имя файла
    filename="$DIR/file_$(date +%s%N).tmp"

    # Создаем файл размером 10 MB
    dd if=/dev/zero of="$filename" bs=1M count=10 status=none
    echo "Создан файл: $filename. Свободное место: ${free_space_mb}MB"
done
