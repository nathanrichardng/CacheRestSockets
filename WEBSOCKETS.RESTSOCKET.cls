Class WEBSOCKETS.RESTSOCKET Extends (%CSP.REST, DLS.WEBSOCKETS.Server)
{

ClassMethod Broadcast(pPublication As %String, pAction As %String, pMessage As %String) As %Status
{
	Set message = ##class(WEBSOCKETS.Message).generateJsonMessage(pPublication, pAction, pMessage)
	Set status = ##class(WEBSOCKETS.PUBSUB).Broadcast(pPublication, message)
	Quit status
}

}
