function get_config()
   return {
      tile_size=64
   }
end

function love.load()
   local screen_width, screen_height = love.graphics.getDimensions()
   game_config = get_config()
   game_constants = {
      horizontal_tile_count=math.ceil(screen_width / game_config.tile_size) + 1,
      vertical_tile_count=math.ceil(screen_height / game_config.tile_size) + 1,
      world_size=bit.lshift(1, 10),
   }
   game_state = {
      font=love.graphics.getFont(),
      screen_width=screen_width,
      screen_height=screen_height,
      position={
	 x=0,
	 y=0,
      },
      offset={
	 x=0,
	 y=0,
      },
   }
end

function draw_debug_overlay(game_state)
   text = love.graphics.newText(game_state.font)
   height = 0
   
   text:add("W: " .. tostring(game_state.screen_width))
   height = height + text:getHeight()
   text:add("H: " .. tostring(game_state.screen_height), 0, height)
   height = height + text:getHeight()
   text:add("PX: " .. tostring(game_state.position.x), 0, height)
   height = height + text:getHeight()
   text:add("PY: " .. tostring(game_state.position.y), 0, height)
   height = height + text:getHeight()
   text:add("OX: " .. tostring(game_state.offset.x), 0, height)
   height = height + text:getHeight()
   text:add("OY: " .. tostring(game_state.offset.y), 0, height)
   height = height + text:getHeight()
   
   love.graphics.draw(text, 0, 0)
end

function love.draw()
   draw_debug_overlay(game_state)
   for i=1,game_constants.horizontal_tile_count * game_constants.vertical_tile_count do
      local x_offset = game_state.offset.x
      local y_offset = game_state.offset.y
      
      local x = (((i - 1) % game_constants.horizontal_tile_count) * game_config.tile_size) - x_offset
      local y = (math.floor((i - 1) / game_constants.horizontal_tile_count) * game_config.tile_size) - y_offset
      love.graphics.rectangle("line", x, y, game_config.tile_size, game_config.tile_size)
   end
end

function love.update()
   local x_offset = game_state.offset.x + 1
   local y_offset = game_state.offset.y + 1

   if x_offset >= game_config.tile_size then
      game_state.offset.x = x_offset - game_config.tile_size
      local x_position = game_state.position.x + 1

      if x_position >= game_constants.world_size then
	 game_state.position.x = x_position - game_constants.world_size
      else
	 game_state.position.x = x_position
      end
   elseif x_offset < 0 then
      game_state.offset.x = x_offset + game_config.tile_size
      local x_position = game_state.position.x - 1

      if x_position <= 0 then
	 game_state.position.x = x_position + game_constants.world_size
      else
	 game_state.position.x = x_position
      end
   else
      game_state.offset.x = x_offset
   end

   if y_offset >= game_config.tile_size then
      game_state.offset.y = y_offset - game_config.tile_size
      local y_position = game_state.position.y + 1

      if y_position >= game_constants.world_size then
	 game_state.position.y = y_position - game_constants.world_size
      else
	 game_state.position.y = y_position
      end
   elseif y_offset < 0 then
      game_state.offset.y = y_offset + game_config.tile_size
      local y_position = game_state.position.y - 1

      if y_position <= 0 then
	 game_state.position.y = y_position + game_constants.world_size
      else
	 game_state.position.y = y_position
      end	 
   else
      game_state.offset.y = y_offset
   end
end

