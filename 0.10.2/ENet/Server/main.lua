require "enet"
host = enet.host_create"localhost:6789"

function love.update(dt)
  local event = host:service(100)
  if event then
    if event.type == "connect" then
      print("connect..",event.peer)
    elseif event.type == "receive" then
      print("get message",event.data)
    elseif event.type == "disconnect" then
      print("disconnect..",event.peer)
    end
  end
end


-- connect..	127.0.0.1:60551
-- get message	ping
-- disconnect..	127.0.0.1:60551
