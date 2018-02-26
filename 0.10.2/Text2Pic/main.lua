-- 分成两个部分，一个部分涂颜色，一个部分扣文字
function love.load()
	file = io.open("src.txt", "r")
	str = file:read("*a")
	local sampleFunc = function ( gap )
		drawdata = {}
		img = love.graphics.newImage("img.png")
		local data = img:getData()
		local w,h = img:getWidth(),img:getHeight()
		-- local w,h = 200,200
		local cnt = 0
		for i=1,h-gap,gap do
			local d = {}
			for j=1,w-gap,gap do

				local r, g, b, a = data:getPixel( j,i )
				if a >128 and r+g+b < 20 then
					table.insert(d,1)
					cnt = cnt + 1
				else
					table.insert(d,0)
				end
			end
			table.insert(drawdata,d)
		end
		return drawdata,cnt
	end
	bigsample,bigcnt = sampleFunc(35)
	smallsample,smallcnt = sampleFunc(35)
	
	print(smallcnt)
	print(str)
	--2113

	-- 在中间位置插入@
	-- 每隔XX个位置插入XX个@
	-- n个数，m个空
	-- math.floor(m/n) 
	flag = math.floor(smallcnt/str:len())
	print(flag)
	font = love.graphics.newFont( 25 )
	love.graphics.setFont(font)

	canvas = love.graphics.newCanvas()
	canvas:renderTo(function()
		love.graphics.setBackgroundColor(38,50,56)

		-- draw back
		love.graphics.setColor(255,95,86)
		local cnt = 1
		for i=1,#bigsample do
			d = bigsample[i]
			for j=1,#d do
				if d[j] == 1 then
					love.graphics.circle( "fill", j*16, i*16, math.random(4,9) )
				end
			end
		end
		-- draw text
		-- love.graphics.setColor(121,153,203)
		love.graphics.setColor(237,237,237)
		local cnt = 1
		for i=1,#smallsample do
			d = smallsample[i]
			for j=1,#d do
				if d[j] == 1 then
					local sign = ' '
					if cnt % flag == 0 then
						local t = math.floor(cnt/flag)
						sign = str:sub(t,t) or 'n'
						love.graphics.print(sign,j*16,i*16)
						-- love.graphics.printf(sign,j*16,i*16,20,"center",nil,1)
					else
						-- love.graphics.circle( "fill", j*16+10, i*16+10, 4 )
					end
					cnt = cnt + 1
				end
			end
		end
	end)
end

function love.draw()
	love.graphics.draw(canvas)
end

