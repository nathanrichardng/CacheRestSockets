## CacheRestSockets
REST/Websocket communication classes for Intersystems Cache

##Using RESTSOCKETS

####Server

* Create a REST router by inheriting from the WEBSOCKETS.RESTSOCKET class.
* Assign routes as normal, but include the method ..Broadcast(publication, action, message) anywhere you would like to broadcast a message via websockets.
* From the Management Portal, assign this class as the REST router for your application.

####Client

* Include the restSocket.js file in your CSP page.
* Instantiate the restSocket class with the following:

```javascript
var rs = restSocket(url); 
//Where url is the path to your RESTSOCKET child 
//e.g. /csp/RESTSockets/WEBSOCKETS.RESTSOCKETSImplementation.cls
```

* Set up any subscriptions or event listeners inside of the onOpen function:

```javascript
rs.onOpen(function(){
    //subscribe to the "game informer" publication
	rs.subscribe("game informer"); 
	//listen for any "subscribed" actions from "game informer" and call the addMessage function.
	rs.on("game informer", "subscribed", addMessage);
	rs.on("game informer", "unsubscribed", addMessage);
	rs.on("game informer", "message", addMessage);
});
```

##Demo
You can try out the package using the included WebsocketClient.csp. Just make sure to adjust the urls to match what you've 
assigned for your REST class in the Management Portal.
