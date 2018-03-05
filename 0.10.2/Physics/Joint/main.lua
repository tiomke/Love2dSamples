-- 铰链，绳索，滑轮

function love.load()
	-- 设置多少像素表示1m
	love.physics.setMeter(64)
  local w,h = 400,400
  love.window.setMode(w, h)

	-- 创建一个世界
	world = love.physics.newWorld(0,9.8*64,true)
	-- 创建一个圆形作为球
	ball = {}
	ball.body = love.physics.newBody(world,250,50,"dynamic")
	ball.shape = love.physics.newCircleShape( 30 ) -- 绑形状
	ball.fixture = love.physics.newFixture( ball.body, ball.shape ) -- body 包含 fixture，fixture 包含 shape
	-- ball.fixture:setRestitution(0)

	ball2 = {}
	ball2.body = love.physics.newBody(world,150,50,"dynamic")
	ball2.shape = love.physics.newCircleShape( 30 ) -- 绑形状
	ball2.fixture = love.physics.newFixture( ball2.body, ball2.shape )
  ball2.fixture:setRestitution(1)

	joint = love.physics.newMotorJoint( ball.body, ball2.body, 0.5, true) --

	tri = {}
	tri.body = love.physics.newBody(world,250,100,"dynamic")
	tri.shape = love.physics.newPolygonShape( 0, 0, 100, 0, 100, 50)
	tri.fixture = love.physics.newFixture( tri.body, tri.shape )



	love.physics.newDistanceJoint( ball2.body, tri.body, 0, 0, 10, 10,false)

	-- 四周划出隐形的墙
	wall = {}
	wall.body = love.physics.newBody(world, w/2, h/2, "static")
	wall.shape1 = love.physics.newEdgeShape( -w/2, -h/2, w/2, -h/2 )
	wall.shape2 = love.physics.newEdgeShape( -w/2, -h/2, -w/2, h/2 )
	wall.shape3 = love.physics.newEdgeShape( -w/2, h/2, w/2, h/2 )
	wall.shape4 = love.physics.newEdgeShape( w/2, -h/2, w/2, h/2 )
	-- 一个 body 可以绑定多个 fixture
	love.physics.newFixture(wall.body, wall.shape1)
	love.physics.newFixture(wall.body, wall.shape2)
	love.physics.newFixture(wall.body, wall.shape3)
	love.physics.newFixture(wall.body, wall.shape4)
end

function love.update(dt)
	world:update(dt) -- 更新世界
end

function love.draw()
	-- 根据物理信息绘制图形
	love.graphics.setColor(0,0,255,255)
	love.graphics.circle("fill",ball.body:getX(),ball.body:getY(),ball.shape:getRadius())
	love.graphics.setColor(0,0,255,255)
	love.graphics.circle("fill",ball2.body:getX(),ball2.body:getY(),ball2.shape:getRadius())
	love.graphics.setColor(0,125,255,255)
	love.graphics.polygon("line",tri.body:getWorldPoints(tri.shape:getPoints()))

end

function love.keypressed(key, scancode, isrepeat)
  if key == "left" then
    ball2.body:applyLinearImpulse( -200, 0 )
  elseif key == "right" then
    ball2.body:applyLinearImpulse( 200, 0 )
  elseif key == "up"then
    ball.body:applyLinearImpulse(0,-200)
  elseif key == "down" then
    ball.body:applyLinearImpulse(0,200)
  elseif key == "d" then
    print(ball2.body:isAwake())
  end
end


--[[

joint = love.physics.newMotorJoint( body1, body2, correctionFactor, collideConnected ) -- collideConnected 两者是否发生碰撞
joint = love.physics.newDistanceJoint( body1, body2, x1, y1, x2, y2, collideConnected ) -- 使用之后两个对象的距离就会受到限制，虽然都会动，但是受到了约束



]]
