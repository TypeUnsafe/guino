module trigolocoap

import guino
import coap

function main = |args| {


  let myArduino = device(): port("/dev/cu.usbmodem1411"): initialize(): onSet(|self| {
      
      let redLed = self: getLedInstance("red", 13)
      let blueLed = self: getLedInstance("blue", 9)
      let yellowLed = self: getLedInstance("yellow", 2)

      let red_on = coapResource(): identifier("red_on"): name("red_on")
        : $get(|exchange| {
            redLed: switchOn()
            exchange: respond(CONTENT(), "yo!")
          }): initialize()

      let red_off = coapResource(): identifier("red_off"): name("red_off")
        : $get(|exchange| {
            redLed: switchOff()
            exchange: respond(CONTENT(), "yo!")
          }): initialize()

      let blue_on = coapResource(): identifier("blue_on"): name("blue_on")
        : $get(|exchange| {
            blueLed: switchOn()
            exchange: respond(CONTENT(), "yo!")
          }): initialize()

      let blue_off = coapResource(): identifier("blue_off"): name("blue_off")
        : $get(|exchange| {
            blueLed: switchOff()
            exchange: respond(CONTENT(), "yo!")
          }): initialize()

      let yellow_on = coapResource(): identifier("yellow_on"): name("yellow_on")
        : $get(|exchange| {
            yellowLed: switchOn()
            exchange: respond(CONTENT(), "yo!")
          }): initialize()

      let yellow_off = coapResource(): identifier("yellow_off"): name("yellow_off")
        : $get(|exchange| {
            yellowLed: switchOff()
            exchange: respond(CONTENT(), "yo!")
          }): initialize()       

      let stop = coapResource(): identifier("stop"): name("stop")
        : $get(|exchange| {
            self: stop()
            exchange: respond(CONTENT(), "yo!")
          })
        : initialize()  
        
      #blueLed: switchOn()
      #yellowLed: switchOn()
      #redLed: switchOn()

      let server = coapServer(): initialize()
        : add(red_on)
        : add(red_off)
        : add(blue_on)
        : add(blue_off) 
        : add(yellow_on)
        : add(yellow_off)                 
        : start()


      println("... started ...")
      
      #self: stop()

  }): onFail(|err| {
      println("Huston? We've got a problem!")
  })
  

}