tasmota.cmd("GroupTopic tasmotas") 

import mqtt

mqtt.subscribe("cmnd/tasmotas/run", function(topic, payload)
    if payload == "true"
        print("Valor 'true' recebido no tópico run")
    elif payload == "false"
        print("Valor 'false' recebido no tópico run")
    else
        print("Valor desconhecido recebido no tópico run")
    end
end)

import gpio

gpio.pin_mode(2,gpio.INPUT_PULLUP)

var max_gpio = gpio.MAX_GPIO
var pin = 0

COUNTER_1 = 0

tasmota.cmd("Counter1 0")
while true 
  var counter_value = gpio.counter_read(COUNTER_1)
  if (counter_value >= 10) 
      print("Terminou a contagem")
      break # Sai do loop
  end
end
tasmota.cmd("Counter1")



class button
  var BUTTON_1 = 1
  var BUTTON_2 = 2
  def init()
    import gpio
    # tasmota.cmd("GPIO2 33") # transforma o GPIO2 para Button 2 e reinicia o módulo
    # tasmota.cmd("GPIO2 352")
    tasmota.cmd("SetOption159 0") # le somente as bordas de descida do pino
    tasmota.cmd("Counter1 0") # zera o contador
    tasmota.cmd("CounterType 0")
    tasmota.cmd("SetOption19 1")
    tasmota.cmd("GPIO1 416") # transforma GPIO1 em saida PWM
    tasmota.cmd("Rule2 ON Button2#State DO publish stat/%topic%/button_state %value% ENDON")
    tasmota.cmd("Rule2 2")
    gpio.pin_mode(BUTTON_1,gpio.INPUT_PULLUP)
    gpio.pin_mode(BUTTON_2,gpio.INPUT_PULLUP)
    var max_gpio = gpio.MAX_GPIO
var pin = 0
  end

end


button()


class blinker
  def init()
    tasmota.remove_cmd('Blinker')
    tasmota.add_cmd('Blinker', /cmd,idx,payload,data->self.blinkstart(cmd,idx,payload,data))
  end
  def blinkstart(cmd,idx,payload,data)
    import string
    var args=string.split(payload,',')
    tasmota.set_timer(0, /->self.blink(int(args[0])*2, int(real(args[1])*1000)))
    tasmota.resp_cmnd_done()
  end
  def blink(count, interval)
    tasmota.cmd('Power1 toggle')
    if count > 1
      tasmota.set_timer(interval, /->self.blink(count-1, interval))
    end
  end
end
blinker()