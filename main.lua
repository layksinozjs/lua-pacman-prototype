pacman = {
    x = 200,
    y = 300,
    speed = 300,
    radius = 53,
    angle = 0.2,
    angleDir = 1,
    targetx = nil,
    targety = nil
}



boxes = {}
local boxcount = 3


local font = love.graphics.newFont(36)
local normalfont = love.graphics.newFont(12)
 score = 0

function love.load()
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0, 0, 0)
    createboxes()

end

function createboxes()
boxes = {}
cancreateboxes = true
for i = 1, boxcount do
local box = {
	x = math.random(50,750),
	y = math.random(50,550),
	width = 68,
	height = 68,
	visible = true,
	eaten = false

}
table.insert(boxes,box)
end

end


function love.mousepressed(x, y, button)
    if button == 1 then
        pacman.targetx = x
        pacman.targety = y
    end
end

function love.update(dt)
    pacman.angle = pacman.angle + pacman.angleDir * 2 * dt
    
    if pacman.angle > 0.7 then
        pacman.angleDir = -1
    elseif pacman.angle < 0.1 then
        pacman.angleDir = 1
    end

    if pacman.targetx and pacman.targety then
        local dx = pacman.targetx - pacman.x
        local dy = pacman.targety - pacman.y
        local distance = math.sqrt(dx^2 + dy^2)
        
        if distance > 5 then
            local movex = (dx/distance) * pacman.speed * dt
            local movey = (dy/distance) * pacman.speed * dt
            pacman.x = pacman.x + movex
            pacman.y = pacman.y + movey
        else
            pacman.targetx = nil
            pacman.targety = nil
        end
    end
local allEaten = true
for i ,box in ipairs(boxes) do
if box.visible then
allEaten = false
local box_center_x = box.x + box.width/2
local box_center_y = box.y + box.height/2
local collision_dist = math.sqrt((pacman.x - box_center_x)^2 + (pacman.y - box_center_y)^2)

if collision_dist < pacman.radius + 25 then
    box.visible = false
    box.eaten = true
    score = score + 1
end

end
        
    end
    if allEaten and cancreateboxes and score < 30 then
    createboxes()
    elseif score >= 30 then
 cancreateboxes = false
    
 end
 allEaten = false
end

function love.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.arc("fill", pacman.x, pacman.y, pacman.radius, pacman.angle, 2*math.pi - pacman.angle)
    
    for i, box in ipairs(boxes) do
        if box.visible then
            love.graphics.setColor(0, 0, 1)
            love.graphics.rectangle("fill", box.x, box.y, box.width, box.height)
        end
    end
if cancreateboxes == false then
love.graphics.setColor(1,1,0)
love.graphics.setFont(font)
love.graphics.print("Congrats",50,70)
end
    love.graphics.setFont(normalfont)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Target: "..(pacman.targetx or "nil")..","..(pacman.targety or "nil"), 10, 10)
    love.graphics.print("Position: "..math.floor(pacman.x)..","..math.floor(pacman.y), 10, 30)
  love.graphics.print("Score: "..score, 10, 60)
end
