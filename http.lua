-- Http server create


http = net.createServer(net.TCP, 40)


if http then
  http:listen(80, function(conn)
    conn:on("receive", receive_http)
  end) 
end 


function receive_http(sck, data)    
  local request = string.match(data,"([^\r,\n]*)[\r,\n]",1)
  
  function listap(t)          
  
    local listpoint = ""      
    for ssid,v in pairs(t) do
          authmode, rssi, bssid, channel = string.match(v, "(%d),(-?%d+),(%x%x:%x%x:%x%x:%x%x:%x%x:%x%x),(%d+)")
          listpoint = listpoint ..  '<option value="'..ssid..'">'..ssid..'   ('..rssi ..'db)' ..'</option>'
          --print(ssid,authmode,rssi,bssid,channel)
        end
     
    receive_http2(sck, data, listpoint, request);    
  end
  
  if request == 'GET /favicon.ico HTTP/1.1' then return end
  wifi.sta.getap(listap)  

end 
 
function receive_http2(sck, data, listpoint, request)    
  --local request = string.match(data,"([^\r,\n]*)[\r,\n]",1)
  --if request == 'GET /favicon.ico HTTP/1.1' then return end
   
-- gett ap list
print(data) 
print('-----------')
print(request)
local needrestart = false
if request == 'POST / HTTP/1.1' then

k,_ = data:find("apname") 


print(k)
if (k ~= nil) then
data=data:sub(k, #data) 

fp = file.open("param.lua","w+");
if fp then

for k, v in string.gmatch(data, "(%w+)=([a-z0-9.]+)") do
          fp:write(k..'="'..tostring(v):upper()..'"\n')
end
    fp:write('APTYPE="Station"\n')
end 
 
  fp:close()
  needrestart = true
end  
end
  
  if request == 'GET / HTTP/1.1' then
--    gpio.write(my_pin_nummber, gpio.HIGH)
  end 

-- sck:on("sent", function(sck) sck:close() end)

  local response = {}
  
  if (needrestart) then 
 

  response[#response + 1] = 

    'HTTP/1.0 200 OK\r\nServer: BelSmart\r\nContent-Type: text/html\r\n\r\n'..
    '<!DOCTYPE HTML><html lang="ru"><head>'..
    '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">'..
    '<title>BelSmart</title>'..
    '</head><body>'..
    '<h1>&#x041A&#x0430&#x043B&#x0438&#x0442&#x043A&#x0430</h1>'..
    '<hr>'..
    'Seting saved and device restarted.'.. 
    '</body></html>' 

  else 
  response[#response + 1] = 
    'HTTP/1.0 200 OK\r\nServer: BelSmart\r\nContent-Type: text/html\r\n\r\n'..
     '<!DOCTYPE HTML><html lang="ru"><head>'..
     '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">'..
     '<title>BelSmart</title>'
  response[#response + 1] =  '<style type="text/css">'..
'.form-style-1 { margin:10px auto; max-width: 550px; padding: 20px 12px 10px 20px; font: 13px "Lucida Sans Unicode", "Lucida Grande", sans-serif; }'..
'.form-style-1 li { padding: 0; display: block; list-style: none; margin: 10px 0 0 0; }'..
'.form-style-1 label{ margin:0; padding:0px; display:block; font-weight: bold; }'..
'.form-style-1 input[type=text], .form-style-1 input[type=password], .form-style-1 input[type=date], .form-style-1 input[type=datetime], .form-style-1 input[type=number], .form-style-1 input[type=search],'..
'.form-style-1 input[type=time], .form-style-1 input[type=url], .form-style-1 input[type=email], textarea, select { box-sizing: border-box; -webkit-box-sizing: border-box;'..
'-moz-box-sizing: border-box; border:1px solid #BEBEBE; padding: 7px; margin: 3px 0 0 0; -webkit-transition: all 0.30s ease-in-out; -moz-transition: all 0.30s ease-in-out;'..
'-ms-transition: all 0.30s ease-in-out; -o-transition: all 0.30s ease-in-out; outline: none; }'

  response[#response + 1] = '.form-style-1 input[type=text]:focus, .form-style-1 input[type=date]:focus, .form-style-1 input[type=datetime]:focus, .form-style-1 input[type=number]:focus,'..
'.form-style-1 input[type=search]:focus, .form-style-1 input[type=time]:focus, .form-style-1 input[type=url]:focus, .form-style-1 input[type=email]:focus,'..
'.form-style-1 textarea:focus, .form-style-1 select:focus { -moz-box-shadow: 0 0 8px #88D5E9; -webkit-box-shadow: 0 0 8px #88D5E9; box-shadow: 0 0 8px #88D5E9;'..
'border: 1px solid #88D5E9; }'..
'.form-style-1 .field-divided{ width: 49%; }'..
'.form-style-1 .field-long { width: 100%; }'

  response[#response + 1] = '.form-style-1 .field-select{ width: 100%; }'..
'.form-style-1 .field-textarea{ height: 100px; }'..
'.form-style-1 input[type=submit], .form-style-1 input[type=button] { background: #4B99AD; padding: 8px 15px 8px 15px; border: none; color: #fff; }'..
'.form-style-1 input[type=submit]:hover, .form-style-1 input[type=button]:hover{ background: #4691A4; box-shadow:none; -moz-box-shadow:none; -webkit-box-shadow:none; }'..
'.form-style-1 .required{ color:red; }'..
'</style>'     

  response[#response + 1] =     '</head><body>'..
     '<h1>&#x041A&#x0430&#x043B&#x0438&#x0442&#x043A&#x0430</h1>'..
     '<hr>'.. 
     

'<form method="post">'..
'<ul class="form-style-1">'..
'    <li><label>WAN<span class="required">*</span></label>'..

'        <select name="apname" class="field-select">'..
        listpoint ..
'        </select>'..

'   <input type="password" name="appass" class="field-divided" placeholder="Password" /></li>'..
'   <li><label>Device IP<span class="required">*</span></label>'..
'   <input type="text" name="apip" class="field-divided" pattern="\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" placeholder="IP" /></li>'..
'   <li><label>MQTT Broker<span class="required">*</span></label>'..
'   <input type="text" name="brip" class="field-divided" pattern="\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\.\\d{1,3}" placeholder="IP" />'..
'   <input type="text" name="brlogin" class="field-divided" placeholder="Login" />&nbsp;'..
'   <input type="password" name="brpass" class="field-divided" placeholder="Password" /></li>'..




'    <li>'..
'        <input type="submit" value="Save and reboot" />'..
'    </li>'..
'</ul>'..
'</form>'.. 
'</body></html>' 

end
 
  local function send(localSocket)
    if #response > 0 then
      localSocket:send(table.remove(response, 1))
    else
      localSocket:close()
      response = nil
     
     if (needrestart) then  node.restart()  end
      
    end
  end
  sck:on("sent", send)

  send(sck)
 
 
end  


 
print("- Started http -")
