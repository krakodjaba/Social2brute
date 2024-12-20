# Генератор паролей для OSINT и учебных целей

## Дисклеймер
**Этот скрипт предназначен только для учебных и академических целей.** Он был разработан как практика программирования и демонстрация методов генерации паролей. 
Скрипт показывает, как простые данные могут быть преобразованы в сложные пароли, подчеркивая важность создания сильных и уникальных паролей.

Использование этого скрипта в злонамеренных целях строго запрещено. Всегда соблюдайте этические стандарты и действующее законодательство.

---

## Введение
В 2024 году, несмотря на развитие технологий безопасности, пароли остаются слабым местом для большинства пользователей. Даже с внедрением двухфакторной аутентификации, использование предсказуемых или слабых паролей создает значительные уязвимости.

Этот скрипт демонстрирует, как злоумышленники могут использовать общедоступные данные для генерации множества возможных паролей. Это учебный инструмент, который помогает понять, почему сильные пароли и безопасные методы аутентификации так важны.

---

## Особенности
Скрипт предоставляет мощные возможности для генерации паролей:
- **Комбинация данных:**
  - Использует имена, даты рождения, клички животных, города и другие данные.
  - Генерирует комбинации из 1 до 5 элементов.
- **Вариации регистра:**
  - Поддерживает строчные, заглавные, комбинированные и смешанные регистры.
- **Форматы дат:**
  - Поддерживаются форматы `19900101`, `01-01-1990`, `1990.01.01`.
- **Leet-преобразования:**
  - Замены символов (например, `a → @`, `o → 0`).
- **Добавление символов:**
  - Генерирует пароли с использованием символов (`!`, `@`, `#` и др.).
- **Популярные пароли:**
  - Комбинирует пользовательские данные с паролями из списка популярных (например, `123456`, `password`).
- **Сокращенные варианты:**
  - Генерирует сокращенные версии слов (например, первые 2-4 символа).
- **Разделители:**
  - Поддерживает `_`, `-`, `.` и другие разделители.
- **Интерактивный режим:**
  - Позволяет вводить данные вручную для персонализированной генерации.
- **Аргументы командной строки:**
  - Поддерживает гибкую настройку через параметры командной строки.
- **Генерация отчета:**
  - Выводит количество сгенерированных паролей и их характеристики.

---

## Как запустить

### Предварительные требования
- **Bash shell:** Убедитесь, что у вас есть совместимая оболочка Bash.
- **Linux/MacOS/WSL/Windows (с Git Bash):** Скрипт работает в любой среде с поддержкой Bash.

### Установка
1. Склонируйте репозиторий:
   ```bash
   git clone https://github.com/ваш-репозиторий/password-generator.git
   cd password-generator
   ```

2. Сделайте скрипт исполняемым:
   ```bash
   chmod +x generator.sh
   ```

### Использование

#### Базовый интерактивный режим
Запустите скрипт без аргументов для интерактивного ввода:
```bash
./generator.sh --interactive
```
Вас попросят ввести:
- ФИО (например, `Иван Иванов`)
- Дату рождения (например, `1990-01-01`)
- Город рождения (например, `Москва`)
- Кличку животного (например, `Барсик`)
- Дополнительные данные.

#### Режим командной строки
Используйте аргументы для настройки генерации:
```bash
./generator.sh --leet --symbols --popular --random 10 --output passwords.txt
```

**Доступные параметры:**
- `--leet`: Включить leet-преобразования (например, `a → @`).
- `--symbols`: Добавить символы к паролям.
- `--popular`: Комбинировать пользовательские данные с популярными паролями.
- `--random <количество>`: Сгенерировать указанное количество случайных паролей.
- `--output <файл>`: Указать имя файла для сохранения.
- `--interactive`: Включить интерактивный режим.
- `--debug`: Включить отладочный режим.

---

## Пример работы
Для ввода данных:
- **ФИО:** Иван Иванов
- **Дата рождения:** 1990-01-01
- **Город:** Москва
- **Кличка:** Барсик

Скрипт может сгенерировать:
```
Ivan123!
Ivan1990
Ivan_1990-01-01
BarsikMoscow!
123456Ivan
1990Ivanov
Mos_Ivan_1990
Barsik19900101
```

---

## Преимущества
1. **Реалистичная симуляция:** Демонстрирует, как злоумышленники могут использовать слабые пароли.
2. **Гибкость:** Полностью настраиваемый процесс генерации.
3. **Эффективность:** Использует передовые методы генерации паролей.
4. **Образовательная ценность:** Помогает понять уязвимости паролей.

---

## Этические аспекты
Этот инструмент предназначен только для учебных и академических целей. Его использование для злоумышленных действий противоречит этике и может нарушать законы.

Скрипт создан для повышения осведомленности о важности сильных паролей и безопасных методов аутентификации.
