/*

[VSCRIPTCOLORS]
File must be in scripts/vscripts/vscriptcolors folder!

Put this at the top of your file to use VScriptColors
IncludeScript("vscriptcolors/main.nut", this);



ColorExists(string ColorExists)

Returns true/false if the color exists in the color table



DefineColor(string ColorName, string ColorHex)

Define a custom color in the color table to call later



GetClientTeamColor(handle client)

Returns gray, red, blue or white from the color table depending on your team



ColorPrint(handle Client, string Message, Format Args ...)

Print colored chat to a player or the server, define null for the client to print to all
Pass in more than two args to format the message

*/



IncludeScript("vscriptcolors/colorlist.nut", this);

::ColorExists <- function(color)
{
	return color in ColorsTable;
}

::DefineColor <- function(name, color)
{
	if(color.len() == 6)
		ColorsTable[name] <- color;
	else
		printl("[VSCRIPTCOLORS] ERROR: Tried to fill color " + name + " with an invalid hex color! Must be 6 digit hex!");
}

::GetClientTeamColor <- function(client)
{
	if(client != null && client.IsPlayer())
	{
		switch(client.GetTeam())
		{
			case 1: return ColorsTable["gray"]; break;
			case 2: return ColorsTable["red"]; break;
			case 3: return ColorsTable["blue"]; break;
			default: return ColorsTable["white"]; break;
		}
	}	
}

::ColorPrint <- function(client, message, ...)
{
	if(client != null)
	{
		local client_index = client.GetEntityIndex();

		if(client_index < 0 || client_index > Constants.Server.MAX_PLAYERS)
		{
			printl("[VSCRIPTCOLORS] ERROR: Client is invalid, returning!");
			return;	
		}
	}
	
	// if we have args, format them
	if(vargv.len() != 0)
	{	
		local formatarray = [this, message];
		
		foreach(i,val in vargv)
		{
			formatarray.append(vargv[i]);
		}
		
		message = format.acall(formatarray);
	}
	
	//lets add color
	local i = 0;
	
	local BufferMessage = "";
	
	while(i < message.len()) //let's start looking through our message for colors
	{
		if(message[i] == '{') //we found an open brace! lets start looking for a color
		{
			local FallbackBuffer = "{";
			local BufferColor = "";
			local BufferAlpha = "";
			local bSetAlpha = false;
			
			i += 1;
			while(i < message.len())
			{
				if(message[i] == '}') //we've gotten to the end
				{
					FallbackBuffer += "}"
					local bReadAsHex = false;
					
					if(BufferColor in ColorsTable) //does this color exist?
						BufferColor = ColorsTable[BufferColor];
					
					else if(BufferColor.len() != 6) //it doesn't, try to read as 6 digit hex
					{
						BufferMessage += FallbackBuffer
						break;
					}
					
					if(!bSetAlpha)
						BufferMessage += "\x07" + BufferColor;
					else if(regexp("[0-9]+").match(BufferAlpha)) // did we set the alpha?
					{
						BufferAlpha = format(BufferAlpha.tointeger() < 16 ? "0%X" : "%X", BufferAlpha.tointeger())
						BufferMessage += "\x08" + BufferColor + BufferAlpha;
					}
					else
						BufferMessage += FallbackBuffer
					
					break;
				}
				else if(message[i] == '[') //found an alpha
				{
					FallbackBuffer += "[";
					i += 1;
					
					while(i < message.len())
					{
						if(message[i] == ']') //we got our alpha
						{
							FallbackBuffer += "]";
							bSetAlpha = true;
							break;
						}
						else //no end bracket, fill the buffer alpha
						{
							BufferAlpha += message[i].tochar();
							FallbackBuffer += message[i].tochar();
						}
						
						i += 1;
					}
				}
				else //no end brace, fill the buffer color
				{
					BufferColor += message[i].tochar();
					FallbackBuffer += message[i].tochar();
				}
				i += 1;
			}
			i += 1;
		}
		BufferMessage += message[i].tochar()
		i += 1;
	}
	ClientPrint(client, Constants.EHudNotify.HUD_PRINTTALK, "\x01" + BufferMessage);
}