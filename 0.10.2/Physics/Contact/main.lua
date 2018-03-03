-- 1.一个 body 绑定多个 shape
-- 2.contact的生命周期和对应回调函数的调用顺序


-- 一个板和一个球
function love.load()

	-- 设置多少像素表示1m
	love.physics.setMeter(64)
  local w,h = 400,400
  love.window.setMode(w, h)

	-- 创建一个世界
	world = love.physics.newWorld(0,9.8*64,true)
	-- 创建一个圆形作为球
	ball = {}
	ball.body = love.physics.newBody(world,250,50,"static")
	ball.shape = love.physics.newCircleShape( 30 ) -- 绑形状
	ball.fixture = love.physics.newFixture( ball.body, ball.shape ) -- body 包含 fixture，fixture 包含 shape

	ball2 = {}
	ball2.body = love.physics.newBody(world,150,50,"dynamic")
	ball2.shape = love.physics.newCircleShape( 30 ) -- 绑形状
	ball2.fixture = love.physics.newFixture( ball2.body, ball2.shape )
  ball2.fixture:setRestitution(1)


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

  -- 设置碰撞的回调
  beginContact =function  (...)
    print("beginContact",...)
  end
  endContact =function  (...)
    print("endContact",...)
  end
  preSolve =function  (...)
    print("preSolve",...)
  end
  postSolve =function  (...)
    print("postSolve",...)
  end
  world:setCallbacks( beginContact, endContact, preSolve, postSolve )
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
world = love.physics.newWorld( xg, yg, sleep ) -- x 方向的重力，y方向的重力，是否允许物体 sleep
body = love.physics.newBody( world, x, y, type ) -- type 有 static dynamic 和 kinematic 三种
fixture = love.physics.newFixture( body, shape, density ) -- density 大概是绑的紧密程度我猜

]]
--[[ 某次完全弹性碰撞的值
 postSolve 的回调参数 fixture1, fixture2, contact, normal_impulse1, tangent_impulse1, normal_impulse2, tangent_impulse2

-- 例一
beginContact	Fixture: 0x7fd6904a8fa0	Fixture: 0x7fd6904b6970	Contact: 0x7fd690544d10
preSolve	Fixture: 0x7fd6904a8fa0	Fixture: 0x7fd6904b6970	Contact: 0x7fd690544d10
postSolve	Fixture: 0x7fd6904a8fa0	Fixture: 0x7fd6904b6970	Contact: 0x7fd690544d10	894.73986816406	0
preSolve	Fixture: 0x7fd6904a8fa0	Fixture: 0x7fd6904b6970	Contact: 0x7fd690544d10
postSolve	Fixture: 0x7fd6904a8fa0	Fixture: 0x7fd6904b6970	Contact: 0x7fd690544d10	0	0
endContact	Fixture: 0x7fd6904a8fa0	Fixture: 0x7fd6904b6970	Contact: 0x7fd690544d10

-- 例二
beginContact	Fixture: 0x7fd6904a8fa0	Fixture: 0x7fd6904b6970	Contact: 0x7fd69067d130
preSolve	Fixture: 0x7fd6904a8fa0	Fixture: 0x7fd6904b6970	Contact: 0x7fd69067d130
postSolve	Fixture: 0x7fd6904a8fa0	Fixture: 0x7fd6904b6970	Contact: 0x7fd69067d130	899.59381103516	0
endContact	Fixture: 0x7fd6904a8fa0	Fixture: 0x7fd6904b6970	Contact: 0x7fd69067d130

可以看出来，小球和底部刚开始接触的时候会触发 beginContact ,不再接触的时候会触发 endContact,在开始接触和不再接触之间就会在world:update 每次调用的时候不断调用 preSolve 和postSolve 两个回调。除非小球进入睡眠，回调才会停止。
测试过程还发现，即使初始状态一样，小球与底发生弹性碰撞的时候产生的力 normal_impulse1 的值也是不同的，我猜可能是因为world:update() 调用到的时间有关，如果时间完全一致，那么可能会是一样的结果。
]]
