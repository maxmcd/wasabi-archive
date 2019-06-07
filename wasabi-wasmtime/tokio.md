
Can likely just move everything to the tokio runtime. We still need to generate ids/tokens. Maybe keep the same callback for all io?

Make sure to shutdown the runtime. Keep the runtime on shared state?

Tokio likes to be callback based. We currently just reference everything in a slab. Don't think that's going to work without a new pattern. 

We can run everything in callbacks and just pass messages to a channel with state changes. What happens when I call .Read though? How is the socket found and how is data read?

Could clone the future on an event and place futures in a slab/map for direct access. Then just use the 


It seems like I could maintain something like this: https://docs.rs/futures/0.1/futures/stream/futures_unordered/struct.FuturesUnordered.html

Or equivalent, where I'm handed the finished futures and I manage them manually. Maybe this is missing the point. Would then just need a future type that is an enum of the future types that I'd be using and implements a future wrapper for the lot of them. 

It seems I can either control where the tasks are returning or just implement a runtime. https://tokio.rs/docs/going-deeper/building-runtime/


Ok, the cloning thing seems fine for now, now we just have to keep working at getting all FS calls workings and hammering out the async patterns. One piece we need to keep in mind is that there are now true async calls, so we need to be aware of any pending events in the io loop. Should wait when we can and now wait when we shouldn't.

All Go wasm events are going to track with a callback id, so that should be passable to all tokio io. 
