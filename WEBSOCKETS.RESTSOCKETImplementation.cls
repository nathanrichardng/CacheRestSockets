Class WEBSOCKETS.RESTSOCKETImplementation Extends DLS.WEBSOCKETS.RESTSOCKET
{

XData UrlMap
{
<Routes>
<Route Url="/message" Method="POST" Call="BroadcastMessage" />
<Route Url="/subscribers" Method="POST" Call="GetSubscribers" />
</Routes>
}

ClassMethod BroadcastMessage() As %Status
{
	try {
		Set publication = %request.Data("Publication", 1)
		Set message = %request.Data("Message", 1)
	}
	catch {
		Write "Not all parameters supplied"	
	}
	Set status = ..Broadcast(publication, "message", message)
	Quit status
}

ClassMethod GetSubscribers() As %ListOfDataTypes
{
	try {
		Set publication = %request.Data("Publication", 1)
	}
	catch {
		Write "Not all parameters supplied"	
	}
	Set subscribers = ##class(WEBSOCKETS.PUBSUB).GetSubscribers(publication)
	Set subscribers = ##class(%ZEN.Auxiliary.jsonProvider).%ObjectToJSON(subscribers)
	Quit subscribers
}

}
