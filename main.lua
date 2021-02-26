
local ffi = require("ffi")

ffi.cdef([[
typedef struct { uint8_t r, g, b; } color;
]])

 local Debug = true
 local WindowWidth, WindowHeight = love.window.getMode( )
 local PixelSize = 25

 local ColumnSize, RowSize, GridSize

 local Color = {0, 0, 0}

 local Grid = {}

function love.load()
  boot()
end

function boot()
  ColumnSize = math.floor( WindowHeight / PixelSize )
  RowSize = math.floor( WindowWidth / PixelSize )
  GridSize = ColumnSize * RowSize
  
  Grid = ffi.new("color[?]", GridSize)
  for i = 1, GridSize do
    Grid[i].r = 0
    Grid[i].g = 0
    Grid[i].b = 0
    
  end
end


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
  for i = 1, GridSize do
    local x, y = indexToCoords(i)

    love.graphics.setColor({0.1 ,0.1 ,0.1})
    love.graphics.rectangle('line', x, y, RowSize, ColumnSize)
    
    love.graphics.setColor({Grid[i].r, Grid[i].g, Grid[i].b})
    love.graphics.rectangle('fill', x, y, RowSize, ColumnSize)
  end
  
  if Debug then
    love.graphics.setColor({1 ,1 ,1})
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10)
    love.graphics.print('Memory usage: ' .. math.floor(collectgarbage 'count') .. 'kb', 10, 30)
  end
end

function love.mousepressed(x, y, button, istouch)
end

function love.touchpressed( id, x, y, dx, dy, pressure )
end

function coordsToPixel(x, y)
  
  local index = (
    math.floor( y / PixelSize ) * RowSize
  ) + (
    math.floor( x / PixelSize )
  )
  
  return index + 1
end

function indexToCoords(index)
  index = index - 1
  local x = ( index % RowSize ) * PixelSize
  local y = math.floor( index / RowSize ) * PixelSize
  
  return x, y
end

function love.keypressed(key)
  if keys[key] then keys[key]() end
end

keys = {}
keys['e'] = function() --erase grid
  for i=1,gridSize do
    Grid[i] = {0, 0, 0}
    print(i)
  end
end

keys['space'] = function() Debug = not Debug end

keys['escape'] = function() love.event.push('quit') end

keys['n'] = function()
  PixelSize = PixelSize + 5
  boot()
end
keys['m'] = function()
  PixelSize = PixelSize - 5
  boot()
end

keys['q'] = function() Color = {0, 0, 0} end --black
keys['w'] = function() Color = {1, 1, 1} end --white
keys['a'] = function() Color = {1, 0, 0} end --red
keys['s'] = function() Color = {0, 1, 0} end --geeen
keys['d'] = function() Color = {0, 0, 1} end --blue
