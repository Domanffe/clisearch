# Roadmap

Идеи для следующих версий clisearch.

## v1.1 — удобство

- [ ] История запросов и повтор через `!1`, `!2` (как в yt-x)
- [ ] Русская справка в терминале (UTF-8 BOM)
- [ ] Tab-completion для PowerShell
- [ ] Больше bang-команд из [DuckDuckGo Bangs](https://duckduckgo.com/bang)

## v1.2 — кастомизация

- [ ] Пользовательские bang в `%USERPROFILE%\.clisearch\bangs.json`
- [ ] Merge: встроенные + пользовательские bang
- [ ] `cs add yt-music` — добавить свой bang из CLI

## v1.3 — распространение

- [ ] Winget manifest (`winget install clisearch`)
- [ ] Scoop bucket
- [ ] GitHub Releases с zip-архивом
- [ ] Chocolatey package

## v2 — продвинутое

- [ ] Интерактивный выбор из результатов (fzf-style в PowerShell)
- [ ] Открытие первого результата напрямую (`--lucky`, как `ddgr --ducky`)
- [ ] Интеграция с yt-dlp для воспроизведения из терминала
- [ ] Один `.exe` через ps2exe для Win+R без PowerShell-задержки

## Уже сделано (v1)

- [x] Bang-команды: yt, g, gh, w, a, r, so
- [x] Шорткаты и универсальный `cs`
- [x] Установка / удаление через PATH
- [x] Работа в cmd, PowerShell, Win+R
- [x] `--dry-run` для тестов
- [x] CI на GitHub Actions
