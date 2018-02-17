local Vector = require("libs.vector")
local Wave   = require("libs.wave")

local World = require("src.world")

local Object = require("src.classes.object")
local Cube   = require("src.classes.cube")

local o = Object({
   position = Vector(100, 100),
   velocity = Vector(20, 20),
   size     = Vector(64, 64),

   hasBody = true,
   dynamic = true,
})

Object({
   position = Vector(100, 400),
   velocity = Vector(0, 0),
   size     = Vector(300, 50),

   hasBody = true,
   dynamic = false,
})

local cube = Cube({
   position = Vector(200, 200),
   size = Vector(48, 48),

   hasBody = true,
   dynamic = true,

   sprite = love.graphics.newImage("assets/cube.png"),
})

local Game = {}

function Game:init()
   love.graphics.setBackgroundColor(30, 30, 30)

   Game.camera = require("src.states.game.camera")
   Game.camera:zoomTo(1)

   Game.flux = require("src.states.game.flux")

   Game.music = Wave:newSource("music/boss_song_1.wav", "static")
   Game.batch = require("src.states.game.batch")

   Game.music:setIntensity(20)
   Game.music:setVolume(0)
   Game.music:setBPM(70)
   Game.music:onBeat(function()
      cube:move()
   end)

   Game.music:play(true)
end

function Game:update(propagate, dt)
   for i = 1, Object.dyanmicList.size do
      Object.dyanmicList:get(i):update(dt)
   end

   Game.camera:lookAt(o.position.x, o.position.y)

   Game.flux:update(dt)
   Game.music:update(dt)

   propagate(dt)
end

function Game:draw(propagate)
   Game.camera:attach()
      love.graphics.setColor(255, 255, 255)
      for i = 1, Object.list.size do
         Object.list:get(i):draw()
      end

      Game.batch.render()

      love.graphics.setColor(225, 30, 30)
      local items, len = World:getItems()
      for i = 1, len do
         local x, y, w, h = World:getRect(items[i])
         love.graphics.rectangle("line", x, y, w, h)
      end
   Game.camera:detach()

   propagate()
end

return Game
