# VScriptColors
A simple way to print advanced coloring to chat via VScripts

Supports pre-defined color codes and hex colors along with an alpha parameter

## Installation
[Download the zip](https://github.com/horiuchii/vscriptcolors/archive/refs/heads/main.zip) and extract to scripts/vscripts/

## Usage
`IncludeScript("vscriptcolors/main.nut", this)`

Include this to call the functions below

`ColorExists(string ColorExists)`

Returns true/false if the color exists in the color table


`DefineColor(string ColorName, string ColorHex)`

Define a custom color in the color table to call later


`GetClientTeamColor(handle client)`

Returns gray, red, blue or white from the color table depending on your team


`ColorPrint(handle Client, string Message, Format Args ...)`

Print colored chat to a player or the server, define null for the client to print to all.
Pass in more than two args to format the message

## Usage Examples

`ColorPrint(client, "hi {green[15]}faded text! {blue[120]}not so faded text! {red}normal text!")`

or

`ColorPrint(client, "hi {3EFF3E[15]}faded text! {99CCFF[120]}not so faded text! {FF4040}normal text!")`

![Output](/assets/fadedtext.jpg "Faded Text Output")

`ColorPrint(null, "{" + GetClientTeamColor(GetListenServerHost()) + "}Horiuchi {white}has unboxed: {unusual}Unusual Missing Masterpiece")`

![Output](/assets/unboxtext.jpg "Unbox Text Output")