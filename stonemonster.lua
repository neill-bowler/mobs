
-- Stone Monster

mobs:register_mob("mobs:stone_monster", {
	type = "monster",
	hp_min = 12,
	hp_max = 35,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1.9, 0.4},
	visual = "mesh",
	mesh = "mobs_stone_monster.x",
	--textures = {"mobs_stone_monster.png"},
	available_textures = {
		total = 1,
		texture_1 = {"mobs_stone_monster.png"},
	},
	visual_size = {x=3, y=2.6},
	makes_footstep_sound = true,
	view_range = 10,
	walk_velocity = 0.5,
	run_velocity = 2,
	damage = 3,
	drops = {
		{name = "default:torch",
		chance = 2,
		min = 3,
		max = 5,},
		{name = "default:iron_lump",
		chance=5,
		min=1,
		max=2,},
		{name = "default:coal_lump",
		chance=3,
		min=1,
		max=3,},
	},
	light_resistant = true,
	armor = 80,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	attack_type = "dogfight",
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	},
	sounds = {
		random = "mobs_stonemonster",
	},
	jump = true,
	step = 0.5,
	blood_texture = "mobs_blood.png",
})
mobs:register_spawn("mobs:stone_monster", {"default:stone"}, 3, -1, 7000, 1, 0)

-- Spawn Egg
minetest.register_craftitem("mobs:stone_monster", {
	description = "Stone Monster Egg",
	inventory_image = "default_stone.png^mobs_chicken_egg.png",
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above and not minetest.is_protected(pointed_thing.above, "") then
			minetest.env:add_entity(pointed_thing.above, "mobs:stone_monster")
			itemstack:take_item()
		end
		return itemstack
	end,
})
