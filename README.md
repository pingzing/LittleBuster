# Little Buster

A WoW TBC Classic addon for converting ratings to value in tooltips. Currently distributed via [WowInterface](https://www.wowinterface.com/downloads/fileinfo.php?id=26048#info) and [CurseForge](https://www.curseforge.com/wow/addons/little-buster), but releases are also published here on GitHub under Releases.

## Building

The addon is written in [Teal](https://github.com/teal-language/tl), a typed dialect of Lua. Much like TypeScript compiles to Javascript, Teal compiles to Lua.

As such, this project requires the Teal compiler, `tl`. You can install it by [following the instructions](https://github.com/teal-language/tl#installing) in the Teal repo.

To build the addon, first ensure that `tl` is somewhere on your computer, and in your `PATH`. Then, run with included `build.ps1` script with PowerShell. This will generate a working addon in the `output` directory.

If on a machine without PowerShell available, you can follow the steps manually:

1. Run `tl build` from the root directory.
2. Copy all non-`.tl` files (such as XML files) from `/src/` to their respective directories inside `/output/`
3. Copy `LittleBuster.toc`, `CHANGELOG.txt` and `LICENSE.md` from the repo root to to`/output/`.

## Features
 
Converts all ratings in tooltips from their rating, to the value or percentage they grant to you at your current level.

Supports tooltips with phrasing like:

 - +5 Block Rating
 - Equip: Increases your defense rating by 20.
 - Use: Increases your dodge rating by 300 for 10 sec.

### Currently does not support:
 
 - The stat Resilience.
 - Probably a handful of edge cases I haven't discovered
 
#### Locale support

✔: Fully tested and working  
🔷: Functional, but not fully tested, or incomplete  
❌: Not supported, no functionality  

|Locale|Support|Future plans|
|------|-------|------------|
|enUS|✔|Update as bugs are discovered|
|ruRU|✔|Update as bugs are reported by users|
|esMX|🔷|Update as bugs are reported by users|
|esES|🔷|Update as bugs are reported by users|
|deDE|🔷|Update as bugs are reported by users|
|ptBR|🔷|Update as bugs are reported by users|
|frFR|🔷|Update as bugs are reported by users|
|zhCN|🔷|Update as bugs are reported by users|
|zhTW|🔷|No plans to support unless assisted|
|koKR|❌|No plans to support unless assisted|
