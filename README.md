# nodemcu-http-telnet

## Summary

This code starts a server on port 80, which can handle http and telnet requests.
With the telnet support, remote code upload (e.g with the luatool) is now possible, 
without the loss of an http server.
It is based on http://www.ccdw.org/node/12.
The main differences are the customizable http handler and the differentiation between http and telnet requests.
To check whether the request is a telnet request, the code checks the first bytes sent by the client.
Putty starts its requests with the bytes `255,251,31,255,251,32` and the luatool sends a string starting with `'file.'` first.

## Usage

Use the `setHttpHandler(h)` function to set your own http handler.
The argument passed to the function must be a function which accepts two arguments,
the connection and the received payload, so it is basically the same like the `on:receive` function in the server listener.

To use the telnet functionallity, you can either connect with putty to the ip on port 80 in telnet mode and send commands like you are connected through a serial port or you can use the luatool to upload files.

The variable `port` can be used to change the servers port before it is started.

In the init.lua file, `SSID` and `PASS` must be replaced with the ssid and password of the network, to which the esp should connect.

## Examples

Set an http handler, which responds with 'hello world':

`setHttpHandler(function(c,p) c:send("hello world") end)`

Upload the file main.lua to the esp with ip 192.168.178.42:

`python luatool.py --ip 192.168.178.42:80 --src main.lua`

