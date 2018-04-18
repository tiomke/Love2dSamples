--[[
Weld joint
焊接关节

用来创建可以破坏的结构，焊接链接得到的一个 body 链是会弯曲的。

创建可以破坏的 body ，比较好的方法是一个 body 挂很多 fixture ，破坏的时候删除 fixture 并新建一个 body 。


概念：
damping ratio 弹性系数，这个值越低，连接点松动越厉害
freq 这个值越高，body 间的连接就越坚挺，如果值很小的话，直接就软下去了。

方法：
ratio = WeldJoint:getDampingRatio()
freq = WeldJoint:getFrequency()
WeldJoint:setDampingRatio( ratio )
WeldJoint:setFrequency( freq )
]]

--[[
	三个body焊接在一起
]]

package.path = package.path ..';..\\..\\..\\_Lib\\?.lua'
bird = require "lovebird"

function love.load()
	bird.init()
	love.window.setMode(400, 400)
	world = love.physics.newWorld(0, 0, false)
	--

	rect1 = love.physics.newBody(world, 100,200, "static") -- body 的位置表示质心的位置
	local s = love.physics.newRectangleShape(200, 20)
	love.physics.newFixture(rect1, s)

	rect2 = love.physics.newBody(world, 250, 200, "dynamic")
	local s = love.physics.newRectangleShape(100, 20)
	love.physics.newFixture(rect2, s)


	joint = love.physics.newWeldJoint(rect1, rect2, 200, 200)
	joint:setDampingRatio(0.1)
	joint:setFrequency(0.8)
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
	love.graphics.polygon("fill",rect1:getWorldPoints(rect1:getFixtureList()[1]:getShape():getPoints()))

	love.graphics.setColor(200, 200, 0, 255)
	love.graphics.polygon("fill",rect2:getWorldPoints(rect2:getFixtureList()[1]:getShape():getPoints()))

	if msjoint then
		love.graphics.line(msjoint:getAnchors())
	end
end

function love.mousepressed(x, y)
 	msjoint = love.physics.newMouseJoint(rect2, x, y)
end

function love.mousereleased(x, y, button, isTouch)
 	msjoint:destroy()
	msjoint = nil
end


--[[
后记：
	出现了一次失误，忘记在绘制多边形的时候要先把 shape 的点通过 getWorldPoints 转换成世界坐标系。
]]
