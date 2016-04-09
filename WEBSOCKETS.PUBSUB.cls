Class WEBSOCKETS.PUBSUB Extends %Persistent
{

Property Publication As %String;

Property Subscriber As %String;

ClassMethod Subscribe(pPublication As %String, pSubscriber As %String) As %Status
{
	Set subscription = ..%New()
	Set subscription.Publication = pPublication
	Set subscription.Subscriber = pSubscriber
	Set status = subscription.%Save()
	Quit status
}

ClassMethod Unsubscribe(pPublication As %String, pSubscriber As %String) As %Status
{
	Set myquery =   "DELETE FROM WEBSOCKETS.PUBSUB " _
					"WHERE Publication = '"_pPublication_"' "_
					"AND Subscriber = '"_pSubscriber_"'"
	
				
	// This %Prepare command executes the query contained in "sql", sets the result to "rs", and gives an "error" flag back.
	Set tStatement = ##class(%SQL.Statement).%New()
	Set qStatus = tStatement.%Prepare(myquery)
	If qStatus'=1 { Write "%Prepare failed",$System.Status.DisplayError(qStatus) Quit}
  	Set rs = tStatement.%Execute()
  	Quit qStatus
}

ClassMethod UnsubscribeAll(pSubscriber As %String) As %Status
{
	Set myquery =   "DELETE FROM WEBSOCKETS.PUBSUB " _
					"WHERE Subscriber = '"_pSubscriber_"'"
	
				
	// This %Prepare command executes the query contained in "sql", sets the result to "rs", and gives an "error" flag back.
	Set tStatement = ##class(%SQL.Statement).%New()
	Set qStatus = tStatement.%Prepare(myquery)
	If qStatus'=1 { Write "%Prepare failed",$System.Status.DisplayError(qStatus) Quit}
  	Set rs = tStatement.%Execute()
  	Quit qStatus
}

ClassMethod GetSubscribers(pPublication As %String) As %ListOfDataTypes
{
	Set myquery =   "SELECT Subscriber " _
					"FROM WEBSOCKETS.PUBSUB " _
					"WHERE Publication = '"_pPublication_"'"
	
				
	// This %Prepare command executes the query contained in "sql", sets the result to "rs", and gives an "error" flag back.
	Set tStatement = ##class(%SQL.Statement).%New()
	Set qStatus = tStatement.%Prepare(myquery)
	If qStatus'=1 { Write "%Prepare failed",$System.Status.DisplayError(qStatus) Quit}
  	Set rs = tStatement.%Execute()
  	Set subscriberList = ##class(%ListOfDataTypes).%New()

	While (rs.%Next()) {
		
		// Use the %Get command to get the value of the column specified, in this case, "Value".
		Set websocketId = rs.%Get("Subscriber")
		Do subscriberList.Insert(websocketId)
	}
	
	Quit subscriberList
}

ClassMethod ClearAllSubscribersFromPublication(pPublication) As %Status
{
	Set myquery =   "DELETE FROM WEBSOCKETS.PUBSUB " _
					"WHERE Publication = '"_pPublication_"'"
	
				
	// This %Prepare command executes the query contained in "sql", sets the result to "rs", and gives an "error" flag back.
	Set tStatement = ##class(%SQL.Statement).%New()
	Set qStatus = tStatement.%Prepare(myquery)
	If qStatus'=1 { Write "%Prepare failed",$System.Status.DisplayError(qStatus) Quit}
  	Set rs = tStatement.%Execute()
  	Quit qStatus
}

ClassMethod Broadcast(pPublication As %String, pMessage As %String) As %Status
{
	Set myquery =   "SELECT Subscriber " _
					"FROM WEBSOCKETS.PUBSUB " _
					"WHERE Publication = '"_pPublication_"'"
	
				
	// This %Prepare command executes the query contained in "sql", sets the result to "rs", and gives an "error" flag back.
	Set tStatement = ##class(%SQL.Statement).%New()
	Set qStatus = tStatement.%Prepare(myquery)
	If qStatus'=1 { Write "%Prepare failed",$System.Status.DisplayError(qStatus) Quit}
  	Set rs = tStatement.%Execute()

	While (rs.%Next()) {
		
		// Use the %Get command to get the value of the column specified, in this case, "Value".
		Set websocketId = rs.%Get("Subscriber")
		Set ws = ##class(%CSP.WebSocket).%New()
		Set status = ws.OpenServer(websocketId)
		Set status = ws.Write(pMessage)
		if (status '= $$$OK){
			Do ..UnsubscribeAll(websocketId)
		}
	}
	
	Quit status
}

}
