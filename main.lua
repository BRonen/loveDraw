local ffi = require("ffi")
ffi.cdef[[
typedef struct { uint8_t r, g, b; } color;
]]

local keys = {}
keys['e'] = function()
  for i=1,gridSize do
    Grid[i] = {0, 0, 0}
    print(i)
  end
end
keys['escape'] = function() love.event.push('quit') end
keys['n'] = function()
  pixelSize = pixelSize + 5
  boot()
end
keys['m'] = function()
  pixelSize = pixelSize - 5
  boot()
end
keys['q'] = function() Color = {0, 0, 0} end
keys['w'] = function() Color = {1, 1, 1} end
keys['a'] = function() Color = {1, 0, 0} end
keys['s'] = function() Color = {0, 1, 0} end
keys['d'] = function() Color = {0, 0, 1} end
  
width, height = love.window.getMode( )
pixelSize = 25

function love.load() --Declare function
  boot()
end

--dt is the delta time between tha last and current call of update()
function love.update(dt)
  if love.mouse.isDown(1) then 
    local index = coordsToPixel(love.mouse.getPosition())
    Grid[index].r = Color[1]
    Grid[index].g = Color[2]
    Grid[index].b = Color[3]
  end
  local touches = love.touch.getTouches( )
  for i, id in ipairs(touches) do
    local x, y = love.touch.getPosition(id)
    love.graphics.circle("fill", x, y, 20)
    local index = coordsToPixel(love.mouse.getPosition())
    Grid[index].r = Color[1]
    Grid[index].g = Color[2]
    Grid[index].b = Color[3]
  end
end

function love.draw()
  for i=1, gridSize do
    local x, y = indexToCoords(i)

    love.graphics.setColor({0.1 ,0.1 ,0.1})
    love.graphics.rectangle('line', x, y, width/rowSize, height/columnSize)
    
    love.graphics.setColor({Grid[i].r, Grid[i].g, Grid[i].b})
    love.graphics.rectangle('fill', x, y, width/rowSize, height/columnSize)
    
    print('FPS: ' .. love.timer.getFPS())
    print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb')
  end
end

function love.mousepressed(x, y, button, istouch)
end

function love.touchpressed( id, x, y, dx, dy, pressure )
end

function coordsToPixel(x, y)
  
  local index = (
    math.floor( y / pixelSize ) * rowSize
  ) + (
    math.floor( x / pixelSize )
  )
  
  return index + 1
end

function indexToCoords(index)
  index = index - 1
  local x = ( index % rowSize ) * pixelSize
  local y = math.floor( index / rowSize ) * pixelSize
  
  return x, y
end

function boot()
  Color = {0, 0, 0}
  print(pixelSize)
  rowSize = math.floor(width/pixelSize)
  columnSize = math.floor(height/pixelSize)
  gridSize = columnSize*rowSize

  Grid = ffi.new("color[?]", gridSize)
  for i=1,gridSize do
    Grid[i].r = 0
    Grid[i].g = 0
    Grid[i].b = 0
    --print(i)
  end
end

function love.keypressed(key)
  if keys[key] then keys[key]() end
end
