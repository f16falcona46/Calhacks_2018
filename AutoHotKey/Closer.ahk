SetTitleMatchMode 2

InputBox, sensor_id, Sensor ID, Enter sensor ID (6 digit string of numbers):
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
a=https://jasonli.us/cgi-bin/webapp.cgi?action=is_door_open&id=%sensor_id%
while True
{
	whr.Open("GET", a, true)
	whr.Send()
	whr.WaitForResponse()
	door_open := whr.ResponseText
	if (door_open == "1")
	{
		while WinExist("[InPrivate]")
		{
			WinClose,[InPrivate]
		}
		while WinExist("(Private Browsing)")
		{
			WinClose,(Private Browsing)
		}
	}
	Sleep, 100
}