wifi.setmode(wifi.STATION)
wifi.sta.config("SSID","PASS")

dofile("server.lua")
