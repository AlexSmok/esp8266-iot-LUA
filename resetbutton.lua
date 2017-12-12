--gpio.mode(PIN_WRITE, gpio.OUTPUT)

 local pin = 3    --> GPIO0

 function debounce (func)
    local last = 0
    local delay = 30000 

    return function (...) 
        local now = tmr.now()
    print(now)
        local delta = now - last
    print(delta)        
        if delta < 0 then delta = delta + 2147483647 end 
    print(delta)                
        -- proposed because of delta rolling over, 
        -- https://github.com/hackhitchin/esp8266-co-uk/issues/2
        if delta < delay then return end

        last = now
        return func(...)
    end
 end



    
    function onChange ()
      print('The pin value has changed to '..gpio.read(pin))
    end
    
 --   print(pin)
 --   print(gpio.INPUT)
 --   print(gpio.PULLUP)
    gpio.mode(pin, gpio.INPUT, gpio.PULLUP)
    gpio.trig(pin, "both", debounce(onChange))