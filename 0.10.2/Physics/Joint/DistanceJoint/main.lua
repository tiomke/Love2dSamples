-- 参考下看看 https://github.com/ArchAngel075/loveballs/tree/ce8336fb51e89c9dc706979dc2007234978bb948
--[[
Distance Joint
距离关节

Joint 必须作用在两个 Body 之间
设置 Distance Joint 的时候，Body 的位置应当就是符合要设定的距离的位置。
创建 Distance Joint 的两个锚点使用的是 世界坐标。锚点的位置分别在两个 Body 之中。
锚点间的距离就是限制的距离。
限制的距离可以是绝对的，也可以像弹簧一样拉伸。

Damping Ratio 阻尼系数 0-1 的值，1 表示无法震荡（具体来讲，当小球从非复原位置运动到复原位置的过程中，会经过复原位置向另一方向移动，并来回震荡）
Frequency 频率 一般来说小于帧率的一半，帧率 60 Hz 的话，频率就要小于 30 Hz ，这是由奈奎斯特频率决定的 （具体的表现为，值越小，可以拉伸的幅度就越大，值越大，可以拉伸的范围就越小）
Length 长度

]]

--[[
无重力环境，其中一个物体不会动，另一个初始位置可以通过拖拽移动。demo 分停止和运动两种状态，停止状态下可以设置各种参数。

控制：
s：start/stop
d：提高阻尼系数
f：提高频率
同时按住 ctrl 则反向变化
]]
package.path = package.path ..';..\\..\\..\\_Lib\\?.lua'
local bird = require "lovebird"


function Reset ()
  -- body1
  body1 = {}
  body1.Body = love.physics.newBody(world, 100, 100, "static")
  body1.Shape = love.physics.newCircleShape(20)
  love.physics.newFixture(body1.Body, body1.Shape) -- 正常情况下 fixture不用存，这个对象的生命周期与body一致

  -- body2
  body2 = {}
  body2.Body = love.physics.newBody(world, 200, 200, "dynamic")
  body2.Shape = love.physics.newCircleShape(20)
  love.physics.newFixture(body1.Body, body1.Shape)

  body3 = {}
  body3.Body = love.physics.newBody(world, 300, 300, "static")
  body3.Shape = love.physics.newCircleShape(20)
  love.physics.newFixture(body3.Body, body3.Shape) -- 正常情况下 fixture不用存，这个对象的生命周期与body一致

  -- joint
  joint = love.physics.newDistanceJoint(body1.Body, body2.Body, 100, 100, 200, 200)

  joint:setLength(100*math.sqrt(2)) -- 设置之后会立马达到该距离
end

DampingRatio = 0.5
Frequency = 10
function Set()
  joint:setDampingRatio(DampingRatio)
  joint:setFrequency(Frequency)
end

function love.load()
  love.window.setMode(400, 400)
  love.physics.setMeter(98)-- TODO
  world = love.physics.newWorld(0, 0, false)


  Reset()
end

function love.update(dt)
  bird.update()
  world:update(dt)
	if msjoint then
		msjoint:setTarget(love.mouse.getPosition())
	end
end

function love.draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("DampingRatio:"..DampingRatio, 10, 0)
  love.graphics.print("Frequency:"..Frequency, 10, 10)
  love.graphics.circle("fill", body1.Body:getX(), body1.Body:getY(), body1.Shape:getRadius())
  love.graphics.circle("fill", body2.Body:getX(), body2.Body:getY(), body2.Shape:getRadius())
  love.graphics.circle("fill", body3.Body:getX(), body3.Body:getY(), body3.Shape:getRadius())
	love.graphics.setColor(200, 200, 0, 255)
	love.graphics.line(joint:getAnchors())
end


keymap = {
  s = function (b)
    if b then
      Reset()
    end
    Set()
  end,
  d = function(b)
    b = b and -0.1 or 0.1
    DampingRatio = math.min(1,DampingRatio + b)
    DampingRatio = math.max(0,DampingRatio)
		Set()
  end,
  f = function (b)
    b = b and -5 or 5
    Frequency = math.min(60,Frequency + b)
    Frequency = math.max(1,Frequency)
		Set()
  end
}
function love.keypressed(key, scancode, isrepeat)
  f = keymap[key]
  if f then
    f(love.keyboard.isDown("lctrl"))
  end
end

function love.mousepressed(x, y)
 	msjoint = love.physics.newMouseJoint(body2.Body, body2.Body:getX(), body2.Body:getY())
end

function love.mousereleased(x, y, button, isTouch)
 	msjoint:destroy()
	msjoint = nil
end

--[[
后记：
遇到了好几个坑，首先，需要通过 mousejoint 移动小球，小球的运动才会符合预期，直接设置位置会破坏物理计算。
还有一个坑是 mousejoint 在不用的时候要销毁掉，不然的话小球会一直向着鼠标的位置移动。
]]
