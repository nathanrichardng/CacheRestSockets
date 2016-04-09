window.restSocket = restSocketFactory;

function restSocketFactory(url) {
	return new restSock(url);	
}

function restSock(url) {
	var ws = new WebSocket("ws://" + url);
	console.log("connecting on " + "ws://" + url);

	var rs = {
		subscriptions: {},
		subscribe: subscribe,
		unsubscribe: unsubscribe,
		onopen: function(){ console.log("not updated") },
		onOpen: setOnOpen,
		on: addEventHandler,
		handle: handleEvent,
		send: send 
	}
	
	console.log(ws.readyState);
	
	ws.onopen = function() {
		rs.onopen();	
	};
	
	ws.onmessage = function(evt) {
		var serverMessage = JSON.parse(evt.data);
		console.log("response", serverMessage);
		rs.handle(serverMessage.publication, serverMessage.action, serverMessage.message);
	};
	
	
	return rs;
	
	function setOnOpen(func) {
		this.onopen = func;	
	}
	
	function subscription() {
		var sub = {
			eventHandlers: {}	
		}
		return sub;	
	}
	
	function subscribe(publication) {
		if (!this.subscriptions[publication]) { this.subscriptions[publication] = new subscription(); }
		this.send(publication, "subscribe", "subscribing");	
	}
	
	function unsubscribe(publication) {
		if (this.subscriptions[publication]) { delete this.subscriptions[publication]; }
		this.send(publication, "unsubscribe", "unsubscribing");
	}
	
	function addEventHandler(publication, action, callback) {
		this.subscriptions[publication].eventHandlers[action] = callback;
	}
	
	function handleEvent(publication, action, message) {
		if (!this.subscriptions[publication]) { return false; }
		if (!this.subscriptions[publication].eventHandlers[action]) { return false; }
		this.subscriptions[publication].eventHandlers[action](message);	
	}
	
	function send(publication, action, message) {
		var msg = JSON.stringify({ publication: publication, action: action, message: message });
		console.log("sending message", msg);
		ws.send(msg);	
	}
	
}