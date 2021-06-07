# Little Buster

A WoW TBC Classic addon for converting ratings to value in tooltips. Currently distributed via [WowInterface](https://www.wowinterface.com/downloads/fileinfo.php?id=26048#info), but releases are also published here on GitHub under Releases.

## Building

The addon is written in [Teal](https://github.com/teal-language/tl), a typed dialect of Lua. Much like TypeScript compiles to Javascript, Teal compiles to Lua.

As such, this project requires the Teal compiler, `tl`. You can install it by [following the instructions](https://github.com/teal-language/tl#installing) in the Teal repo.

To build the addon, download `tl` to somewhere on your computer. Then, from a shell/command line, navigate to the directory that this repository is located in.

Then:

```shell
tl build
``` 

...will generate the `.lua` files in the root directory. If that's inconvenient, you can change the output directory by modifying `tlconfig.lua`'s `build_dir` property.

## Features
 
Supports tooltips with phrasing like:

 - +5 Block Rating
 - Equip: Increases your defense rating by 20.
 - Use: Increases your dodge rating by 300 for 10 sec.

### Currently does not support:
 
 - The stat Resilience.
 - Probably a handful of edge cases I haven't discovered
 
#### Locale support

✔: Fully tested and working
🔷: Functional, but incomplete
❌: Not supported, no functionality

|Locale|Support|
|------|-------|
|enUS--|✔------|
|enGB--|✔------|
|esMX--|✔------|
|esES--|✔------|
|ruRU--|✔------|
|deDE--|🔷-----|
|ptBR--|❌-----|
|itIT--|❌-----|
|frFR--|❌-----|
|koKR--|❌-----|
|zhTW--|❌-----|
|zhCN--|❌-----|
