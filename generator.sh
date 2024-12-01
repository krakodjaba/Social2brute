#!/bin/bash

# === Настройки по умолчанию ===
USE_LEET=0
USE_SYMBOLS=0
USE_POPULAR=0
ADD_RANDOM=0
RANDOM_COUNT=10
DEBUG=0
INTERACTIVE=0
MAX_COMBINATION_DEPTH=5
MIN_LENGTH=8
MAX_LENGTH=16
output_file="passwords.txt"

# Популярные символы и пароли
symbols=("!" "@" "#" "$" "%" "^" "&" "*" "-" "_" "~")
popular_passwords=("123456" "123456789" "qwerty" "password" "12345" "12345678" "abc123" "monkey" "iloveyou" "admin")

# === Логирование ===
log_debug() { [[ $DEBUG -eq 1 ]] && echo "[DEBUG] $1"; }
log_info() { echo -e "\033[0;32m[INFO] $1\033[0m"; }
log_error() { echo -e "\033[0;31m[ERROR] $1"; }

# === Аргументы ===
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --leet) USE_LEET=1 ;;
    --symbols) USE_SYMBOLS=1 ;;
    --popular) USE_POPULAR=1 ;;
    --random) ADD_RANDOM=1; RANDOM_COUNT=$2; shift ;;
    --output) output_file=$2; shift ;;
    --debug) DEBUG=1 ;;
    --interactive) INTERACTIVE=1 ;;
    -h|--help)
      echo "Использование: $0 [опции]"
      echo "  --leet            Включить leet-преобразования"
      echo "  --symbols         Добавить символы"
      echo "  --popular         Включить популярные пароли"
      echo "  --random <count>  Добавить случайные пароли"
      echo "  --output <file>   Имя выходного файла (по умолчанию passwords.txt)"
      echo "  --interactive     Включить интерактивный режим"
      echo "  --debug           Включить режим отладки"
      exit 0
      ;;
    *) log_error "Неизвестный аргумент: $1"; exit 1 ;;
  esac
  shift
done

# === Интерактивный режим ===
if [[ $INTERACTIVE -eq 1 ]]; then
  log_info "Запуск в интерактивном режиме..."

  # Основной ввод данных
  data=()
  read -p "Введите ФИО (например, Иван Иванов): " fio
  [[ -n "$fio" ]] && data+=("$fio")

  read -p "Введите дату рождения (в формате ГГГГ-ММ-ДД): " dob
  [[ -n "$dob" ]] && data+=("$dob")

  read -p "Введите город рождения: " city
  [[ -n "$city" ]] && data+=("$city")

  read -p "Введите кличку животного: " pet
  [[ -n "$pet" ]] && data+=("$pet")

  # Включение дополнительных функций
  read -p "Использовать leet-преобразования? (y/n): " leet_input
  [[ "$leet_input" == "y" ]] && USE_LEET=1

  read -p "Добавить символы? (y/n): " symbols_input
  [[ "$symbols_input" == "y" ]] && USE_SYMBOLS=1

  read -p "Добавить популярные пароли? (y/n): " popular_input
  [[ "$popular_input" == "y" ]] && USE_POPULAR=1

  # Ввод дополнительных данных
  while true; do
    read -p "Добавить дополнительное поле? (нажмите Enter для завершения ввода): " extra
    [[ -z "$extra" ]] && break
    data+=("$extra")
  done
else
  data=("Иван Иванов" "1990-01-01" "Москва" "Барсик")
fi

# === Работа с датами ===
process_date() {
  local date="$1"
  local year month day
  IFS='-' read -r year month day <<< "$date"

  # Форматы дат
  echo "$date" "$year$month$day" "$day$month$year" "$year-$month-$day" "$day.$month.$year" "$year"
}

# === Основные функции ===
leet_transform() { echo "$1" | sed -e 's/a/@/g' -e 's/o/0/g' -e 's/i/1/g' -e 's/e/3/g' -e 's/s/5/g' -e 's/t/7/g'; }
add_symbols() { local r=(); for s in "${symbols[@]}"; do r+=("$s$1" "$1$s"); done; echo "${r[@]}"; }

# === Генерация вариантов регистра ===
generate_case_variations() {
  local word="$1"
  echo "$word" "${word,,}" "${word^^}" "$(echo "$word" | sed -r 's/./\u&/')" "$(echo "$word" | sed -r 's/(.)(.)/\u\1\L\2/')"
}

# === Часть данных (сокращение слов) ===
shorten_word() {
  local word="$1"
  echo "${word:0:2}" "${word:0:4}" "${word:0:5}"
}

# === Расширенное смешивание ===
combine_data() {
  local inputs=("$@")
  local results=()
  local max_combinations="$MAX_COMBINATION_DEPTH"
  local separators=("" "_" "-" ".")

  # Рекурсивная функция для генерации всех комбинаций
  generate_combinations() {
    local prefix="$1"
    shift
    local remaining=("$@")

    [[ -n "$prefix" ]] && results+=("$prefix")

    if (( ${#remaining[@]} > 0 )); then
      for i in "${!remaining[@]}"; do
        for sep in "${separators[@]}"; do
          local new_prefix="${prefix}${sep}${remaining[i]}"
          local new_remaining=("${remaining[@]:0:$i}" "${remaining[@]:$((i + 1))}")
          [[ $(echo "$new_prefix" | tr -cd '_' | wc -c) -lt "$max_combinations" ]] && generate_combinations "$new_prefix" "${new_remaining[@]}"
        done
      done
    fi
  }

  generate_combinations "" "${inputs[@]}"
  echo "${results[@]}"
}

# === Генерация паролей ===
generate_passwords() {
  local inputs=("$@")
  local passwords=()

  # Данные из дат
  for input in "${inputs[@]}"; do
    if [[ "$input" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
      local date_variations=($(process_date "$input"))
      passwords+=("${date_variations[@]}")
      inputs+=("${date_variations[@]}")  # Добавляем пермутации даты в общий пул
    fi
  done

  # Генерация вариантов регистра
  for input in "${inputs[@]}"; do
    passwords+=($(generate_case_variations "$input"))
  done

  # Leet-преобразования
  [[ $USE_LEET -eq 1 ]] && for i in "${inputs[@]}"; do passwords+=("$(leet_transform "$i")"); done

  # Части данных
  for i in "${inputs[@]}"; do
    passwords+=($(shorten_word "$i"))
  done

  # Символы
  [[ $USE_SYMBOLS -eq 1 ]] && for i in "${inputs[@]}"; do passwords+=($(add_symbols "$i")); done

  # Популярные пароли
  [[ $USE_POPULAR -eq 1 ]] && for i in "${inputs[@]}"; do for p in "${popular_passwords[@]}"; do passwords+=("${i}${p}" "${p}${i}"); done; done

  # Сложные комбинации данных
  passwords+=($(combine_data "${inputs[@]}"))
  echo "${passwords[@]}" | tr ' ' '\n' | sort -u
}

# === Выполнение ===
passwords=$(generate_passwords "${data[@]}")
echo "$passwords" > "$output_file"

# === Отчёт ===
total=$(wc -l < "$output_file")
log_info "Генерация завершена."
echo "=== Отчёт ==="
echo "Всего паролей: $total"

