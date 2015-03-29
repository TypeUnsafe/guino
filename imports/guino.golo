module guino

import gololang.Async
import org.firmata4j.firmata.FirmataDevice

struct led = {
  id,
  pin,
  _component
}

augment led {
  function initialize = |this, arduinoDevice| {

    println("Led initialize | pin: "+ this: pin() + " | id: " + this: id())

    this: _component(arduinoDevice: getPin(this: pin()))
    this: _component(): setMode(org.firmata4j.Pin$Mode.OUTPUT())  
    
    return this
  }
  function value = |this| -> this: _component(): getValue()
  function value = |this, ledValue| {
    this: _component(): setValue(ledValue)
    return this
  }
  function switchOn = |this| {
    this: value(1)
    return this
  }
  function switchOff = |this| {
    this: value(0)
    return this
  }
  function delay = |this, ms| {
    sleep(ms)
    return this
  }
  function blink = |this, ms| {
    this: switchOn(): delay(ms): switchOff(): delay(ms)
    return this
  }
} 

struct device = { 
  port,
  leds,
  _arduino
}

augment device { # board
  # asynchronous initialization - return a promise
  function initialize = |this| {
    println("device " + this: port() +" initialize.")
    this: _arduino(FirmataDevice(this: port()))

    this: leds(map[])

    # define promise
    let devicePromise = -> promise(): initializeWithinThread(|resolve, reject| {
      # doing something asynchronous
      try {
        this: _arduino(): start()
        this: _arduino(): ensureInitializationIsDone()
        println("device " + this: port() +" ready.")
        resolve(this)
      } catch (err) {
        reject(err)
      }
    })
    return devicePromise()
  }
  function getLedInstance = |this, ledId, pinNumber| {
    let ledComponent = 
      led()
        : id(ledId)
        : pin(pinNumber)
        : initialize(this: _arduino())

    this: leds(): put(ledId, ledComponent)
    return ledComponent
  }
  function getLed = |this, ledId| -> this: leds(): get(ledId)
  function stop = |this| -> this: _arduino(): stop()

  function loop = |this, howMany, what| {
    howMany: times(|index| {
      what(index)
    })
  }
} 
