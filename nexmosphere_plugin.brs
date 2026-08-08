' =========================================================
' BRIGHTSIGN PLUG-IN SCRIPT FOR NEXMOSPHERE SERIAL ROUTING
' =========================================================
' Target: Port 2 (USB Serial), Baud Rate: 115200, Line Mode: CR delimited
' This plugin routes serial commands to the HTML5 widget.
'
' IMPORTANT: To prevent conflicts, do NOT configure any 
' "Serial Input" events in the BrightAuthor UI playlist if using this plugin.

Function nexmosphere_plugin_Initialize(msgPort As Object, userVariables As Object, bsp As Object) As Object
    print "--- Nexmosphere 115200 Baud Plugin Initialize ---"
    
    plugin = CreateObject("roAssociativeArray")
    plugin.port = msgPort
    plugin.bsp = bsp
    plugin.ProcessEvent = nexmosphere_plugin_ProcessEvent
    
    ' Open Serial Port 2 (USB Serial) at 115200 baud
    plugin.serial = CreateObject("roSerialPort", 2, 115200)
    
    if plugin.serial <> invalid then
        print "Nexmosphere Plugin: Serial port 2 opened successfully at 115200 baud."
        
        ' Configure port to buffer until a Carriage Return (CR - ASCII 13) is received.
        ' This prevents packet fragmentation.
        plugin.serial.SetLineMode(true)
        plugin.serial.SetLineEventChar(13)
        plugin.serial.SetPort(msgPort)
    else
        print "Nexmosphere Plugin: ERROR - Could not open Serial Port 2. Make sure it isn't occupied by BrightAuthor's built-in Serial configurations."
    end if
    
    return plugin
End Function

Function nexmosphere_plugin_ProcessEvent(event As Object) As Boolean
    retval = false
    
    ' Check if the event is serial port data
    if type(event) = "roSerialPortEvent" then
        dataStr = event.GetString()
        print "Nexmosphere Plugin: Received Serial Line: "; dataStr
        
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
