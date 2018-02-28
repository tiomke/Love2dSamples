-- 引力转换

function love.load()
  --
  local w,h = 400,400
  love.window.setMode(w,h)
  love.physics.setMeter(64)
  world = love.physics.newWorld(0, 0,true) -- 默认无重力，第三个参数设置为true的时候，如果没有物体没有收到力的作用就会进入sleep。。
  -- 天花板
  ceilboard = {}
  ceilboard.body = love.physics.newBody(world, w/2, h/12,"static")
  ceilboard.shape = love.physics.newRectangleShape(w, h/6)
  ceilboard.fixture = love.physics.newFixture(ceilboard.body, ceilboard.shape) --

  floorboard = {}
  floorboard.body = love.physics.newBody(world, w/2, 11*h/12,"static")
  floorboard.shape = love.physics.newRectangleShape(w, h/6)
  floorboard.fixture = love.physics.newFixture(floorboard.body, floorboard.shape)

  -- obj
  obj = {}
  obj.body = love.physics.newBody(world, w/2, h/2,"dynamic")
  obj.shape = love.physics.newRectangleShape(20, 60)
  obj.fixture = love.physics.newFixture(obj.body, obj.shape)
  obj.fixture:setDensity(5) -- 受同样一个力的作用下，密度越大，物体的移动速度就越慢。对于 static 的物体来说，密度显然没啥用
  obj.fixture:setRestitution(1) -- 0 表示没有弹性，1 表示完全弹性碰撞
  -- obj.body:applyLinearImpulse( 0, 20 ) -- 施加单次的力量
end

function love.update(dt)
  world:update(dt)
end

function love.draw()
  love.graphics.setColor(125, 125, 125, 255)
  love.graphics.polygon("fill",ceilboard.body:getWorldPoints(ceilboard.shape:getPoints()))
  love.graphics.setColor(1, 55, 55, 255)
  love.graphics.polygon("fill",obj.body:getWorldPoints(obj.fixture:getShape():getPoints()))
  love.graphics.setColor(125, 125, 125, 255)
  love.graphics.polygon("fill",floorboard.body:getWorldPoints(floorboard.shape:getPoints()))
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'up' then
    world:setGravity(0,-250)
    if not obj.body:isAwake() then -- 如果在sleep就叫醒
      obj.body:setAwake(true)
    end
  elseif key == 'down' then
    world:setGravity(0,250)
    if not obj.body:isAwake() then
      obj.body:setAwake(true)
    end
  end
end
