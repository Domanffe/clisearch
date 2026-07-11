# clisearch

Быстрый поиск с командной строки Windows — аналог Linux bang-команд (`!yt`, `!gh`, `!g` и т.д.).

Пишете `yt lofi music` — открывается YouTube с вашим запросом. Работает из **cmd**, **PowerShell**, **Windows Terminal** и **Win+R**.

Без Python, Node и прочих зависимостей — только встроенный PowerShell.

## Быстрый старт

### Установка из git

```powershell
git clone https://github.com/Domanffe/clisearch.git
cd clisearch
.\install.ps1
```

После установки **перезапустите терминал** (или откройте новое окно).

### Установка одной командой

```powershell
irm https://raw.githubusercontent.com/Domanffe/clisearch/master/install-remote.ps1 | iex
```

Если `irm` выдаёт 404, используйте установку через git (выше) — GitHub CDN иногда отдаёт устаревшую версию скрипта.

### Удаление

```powershell
.\uninstall.ps1
```

## Использование

### Шорткаты

```bat
yt lofi hip hop
yt "как установить rust"
g docker compose tutorial
gh neovim config
w Linux
```

### Универсальная команда `cs`

```bat
cs yt lofi music
cs !gh rust async
cs g windows terminal themes
cs list
```

Префикс `!` опционален: `cs !yt` и `cs yt` — одно и то же.

### Без запроса

```bat
yt
g
```

Откроется главная страница сайта.

### Отладка (без открытия браузера)

```bat
yt test --dry-run
cs !gh rust --dry-run
```

## Доступные команды

| Команда | Сайт | Аналог DDG |
|---------|------|------------|
| `yt` | YouTube | `!yt` |
| `g` | Google | `!g` |
| `gh` | GitHub | `!gh` |
| `w` | Wikipedia | `!w` |
| `a` | Amazon | `!a` |
| `r` | Reddit | `!r` |
| `so` | Stack Overflow | `!so` |

Полный список: `cs list`

## Как это работает

```
yt lofi music  →  yt.cmd  →  clisearch.ps1  →  bangs.json  →  браузер
```

- [`bin/*.cmd`](bin/) — тонкие обёртки для cmd / PowerShell / Win+R
- [`lib/clisearch.ps1`](lib/clisearch.ps1) — парсинг bang, сборка URL, запуск браузера
- [`config/bangs.json`](config/bangs.json) — таблица сайтов и URL-шаблонов

Файлы устанавливаются в `%LOCALAPPDATA%\clisearch\`, папка `bin` добавляется в пользовательский PATH.

## FAQ

**Команда не найдена после установки**

Перезапустите терминал. PATH обновляется только в новых сессиях.

**Win+R не находит `yt`**

Проверьте `where yt` в новом cmd. Иногда нужен выход из аккаунта или перезагрузка.

**Ошибка политики выполнения PowerShell**

Менять политику не нужно — все `.cmd` запускают PowerShell с `-ExecutionPolicy Bypass`.

## Разработка

Локальная проверка без браузера:

```powershell
.\tests\test.ps1
.\lib\clisearch.ps1 yt "test query" --dry-run
```

CI запускает `tests/test.ps1` на `windows-latest`.

## Репозиторий

https://github.com/Domanffe/clisearch

## Лицензия

[MIT](LICENSE)
