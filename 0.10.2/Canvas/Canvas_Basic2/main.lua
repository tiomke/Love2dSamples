local canvas = love.graphics.newCanvas()
function love.update()
    canvas:renderTo(function()
        love.graphics.setColor(love.math.random(255), 0, 0);
        love.graphics.line(0, 0, love.math.random(0, love.graphics.getWidth()), love.math.random(0, love.graphics.getHeight()));
    end);
end
 
function love.draw()
    love.graphics.setColor(255, 255, 255);
    love.graphics.draw(canvas);
end