-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there
dofile("param.lua") 

if APTYPE == nil then APTYPE = "AP" end
if APNAME == nil then APNAME = "GS-IoT" end
if APPASS == nil then APPASS = "12345" end
if APIP   == nil then APIP   = "192.168.5.55" end

function startup()
    if file.open("init.lua") == nil then
        print("init.lua deleted or renamed")
    else
        print("Running")
        file.close("init.lua")
        -- the actual application is stored in 'application.lua'
        -- dofile("application.lua")
        dofile("resetbutton.lua")
        dofile("http.lua")
    end
end

-- Define WiFi station event callbacks 
wifi_connect_event = function(T) 
  print("Connection to AP("..T.SSID..") established!")
  print("Waiting for IP address...")
  if disconnect_ct ~= nil then disconnect_ct = nil end  
end

wifi_got_ip_event = function(T) 
  -- Note: Having an IP address does not mean there is internet access!
  -- Internet connectivity can be determined with net.dns.resolve().    
  print("Wifi connection is ready! IP address is: "..T.IP)
  print("Startup will resume momentarily, you have 5 seconds to abort.")
  print("Waiting...") 
  tmr.create():alarm(5000, tmr.ALARM_SINGLE, startup)
end

wifi_disconnect_event = function(T)
  if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then 
    --the station has disassociated from a previously connected AP
    return 
  end
  -- total_tries: how many times the station will attempt to connect to the AP. Should consider AP reboot duration.
  local total_tries = 75
  print("\nWiFi connection to AP("..T.SSID..") has failed!")

  --There are many possible disconnect reasons, the following iterates through 
  --the list and returns the string corresponding to the disconnect reason.
  for key,val in pairs(wifi.eventmon.reason) do
    if val == T.reason then
      print("Disconnect reason: "..val.."("..key..")")
      break
    end
  end

  if disconnect_ct == nil then 
    disconnect_ct = 1 
  else
    disconnect_ct = disconnect_ct + 1 
  end
  if disconnect_ct < total_tries then 
    print("Retrying connection...(attempt "..(disconnect_ct+1).." of "..total_tries..")")
  else
    wifi.sta.disconnect()
    print("Aborting connection to AP!")
    disconnect_ct = nil  
  end
end

-- Register WiFi Station event callbacks

print(APTYPE)

if APTYPE == "AP" then 
    wifi.setmode(wifi.STATIONAP)
    AP_CFG={}
    AP_CFG.ssid=APNAME
    AP_CFG.pwd=APPASS
    AP_CFG.auth=AUTH_WPA_WPA2_PSK
--- Channel: Range 1-14
    AP_CFG.channel = 13 
--- Hidden Network? True: 1, False: 0
    AP_CFG.hidden = 0
--- Max Connections: Range 1-4
    AP_CFG.max=1
--- WiFi Beacon: Range 100-60000
    AP_CFG.beacon=100
    
 --   station_cfg.auto=true
    wifi.ap.config(AP_CFG)

    AP_IP_CFG={}
    AP_IP_CFG.ip=APIP
    AP_IP_CFG.netmask='255.255.255.0'
    AP_IP_CFG.gateway=APIP
    wifi.ap.setip(AP_IP_CFG)
 
    
    AP_DHCP_CFG ={}
    AP_DHCP_CFG.start = "192.168.5.3"
    wifi.ap.dhcp.config(AP_DHCP_CFG)
    wifi.ap.dhcp.start() 
    startup()
else
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifi_disconnect_event)

    print("Connecting to WiFi access point...")
    
    wifi.setmode(wifi.STATION)
    wifi.sta.config({ssid=APNAME, pwd=APPASS})
end



