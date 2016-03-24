port = 80

httphandler = function(connection,payload)
    connection:send("Hello World")
end

function setHttpHandler(h)
    httphandler = h
end

srv=net.createServer(net.TCP,180)
srv:listen(port,function(c)
    c:on("receive",function(c,d)
        tmr.stop(6)
        -- check whether the request was sent by putty or luatool 
        if (d:sub(1,6) == string.char(255,251,31,255,251,32) or d:sub(1,5) == "file.") then
            -- switch to telnet service
            node.output(function(s)
                if c ~= nil then c:send(s) end
            end,0)
            c:on("receive",function(c,d)
                if d:byte(1) == 4 then c:close() -- ctrl-d to exit
                else node.input(d) end
            end)
            c:on("disconnection",function(c)
                node.output(nil)
            end)
            node.input("\r\n")
            if  d:sub(1,5) == "file." then
                node.input(d)
            end
        else
            c:on("sent", function(c) c:close() end)
            -- handle http request
            httphandler(c,d)
        end
    end)
    -- luatool needs to receive a response before it sends anything
    tmr.alarm(6,500,0,function() c:send("HTTP/1.1 200 OK\r\n\r\n") end )
end)
