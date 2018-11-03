dofile("sensor.lua")
last_state = nil
function register_sensor()
	http.get("https://jasonli.us/cgi-bin/webapp.cgi?action=add_sensor", "\r\n", function(code, body, headers)
		print(code)
		if code == 200 then
			sensor_id = body
			print(sensor_id)
			tmr.create():alarm(200, tmr.ALARM_AUTO, function(timer)
				if read_total_mag() > 6000000 then
					print("CLOSED "..sensor_id)
					if last_state ~= 0 then
						http.get("https://jasonli.us/cgi-bin/webapp.cgi?action=door_close&id="..sensor_id, "\r\n", function(code, body, headers)
							print("CLOSED SET")
							last_state = 0
						end)
					end
				else
					print("OPEN   "..sensor_id)
					if last_state ~= 1 then
						http.get("https://jasonli.us/cgi-bin/webapp.cgi?action=door_open&id="..sensor_id, "\r\n", function(code, body, headers)
							print("OPEN SET")
							last_state = 1
						end)
					end
				end
			end)
		else
			register_sensor()
		end
	end)
end

dofile("wifi_config.lua")
wifi_config.got_ip_cb = register_sensor
wifi.sta.config(wifi_config)
wifi.sta.connect()
