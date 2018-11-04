SENSOR_ID_FILENAME = "sensor_id.txt"

dofile("sensor.lc")
last_state = nil
get_in_progress = false

function got_ip()
	if file.exists(SENSOR_ID_FILENAME) then
		id_file = file.open(SENSOR_ID_FILENAME, "r")
		if id_file == nil then
			register_sensor()
		else
			sensor_id = id_file:read()
			id_file:close()
			sensor_job(sensor_id)
		end
	else
		register_sensor()
	end
end

function register_sensor()
	http.get("https://jasonli.us/cgi-bin/webapp.cgi?action=add_sensor", "\r\n", function(code, body, headers)
		print(code)
		if code == 200 then
			sensor_id = body
			id_file = file.open(SENSOR_ID_FILENAME, "w")
			if id_file ~= nil then
				id_file:write(sensor_id)
				id_file:close()
			else
				print("Unable to write sensor_id to file.")
			end
			sensor_job(sensor_id)
		else
			register_sensor()
		end
	end)
end

function sensor_job(sensor_id)
	tmr.create():alarm(200, tmr.ALARM_AUTO, function(timer)
		if read_total_mag() > 6000000 then
			print("CLOSED "..sensor_id)
			if last_state ~= 0 and not get_in_progress then
				get_in_progress = true
				http.get("https://jasonli.us/cgi-bin/webapp.cgi?action=door_close&id="..sensor_id, "\r\n", function(code, body, headers)
					if code == 200 then
						print("CLOSED SET")
						last_state = 0
					end
					get_in_progress = false
				end)
			end
		else
			print("OPEN   "..sensor_id)
			if last_state ~= 1 and not get_in_progress then
				get_in_progress = true
				http.get("https://jasonli.us/cgi-bin/webapp.cgi?action=door_open&id="..sensor_id, "\r\n", function(code, body, headers)
					if code == 200 then
						print("OPEN SET")
						last_state = 1
					end
					get_in_progress = false
				end)
			end
		end
	end)
end

dofile("wifi_config.lc")
wifi_config.got_ip_cb = got_ip
wifi.sta.config(wifi_config)
wifi.sta.connect()