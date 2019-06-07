


# Wasabi services 

- functions: request response, no persistence, can last 10s at most
- handlers: long lived, can be put to sleep, can hold memory, but it might be deleted

functions are created in response to triggers
handlers are created and have a location

handlers can be sent messages by address
functions can be sent messages and are created

handlers can be session store, a cache, websocket connections. 
udp packet reciever
tco packet reciever

functions can make handlers, handlers can make functions, it's the compostability that makes it powerful and flexible

datastores abound

handlers and functions can be registered and used by others
can be configured. 


----

 - sharding data
 - resilient datastores

----

maybe it's all functions? 
still need the ability to create data chains

Voltlet posts data:
 - gets response from DB and sends back
 - posts message to channel 
 - function is spawned to pick up message from channel
 - create another listener on topic, finds messages without emojis and adds them, writes back to another topic
 - build and push docker container


notes:
 - just need a way to get pubsub, think about the ergonomics of an entire pubsub pipeline first, then think about runtime specifics
 - one click to run the application that saves the authentication details for you
 - click to launch the slack app creation wizard and get your details. so many oauth flows trigger on having an endpoint
 - composting the details for a spotify playlist creator flow.
 - think about things to do with apis.
 - map out the optimal application structure for voltus
 - data stores 

hold a tcp connection open
hodd a websocket conneciton open
webrtc data stream
