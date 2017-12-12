-- Http server create

http = net.createServer(net.TCP, 30)


if http then
  http:listen(80, function(conn)
    conn:on("receive", receiver_htp)
    conn:send("hello world")
  end)
end

function receive_http(sck, data)    
  local request = string.match(data,"([^\r,\n]*)[\r,\n]",1)
  if request == 'GET / HTTP/1.1' then
--    gpio.write(my_pin_nummber, gpio.HIGH)
  end 

  sck:on("sent", function(sck) sck:close() end)
    
  local response = {}
  response[#response + 1] = 
    'HTTP/1.0 200 OK\r\nServer: BelSmart\r\nContent-Type: text/html\r\n\r\n'..
     '<!DOCTYPE HTML><html lang="ru"><head>'..
     '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">'..
     '<title>BelSmart</title><style>'
     
  response[#response + 1] =      
     '.form-style-9 {max-width: 450px;background:#FAFAFA;padding:30px;margin: 50px auto;box-shadow: 1px 1px 25px rgba(0,0,0,0.35);border-radius:10px;border: 6px solid #305A72;}'..
     '.form-style-9 ul { padding:0; margin:0;list-style:none;}'..
     '.form-style-9 ul li {display: block; margin-bottom: 10px;min-height: 35px;}'
  response[#response + 1] = '.form-style-9 ul li  .field-style{'..
   'box-sizing: border-box; '..
   '-webkit-box-sizing: border-box;'..
   '-moz-box-sizing: border-box; '..
   'padding: 8px;'..
   'outline: none;'..
   'border: 1px solid #B0CFE0;'..
   '-webkit-transition: all 0.30s ease-in-out;'..
   '-moz-transition: all 0.30s ease-in-out;'..
   '-ms-transition: all 0.30s ease-in-out;'..
   '-o-transition: all 0.30s ease-in-out;}'

 response[#response + 1] = '.form-style-9 ul li  .field-style:focus{'..
'    box-shadow: 0 0 5px #B0CFE0;'..
'    border:1px solid #B0CFE0;'.. 
'}'..
'.form-style-9 ul li .field-split{'..
'    width: 49%;'..
'}'..
'.form-style-9 ul li .field-full{'..
    'width: 100%;'..
'}'..
'.form-style-9 ul li input.align-left{'..
'float:left;'..
'}'..
'.form-style-9 ul li input.align-right{'..
'float:right;'..
'}'..
'.form-style-9 ul li textarea{'..
'width: 100%;'..
'height: 100px;'..
'}'

response[#response + 1] = '.form-style-9 ul li input[type="button"], '..
'.form-style-9 ul li input[type="submit"] {'..
'-moz-box-shadow: inset 0px 1px 0px 0px #3985B1;'..
'-webkit-box-shadow: inset 0px 1px 0px 0px #3985B1;'..
'box-shadow: inset 0px 1px 0px 0px #3985B1;'..
'background-color: #216288;'..
'border: 1px solid #17445E;'..
'display: inline-block;'..
'cursor: pointer;'..
'color: #FFFFFF;'..
'padding: 8px 18px;'..
'text-decoration: none;'..
'font: 12px Arial, Helvetica, sans-serif;'..
'}'..
'.form-style-9 ul li input[type="button"]:hover, '..
'.form-style-9 ul li input[type="submit"]:hover {'..
'    background: linear-gradient(to bottom, #2D77A2 5%, #337DA8 100%);'..
'    background-color: #28739E;'..
'}'..
 


     '</style>'..
     '</head><body>'..
     '<h1>&#x041A&#x0430&#x043B&#x0438&#x0442&#x043A&#x0430</h1>'..
     '<hr>'..
     
    '<form class="form-style-9">'..
    '<ul>'..
    '<li>'..
    '<input type="text" name="field1" class="field-style field-split align-left" placeholder="Name" />'..
    '<input type="email" name="field2" class="field-style field-split align-right" placeholder="Email" />'..
    '</li>'..
    '<li>'..
    '<input type="text" name="field3" class="field-style field-split align-left" placeholder="Phone" />'..
    '<input type="url" name="field4" class="field-style field-split align-right" placeholder="Website" />'..
    '</li>'..
    '<li>'..
    '<input type="text" name="field3" class="field-style field-full align-none" placeholder="Subject" />'..
    '</li>'..
    '<li>'..
    '<textarea name="field5" class="field-style" placeholder="Message"></textarea>'..
    '</li>'..
    '<li>'..
    '<input type="submit" value="Send Message" />'..
    '</li>'..
    '</ul>'..
    '</form>'..
    '</body></html>' 
 
    local function send(localSocket)
    if #response > 0 then
      localSocket:send(table.remove(response, 1))
    else
      localSocket:close()
      response = nil
    end
  end
  sck:on("sent", send)

  send(sck)
end  

if http then
  http:listen(80, function(conn)
    conn:on("receive", receive_http)
  end) 
end 
 
print("- Started http -")