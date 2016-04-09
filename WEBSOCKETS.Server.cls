/// A subscriber to the WebSocketManager
Class WEBSOCKETS.Server Extends %CSP.WebSocket
{

Method OnPreServer() As %Status
{
	Set ..SharedConnection = 1
 	Quit $$$OK
}

Method Server() As %Status
{
	For  
   		{
      		Set data= ..Read(, .status, )
			If $$$ISERR(status) 
			{
				If $$$GETERRORCODE(status) = $$$CSPWebSocketClosed 
				{
					Quit
				}
      		} else 
      		{
	         	Do ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(data, "%ZEN.proxyObject", .msg)
	         	Set action = msg.action
	         	Set publication = msg.publication
	         	If (action = "subscribe"){
		         	Do ##class(WEBSOCKETS.PUBSUB).Subscribe(publication, ..WebSocketID)
		         	Set message = ##class(WEBSOCKETS.Message).generateJsonMessage(publication, "subscribed", "ID "_..WebSocketID_" subscribed to "_publication)
		         	Do ##class(WEBSOCKETS.PUBSUB).Broadcast(publication, message)
		        }
		       	If (action = "unsubscribe"){
			       	Set message = ##class(WEBSOCKETS.Message).generateJsonMessage(publication, "unsubscribed", "ID "_..WebSocketID_" unsubscribed from "_publication)
			       	Do ##class(WEBSOCKETS.PUBSUB).Broadcast(publication, message)
			       	Do ##class(WEBSOCKETS.PUBSUB).Unsubscribe(publication, ..WebSocketID)
			    }
     	 	}
   		}
   	Set status = ..EndServer()
   	Quit $$$OK
}

Method OnPostServer() As %Status
{
	Do ##class(WEBSOCKETS.PUBSUB).UnsubscribeAll(..WebSocketID)
 	Quit $$$OK
}

}
