-- client.lua
-- 输入文字，回车发送文字到服务端，服务端收到消息后会回显到客户端

require "enet"
local host = enet.host_create() -- 创建一个主机对象
local server = host:connect("localhost:6790") -- 连接服务器
print("server",server)

local utf8 = require("utf8")
function love.load()
    -- setFont
    font = love.graphics.newFont("tea.ttf",20)
    love.graphics.setFont(font)
    -- set text
    msg = "type your input and use enter to send msg"
    text = ""
    echo = ""

    -- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.
    love.keyboard.setKeyRepeat(true)
end
 
function love.update(...)
  local event = host:service() -- 需要用来保持连接
  if not event then return end

  if event.type == "receive" then
    echo = event.data
  elseif event.type == "connect" then
    print("connect..")
  elseif event.type == "disconnect" then
    print("lost connect..")
  end
end

function love.textinput(t)
    text = text .. t
end
 
function love.keypressed(key)
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        -- 获取一个字符占据的字节数
        local byteoffset = utf8.offset(text, -1)
 
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            -- sub 是按照字节操作的
            text = string.sub(text, 1, byteoffset - 1)
        end
    elseif key == "return" then
        local peer = host:get_peer(1) -- 这个 peer 其实就是 server
        peer:send(text) -- same with  server:send(text)

        text = ""
    end
end
 
function love.draw()
    love.graphics.printf(msg, 0, 0, love.graphics.getWidth())    
    love.graphics.printf("type in：", 0, 20, love.graphics.getWidth())
    love.graphics.printf("echo：", 0, 40, love.graphics.getWidth())
    love.graphics.printf(text, 100, 20, love.graphics.getWidth())
    love.graphics.printf(echo, 100, 40, love.graphics.getWidth())
end