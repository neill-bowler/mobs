
-- Sheep by PilzAdam
all_colours = {"white", "grey", "black", "red", "yellow", "green", "cyan", "blue", "magenta", "orange", "violet", "brown", "pink", "dark_grey",  "dark_green"}

mobs:register_mob("mobs:sheep", {
	type = "animal",
	passive = true,
	hp_min = 8,
	hp_max = 10,
	armor = 200,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	visual = "mesh",
	mesh = "mobs_sheep.x",
	textures = {
		{"mobs_sheep_white.png"},
	},
	visual_size = {x=1,y=1},
	gotten_texture = {"mobs_sheep_shaved.png"},
	gotten_mesh = "mobs_sheep_shaved.x",
	makes_footstep_sound = true,
	sounds = {
		random = "mobs_sheep",
	},
	walk_velocity = 1,
	jump = true,
	drops = {
		{name = "mobs:meat_raw",
		chance = 1, min = 2, max = 3},
		{name = "wool:black",
		chance = 1, min = 1, max = 1},
	},
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		speed_normal = 15,		speed_run = 15,
		stand_start = 0,		stand_end = 80,
		walk_start = 81,		walk_end = 100,
	},
	follow = "farming:wheat",
	view_range = 5,
	replace_rate = 50,
	replace_what = {"default:grass_3", "default:grass_4", "default:grass_5", "farming:wheat_8"},
	replace_with = "air",
	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		local name = clicker:get_player_name()

		if item:get_name() == "farming:wheat" then
			-- take item
			if not minetest.setting_getbool("creative_mode") then
				item:take_item()
				clicker:set_wielded_item(item)
			end
			-- make child grow quicker
			if self.child == true then
				self.hornytimer = self.hornytimer + 10
				return
			end
			-- feed and tame
			self.food = (self.food or 0) + 1
			if self.food > 7 then
				self.food = 0
				if self.hornytimer == 0 then
					self.horny = true
				end
				self.gotten = false -- can be shaved again
				self.tamed = true
				-- make owner
				if not self.owner or self.owner == "" then
					self.owner = name
				end
				self.object:set_properties({
					textures = {"mobs_sheep.png"},
					mesh = "mobs_sheep.x",
				})
				minetest.sound_play("mobs_sheep", {
					object = self.object,
					gain = 1.0,
					max_hear_distance = 20,
					loop = false,
				})
			end
			return
		end

        if item:get_name() == "default:shears"
		and self.gotten == false
		and self.child == false then
			self.gotten = true -- shaved
			if self.colour == "" then
			    self.colour = "white"
			end
			if minetest.registered_items["wool:white"] then
				local pos = self.object:getpos()
				pos.y = pos.y + 0.5
				local obj = minetest.add_item(pos, ItemStack("wool:"..self.colour.." "..math.random(2,3)))
				if obj then
					obj:setvelocity({x=math.random(-1,1), y=5, z=math.random(-1,1)})
				end
				item:add_wear(650) -- 100 uses
				clicker:set_wielded_item(item)
			end
			self.object:set_properties({
				textures = {"mobs_sheep_shaved.png"},
				mesh = "mobs_sheep_shaved.x",
			})
		end
		
		minetest.chat_send_player(clicker:get_player_name(), "Object is "..item:get_name())
		for _, col in ipairs(all_colours) do
            if item:get_name() == "dye:"..col
		    and self.gotten == false
		    and self.child == false then
			    self.colour = col
			    self.object:set_properties({
				textures = {"mobs_sheep_"..self.colour..".png"},
			    })
			    -- take item
			    if not minetest.setting_getbool("creative_mode") then
				    item:take_item()
				    clicker:set_wielded_item(item)
			    end
			end
		end

		if item:get_name() == "mobs:magic_lasso"
		and clicker:is_player()
		and clicker:get_inventory()
		and self.child == false
		and clicker:get_inventory():room_for_item("main", "mobs:sheep") then

			-- pick up if owner
			if self.owner == name then
				clicker:get_inventory():add_item("main", "mobs:sheep")
				self.object:remove()
				item:add_wear(3000) -- 22 uses
				clicker:set_wielded_item(item)
			-- cannot pick up if not tamed
			elseif not self.owner or self.owner == "" then
				minetest.chat_send_player(name, "Not tamed!")
			-- cannot pick up if not tamed
			elseif self.owner ~= name then
				minetest.chat_send_player(name, "Not owner!")
			end
		end
	end,
})

mobs:register_spawn("mobs:sheep", {"default:dirt_with_grass", "ethereal:green_dirt"}, 20, 10, 15000, 1, 31000)

mobs:register_egg("mobs:sheep", "Sheep", "wool_white.png", 1)

-- shears (right click sheep to shear wool)
minetest.register_tool("mobs:shears", {
	description = "Steel Shears (right-click sheep to shear)",
	inventory_image = "mobs_shears.png",
})

minetest.register_craft({
	output = 'mobs:shears',
	recipe = {
		{'', 'default:steel_ingot', ''},
		{'', 'group:stick', 'default:steel_ingot'},
	}
})
