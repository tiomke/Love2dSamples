--[[
Gear joint
齿轮关节

只能连接 revolute 和\或 prismatic 关节。
注意删除依附的关节之前要先删除齿轮关节。


概念：
ratio 用于设置两者位移的比率，如果是转动关节和移动关节连接，需要考虑到角度单位跟长度单位的区别

方法：
joint1, joint2 = GearJoint:getJoints()
ratio = GearJoint:getRatio()
GearJoint:setRatio( ratio )
]]

--[[
	两个齿轮
]]

package.path = package.path ..';..\\..\\..\\_Lib\\?.lua'
bird = require "lovebird"

function love.load()
	bird.init()
	love.window.setMode(400, 400)
	world = love.physics.newWorld(0, 0, false)
	--
	gear1 = love.physics.newBody(world, 200, 300, "dynamic") -- body 的位置表示质心的位置
	local s = love.physics.newCircleShape(50)
	love.physics.newFixture(gear1, s)
	-- 齿轮1的固定位置
	local dot1 = love.physics.newBody(world, 200, 300, "static") -- body 的位置表示质心的位置
	local s = love.physics.newCircleShape(10)
	love.physics.newFixture(dot1, s)

	gear2 = love.physics.newBody(world, 300, 300, "dynamic")
	local s = love.physics.newCircleShape(50)
	love.physics.newFixture(gear2, s)
	-- 齿轮2的固定位置
	local dot2 = love.physics.newBody(world, 200, 300, "static") -- body 的位置表示质心的位置
	local s = love.physics.newCircleShape(10)
	love.physics.newFixture(dot2, s)

	local joint1 = love.physics.newRevoluteJoint(dot1, gear1, 200, 300) -- 跟先后顺序是有关系的，如果 dot1 和 gear1 换个位置就不工作了
	local joint2 = love.physics.newRevoluteJoint(dot2, gear2, 300, 300)

	local ratio = 1
	joint = love.physics.newGearJoint(joint1, joint2, ratio) --
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
	-- 根据圆心和角度计算圆上点的位置
	local x,y = gear1:getPosition()
	love.graphics.circle("line", x, y, 50)

	local j1,j2 = joint:getJoints()
	local angle = j1:getJointAngle()
	local x2 = x + math.cos(angle)*50
	local y2 = y + math.sin(angle)*50
	love.graphics.line(x, y, x2, y2)

	love.graphics.setColor(200, 200, 0, 255)
	local x,y = gear2:getPosition()
	love.graphics.circle("line", x, y, 50)

	-- local j1,j2 = joint:getJoints()
	local angle = j2:getJointAngle()
	local x2 = x + math.cos(angle)*50
	local y2 = y + math.sin(angle)*50
	love.graphics.line(x, y, x2, y2)
	-- love.graphics.polygon("fill",tri:getFixtureList()[1]:getShape():getPoints())
	-- love.graphics.setColor(200, 200, 0, 255)
	-- love.graphics.polygon("fill",rect:getWorldPoints(rect:getFixtureList()[1]:getShape():getPoints()))
	if msjoint then
		love.graphics.line(msjoint:getAnchors())
	end
end

function love.mousepressed(x, y)
 	msjoint = love.physics.newMouseJoint(gear2, x, y)
end

function love.mousereleased(x, y, button, isTouch)
 	msjoint:destroy()
	msjoint = nil
end


--[[
后记：
	在写的过程中，发现画圆可以携带segment参数，心想可以不需要画线来表现圆的转动了，然而没找到设置画圆设置角度的参数，白激动了。
	写完之后运行发现添加 mouse joint 上去，两个圆都可以被拖动，但是一个不能拖动另一个。我开始怀疑是不是anchor点的设置问题，
]]
