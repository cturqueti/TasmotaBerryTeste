COUNTER_1 = 0
class Motor_Control : Driver
  var fast_loop_closure
  var fast_loop_counter
  def init()
    import gpio
    import mqtt
    # tasmota.cmd("GroupTopic tasmotas")
    # tasmota.cmd("CounterDebounce 100")
    self.fast_loop_closure = def () self.fast_loop() end

    self.fast_loop_counter = 0

  end

  def mqtt_data(topic, idx, data, databytes)
    
  end

  def fast_loop()
    self.fast_loop_counter += 1
    if self.fast_loop_counter >= 100
      self.fast_loop_counter = 0  # Reseta o contador do fast loop
      self.verificar_contador()    # Chama a função que verifica o número de passos
    end
  end

  def verificar_contador()
    var counter_value = gpio.counter_read(COUNTER_1)
    print("Número de passos do contador: " .. counter_value)

    if (counter_value >= 10) 
      print("Terminou a contagem")
      tasmota.cmd("Counter1")
      tasmota.remove_fast_loop(self.fast_loop_closure)
    end
    # Você pode adicionar aqui sua lógica para agir com base no contador
  end

  def run()
    tasmota.add_fast_loop(self.fast_loop_closure)
    tasmota.cmd("Counter1 0")
  end

  def mqtt_data(topic, idx, payload_s, payload_b)
    print(topic)
    print(payload_s)
    return(false)
  end

end

motor_control = Motor_Control()