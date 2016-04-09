Class WEBSOCKETS.Message Extends %RegisteredObject
{

Property Publication As %String;

Property Action As %String;

Property Message As %String;

ClassMethod generateJsonMessage(pPublication As %String, pAction As %String, pMessage As %String) As %String
{
	Set jsonMessage = "{ ""publication"": """_pPublication_""", ""action"": """_pAction_""", ""message"": """_pMessage_""" }"
	Quit jsonMessage
}

}
