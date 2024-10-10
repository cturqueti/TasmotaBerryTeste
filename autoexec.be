COUNTER_1 = 0
class Motor_Control : Driver
  var fast_loop_closure, mqtt_loop_closure
  var fast_loop_counter
  def init()
    import gpio
    import mqtt
    # tasmota.cmd("GroupTopic tasmotas")
    # tasmota.cmd("CounterDebounce 100")
    self.fast_loop_closure = def () self.fast_loop() end
    self.mqtt_loop_closure = def (topic, idx, payload_s, payload_b) self.mqtt_loop(topic, idx, payload_s, payload_b) end
    mqtt.subscribe("cmnd/tasmotas/#", self.mqtt_loop_closure)

    self.fast_loop_counter = 0

  end

  def mqtt_loop(topic, idx, payload_s, payload_b)
    print(topic)
    print("data: " .. payload_s)
    if topic == "cmnd/tasmotas/run"
      print("Topico Correto")
      if payload_s == "1"
        print("Iniciando movimentação")
        self.run()
      end
    elif topic == "cmnd/tasmotas/pwm"
      print("Setado pwm para: " .. payload_s)
      gpio.set_pwm(1,int(payload_s))
    end
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

end

motor_control = Motor_Control()


#motor_control.run()
