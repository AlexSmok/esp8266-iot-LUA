local pin = 3    --> GPIO2
 
function debounced_trigger(pin, onchange_function, dwell)
 
  local function trigger_cb(event)
 
         tmr.alarm(6, dwell, 0, function() 
             onchange_function(pin) 
      end)
    
   end
   
  gpio.trig(pin, 'up', trigger_cb) 
end

function onChange (pin)
if (gpio.read(pin) == 1) then resettoap() 

--else print("vovo") 
end
 

end 

function resettoap() 
  print("reset device to AP")

  fp = file.open("param.lua","w+");
if fp then


          fp:write('APNAME="BelSmart"\n')
          fp:write('APPASS="12345678"\n')
          fp:write('APTYPE="AP"\n')
          fp:write('APIP="192.168.5.1"\n')


end 
 
  fp:close()
  node.restart()
end

debounced_trigger(pin, onChange, 1000)
gpio.mode(pin, gpio.INT, gpio.PULLUP)