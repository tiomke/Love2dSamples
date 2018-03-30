--[[
Revolute Joint
转动关节

相连的两个物体会绕着锚点旋转

概念：
limit 可以限制 joint 的转动角度，lower limit 和 uppper limit 之间必须包含 0
motor torque 电机扭矩，一般来说功率恒定情况下，扭矩越大，转速越小。定义了扭矩和速度，就相当于定义了功率。
motor speed

给 joint 施加一个微小的扭矩和速度 0 ，可以模拟 joint 的摩擦力。
使用的角度单位为弧度

方法：
get/setLimits
has/setLimitsEnabled
is/setMotorEnabled
get/setLowerLimit
get/setUpperLimit
get/setMaxMotorTorque
get/setMotorSpeed
getMotorTorque
getJointAngle
getJointSpeed
]]

--[[
画个三角形和长方形，三角形固定，长方形左右摇摆。
]]

package.path = package.path ..';..\\..\\..\\_Lib\\?.lua'
bird = require "lovebird"

function love.load()
	bird.init()
	love.window.setMode(400, 400)
	world = love.physics.newWorld(0, 0, false)
	--
	tri = love.physics.newBody(world, 200, 300, "static") -- body 的位置表示质心的位置
	local s = love.physics.newPolygonShape(200, 200, 300, 350, 100,350)
	love.physics.newFixture(tri, s)

	rect = love.physics.newBody(world, 200, 250, "dynamic")
	local s = love.physics.newRectangleShape(100,30)
	love.physics.newFixture(rect, s)

	joint = love.physics.newRevoluteJoint(tri, rect, 200, 250)
	-- joint:setUpperLimit(1)
	-- joint:setLowerLimit(-1)
	-- joint:setLimitsEnabled(true)
	joint:setMotorEnabled(true)
	joint:setMotorSpeed(100)
	joint:setMaxMotorTorque(1000) -- 这个值越大，能够达到的转速越大
end

function love.update(dt)
  bird.update()
	world:update(dt)
	if msjoint then
		msjoint:setTarget(love.mouse.getPosition())
	end
end

function love.draw()

	love.graphics.setColor(200, 0, 200, 255)
	love.graphics.polygon("fill",tri:getFixtureList()[1]:getShape():getPoints())
	love.graphics.setColor(200, 200, 0, 255)
	love.graphics.polygon("fill",rect:getWorldPoints(rect:getFixtureList()[1]:getShape():getPoints()))
	if msjoint then
		love.graphics.line(msjoint:getAnchors())
	end
end

function love.mousepressed(x, y)
 	msjoint = love.physics.newMouseJoint(rect, x, y)
end

function love.mousereleased(x, y, button, isTouch)
 	msjoint:destroy()
	msjoint = nil
end


--[[
后记：踩了几个坑
	1.通过shape 获取到的点采用的是本地坐标，根据本地坐标绘制的图片，看起来一直都不动，实际上是有在旋转的。。
	2.没有添加 world 的 update ，导致世界不会运动
]]
