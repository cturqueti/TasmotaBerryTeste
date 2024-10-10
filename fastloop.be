
var fast_loop_counter = 0
var contador = 0
class my_driver

  def verificar_contador()
    print("Número de passos do contador: " .. contador)
    # Você pode adicionar aqui sua lógica para agir com base no contador
  end

  def every_100ms()
    # called every 100ms via normal way
    fast_loop_counter += 1
    if fast_loop_counter >= 20
      fast_loop_counter = 0  # Reseta o contador do fast loop
      self.verificar_contador()    # Chama a função que verifica o número de passos
    end
  end

  def fast_loop()
    # called at each iteration, and needs to be registered separately and explicitly
  end

  def init()
    # register fast_loop method
    tasmota.add_fast_loop(/-> self.fast_loop())
    # variant:
    # tasmota.add_fast_loop(def () self.fast_loop() end)
  end
end

tasmota.add_driver(my_driver())                     # register driver
tasmota.add_fast_loop(/-> my_driver.fast_loop())    # register a closure to capture the instance of the class as well as the method