#Guino

**Guino** is(will be) a #gololang DSL for **Arduino**.

##Quickstart

```golo
module trigolo

import guino

function main = |args| {

  let myArduino = device(): port("/dev/cu.usbmodem1411"): initialize(): onSet(|self| {
      
      let redLed = self: getLedInstance("red", 13)
      let blueLed = self: getLedInstance("blue", 9)
      let yellowLed = self: getLedInstance("yellow", 2)

      blueLed: switchOn()
      yellowLed: switchOn()
      redLed: switchOn()

      Thread({
        self: loop(50, |i| {
          redLed: blink(1000_L)
        })
      }): start()

      Thread({
        self: loop(50, |i| {
          blueLed: blink(1000_L)
        })
      }): start()

      Thread({
        self: loop(50, |i| {
          yellowLed: blink(1000_L)
        })
      }): start()
      
      #self: stop()

  }): onFail(|err| {
      println("Huston? We've got a problem!")
  })
  
}
```