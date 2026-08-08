' =========================================================
' BRIGHTSIGN PLUG-IN SCRIPT FOR NEXMOSPHERE SERIAL ROUTING
' =========================================================
' This plugin listens to Serial Port 0 (or USB serial) and
' forwards all Nexmosphere data directly to the HTML5 widget.
' Add this file as an "HTML5 Plugin" in BrightAuthor.

Function nexmosphere_plugin_Initialize(msgPort As Object, userVariables As Object, bsp As Object) As Object
    print "--- Nexmosphere Plugin Initialize ---"
    
    plugin = CreateObject("roAssociativeArray")
    plugin.port = msgPort
    plugin.bsp = bsp
    plugin.ProcessEvent = nexmosphere_plugin_ProcessEvent
    
    ' In BrightAuthor, the serial port configuration might already be open.
    ' If not, we open serial port 0 (RS-232) or USB ports (1, 2, etc.) at 9600 baud.
    plugin.serial = CreateObject("roSerialPort", 0, 9600)
    if plugin.serial = invalid then
        ' Fallback to USB serial (Port 2 is typically the first USB-serial converter)
        plugin.serial = CreateObject("roSerialPort", 2, 9600)
    end if
    
    if plugin.serial <> invalid then
        print "Nexmosphere Plugin: Serial port opened successfully."
        plugin.serial.SetPort(msgPort)
    else
        print "Nexmosphere Plugin: WARNING - Could not open Serial Port. It might already be opened by BrightAuthor."
    end if
    
    return plugin
End Function

Function nexmosphere_plugin_ProcessEvent(event As Object) As Boolean
    retval = false
    
    ' Check if the event is serial port data
    if type(event) = "roSerialPortEvent" then
        dataStr = event.GetString()
        print "Nexmosphere Plugin: Received Serial Data: "; dataStr
        
        ' Locate the HTML widget inside the presentation to forward the message
        htmlWidget = invalid
        
        ' Traverse zones to find the roHtmlWidget object
        if m.bsp <> invalid and m.bsp.zones <> invalid then
            for each zone in m.bsp.zones
                if zone.widgets <> invalid then
                    for each widget in zone.widgets
                        if type(widget) = "roHtmlWidget" or type(widget) = "roHtmlWidget2" then
                            htmlWidget = widget
                            exit for
                        end if
                    next
                end if
                if htmlWidget <> invalid then exit for
            next
        end if
        
        ' If found, post the data as a JS message (received via onbsmessage in HTML)
        if htmlWidget <> invalid then
            print "Nexmosphere Plugin: Forwarding serial data to HTML widget..."
            htmlWidget.PostJSMessage({data: dataStr})
        else
            print "Nexmosphere Plugin: WARNING - HTML widget not found in active zones."
        end if
        
        retval = true
    end if
    
    return retval
End Function
