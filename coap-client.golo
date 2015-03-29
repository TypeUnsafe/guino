module coapcli

import coap
import org.eclipse.californium.core.CoapClient


function main = |args| {

  let handler = coapHandler()
    : $onLoad(|response| {
        println(response: getResponseText())
      })
    : $onError({
        println("oups!")
      })
    : initialize()

  let client = CoapClient("coap://127.0.0.1:5683")

  client: setURI("coap://127.0.0.1:5683/blue_on")
  client: get(handler)

  
  client: setURI("coap://127.0.0.1:5683/yellow_on")
  client: get(handler)

  client: setURI("coap://127.0.0.1:5683/red_on")
  client: get(handler)

  readln("")
  

}