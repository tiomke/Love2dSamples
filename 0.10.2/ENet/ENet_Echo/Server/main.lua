-- 服务端-回显服务器
-- 同步阻塞
-- 每次只能接收一个客户端

-- host 数据接收方或者发送方
-- peer 传输数据用的通道
-- event 用于存储信息

require "enet"

host = enet.host_create("localhost:6790")
print("host",host)

function love.update()
	local event = host:service(100)
	if event then
		print("event",event.type)
		if event.type == "receive" then
		      print("Got message: ", event.data, event.peer)
		      event.peer:send( event.data)
		elseif event.type == "connect" then
		      print(event.peer, "connected.")
		elseif event.type == "disconnect" then
		      print(event.peer, "disconnected.")
		end
	end
end
