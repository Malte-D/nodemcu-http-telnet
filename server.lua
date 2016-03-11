httphandler = function(c,payload)
    c:send("<html>\n<head>\n")
    c:send("<title>Hello World!</title>\n")
    c:send("</head>\n<body>\n")
    c:send("<h1>Hello World!</h1>\n")
    c:send("</body>\n</html>\n")
end

function setHttpHandler(h)
    httphandler = h
end

srv=net.createServer(net.TCP,180)
srv:listen(80,function(c) 
    c:on("receive",function(c,d)
        -- check whether the request was sent by putty or luatool 
        if d:sub(1,6) == string.char(255,251,31,255,251,32) or d:sub(1,5) == "file." then
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
            -- handle http request
            httphandler(c,d)
            c:close()
        end
    end)
    c:send("HTTP/1.1 200 OK\r\n\r\n")
end)
