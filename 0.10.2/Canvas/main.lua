-- 设置两个画布，根据键盘数据改变绘制内容
--
function love.load(arg)
  -- r8 表示单通道（红色通道 8bpp bit per pixel）
  local w,h = 300,300
  love.window.setMode(w, h)
  canvas1 = love.graphics.newCanvas(w, h,"r8") -- 这个模式非红即黑
  canvas2 = love.graphics.newCanvas(w, h, "rgba8") -- 正常颜色

  love.graphics.setLineWidth(5)
  -- 设置画布1
  love.graphics.setCanvas(canvas1)
  love.graphics.setBackgroundColor(44, 22, 120,255)
  love.graphics.setColor(123,11,555)
  love.graphics.circle("fill", w/2, h/2, 50)


  -- 设置画布2
  love.graphics.setCanvas(canvas2)
  love.graphics.setBackgroundColor(44, 22, 120,255)
  love.graphics.setColor(0,11,555)
  love.graphics.circle("line", w/2, h/2, 50)

  -- 重置
  love.graphics.setCanvas()

end

function love.draw()
  love.graphics.setColor(255,255,255)

  if flag then
    love.graphics.draw(canvas1)
  else
      love.graphics.draw(canvas2)
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'f' then
    flag = not flag
  end
end

-- 关于 CanvasFormat https://love2d.org/wiki/CanvasFormat
-- normal 表示默认的格式 （等价于 rgba8 或者 srgb，srgb 涉及到一个概念 gamma-correct ）
-- hdr (High Dynamic Range，等价于 rgba16f)
-- 16 bpp 的 RGB 和 RGBA 比 32 bpp 的 RGBA 格式少占用一半的 VRAM（显存），但是图片质量差很多。
-- HDR或者浮点存储格式在处理 pixel shader 的时候很有用。例如可以用来处理爆炸特效，例如可以在纹理上存储颜色意外的信息，提供渲染的数据。
--（计算机表示各通道颜色的范围是0-1，而现实中颜色范围是超过这个范围的，人眼可以通过虹膜调节，计算机不能。HDR 允许存储的颜色信息超过0-1，把 HDR 转换为LDR的过程称为 tone mapping，tone mapping 有各种不同的算法。）
-- [基于物理的渲染—HDR Tone Mapping](https://blog.uwa4d.com/archives/Study_HDRToneMapping.html)
-- sRGB 只能用于 gamma-correct 渲染
-- 不是每个系统都能支持所有的格式的，创建画布前先用  love.graphics.getCanvasFormats 看看有哪些可用的格式
