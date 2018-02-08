require "enet"
host = enet.host_create()
server = host:connect("localhost:6789")

function love.update(dt)
  if not done then
    local event = host:service(100)
    if event then
      if event.type == "connect" then
        print("connect..",event.peer)
        event.peer:send("ping")
      elseif event.type == "receive" then
        print("get message",event.data)
        event.peer:send("ping")
        done = true
      end
    end
  end
end
