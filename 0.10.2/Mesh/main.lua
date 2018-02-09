function love.load()
    image = love.graphics.newImage("pig.png")
    local w,h = image:getDimensions()
 
    -- We want to make a Mesh with 1 vertex in the middle of the image, and 4 at the corners.
    local vertices = {
        {w/6, h/6, 0.5, 0.5, 255,   0,   0}, -- Center vertex, with a red tint.
        {0,   0,   0,   0,   255, 255, 255}, -- Top left.
        {w,   0,   1,   0,   255, 255, 255}, -- Top right.
        {w,   h,   1,   1,   255, 255, 255}, -- Bottom right.
        {0,   h,   0,   1,   255, 255, 255}, -- Bottom left.
    }
 

    -- But there's a problem! The drawn mesh will have a big triangle missing on its left side.
    -- This is because, in the default mesh draw mode ("fan"), the vertices don't "loop": the top left vertex (#2) is unconnected to the bottom left one (#5).
    mesh = love.graphics.newMesh(vertices)
    -- mesh:setDrawRange(1,3)
    print(mesh:getDrawRange())
    mesh:setTexture(image)
 
    -- We could copy/paste the second vertex onto the end of the table of vertices.
    -- But instead we can just change the vertex map!
    mesh:setVertexMap(1,2, 3, 4, 5, 2)
    -- print(mesh:getDrawRange())
end
 
function love.draw()
    love.graphics.draw(mesh, 0, 0)
end