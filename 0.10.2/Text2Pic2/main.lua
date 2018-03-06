-- 分成两个部分，一个部分涂颜色，一个部分扣文字

require "utf" -- 文件里面有数字好像加载会出错。。不知道为什么

BigSampleRate = 18
SmallSampleRate = 18
FontName = "STHUPO.TTF"
ImgName = "img.png" 

function love.load()
	file = io.open("src.txt", "r")
	str = file:read("*a")
	local sampleFunc = function ( gap )
		drawdata = {}
		img = love.graphics.newImage(ImgName)
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
	bigsample,bigcnt = sampleFunc(BigSampleRate)
	smallsample,smallcnt = sampleFunc(SmallSampleRate)
	

	flag = math.floor(smallcnt/string.utf8len(str))
	font = love.graphics.newFont(FontName, 20 )
	love.graphics.setFont(font)

	canvas = love.graphics.newCanvas()
	canvas:renderTo(function()
		love.graphics.setBackgroundColor(38,50,56)

		-- draw back
		-- love.graphics.setColor(255,95,86)
		love.graphics.setColor(255,255,255,255)
		local cnt = 1
		for i=1,#bigsample do
			d = bigsample[i]
			for j=1,#d do
				if d[j] == 1 then
					love.graphics.circle( "fill", j*16+8, i*16+8, math.random(4,9) )
				end
			end
		end
		-- draw text
		-- love.graphics.setColor(121,153,203)
		-- love.graphics.setColor(237,237,237)
		love.graphics.setColor(122,50,23)
		local cnt = 1
		for i=1,#smallsample do
			d = smallsample[i]
			for j=1,#d do
				if d[j] == 1 then
					local sign = ' '
					if cnt % flag == 0 then
						local t = math.floor(cnt/flag)
						sign = str:utf8sub(t,t) or 'n'
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
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(canvas)
end

