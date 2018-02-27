-- 使用 SpriteBatch 可以提高显卡使用效率，使游戏更流畅

function love.load(arg)
  local img = love.graphics.newImage("img.png")
  spriteBatch = love.graphics.newSpriteBatch(img, 1000, "dynamic")
  spriteBatch:add(50,50)
  spriteBatch:setColor(255,0,255,255)
  spriteBatch:add(100,100)
end

function love.draw()
  love.graphics.draw(spriteBatch, 0, 0)
end


-- SpriteBatchUsage
-- 用于优化数据存储和访问
-- dynamic 对象的数据会在生命期内会依时而变
-- static 对象在最初的精灵制定后就不再发生变化
-- stream 对象的数据在每次绘制之间都会发生变化
-- 这里的对象是指 SpriteBatch 对象


-- SpriteBatch:attachAttribute() -- TODO 有待了解
-- SpriteBatch:add() -- 把一个精灵添加到 batch 上（实际上相当于提供一个 transform 信息）
-- SpriteBatch:set() -- 更换 batch 上的精灵，也可以设置 quad
-- SpriteBatch:clear() -- 从 buffer 中移除所有精灵
-- SpriteBatch:flush() -- 把改动后的数据立马送显卡
-- SpriteBatch:getCount() -- 获取当前的 SpriteBatch 对象数量
-- SpriteBatch:setBufferSize() -- SpriteBatch 可以拥有的最大精灵数量
-- SpriteBatch:getBufferSize() --
-- SpriteBatch:setColor() -- 设置颜色，下次 add 或者 set 的时候会生效
-- SpriteBatch:getColor() --
-- SpriteBatch:setTexture() -- 设置用于绘制精灵的纹理
-- SpriteBatch:getTexture()
