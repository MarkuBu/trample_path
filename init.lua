
--
-- List of shovels
--

local shovels = {
		"default:shovel_wood",
		"default:shovel_stone",
		"default:shovel_steel",
		"default:shovel_bronze",
		"default:shovel_mese",
		"default:shovel_diamond",
}

--
-- Overwrite items
--

for _, shovel in ipairs(shovels) do
	if minetest.registered_items[shovel] then
		minetest.override_item(shovel, {
			on_place = function(itemstack, placer, pointed_thing)
				local node = minetest.get_node(pointed_thing.under)
				local name = node.name
				local maxlevel = itemstack:get_tool_capabilities()["groupcaps"]["crumbly"]["maxlevel"]
				local level = minetest.registered_nodes[name]["groups"]["level"]
				local uses = itemstack:get_tool_capabilities()["groupcaps"]["crumbly"]["uses"]

				if not level then
					level = 0
				end

				if level > maxlevel then
					return itemstack
				end

				if name == "default:dirt" or name == "default:dirt_with_grass"  or
						name == "default:dirt_with_rainforest_litter"  or
						name == "default:dirt_with_dry_grass" then
					minetest.set_node(pointed_thing.under, {name = "trample_path:dirt"})
				elseif name == "default:sand" then
					minetest.set_node(pointed_thing.under, {name = "trample_path:sand"})
				elseif name == "default:desert_sand" then
					minetest.set_node(pointed_thing.under, {name = "trample_path:desert_sand"})
				elseif name == "default:silver_sand" then
					minetest.set_node(pointed_thing.under, {name = "trample_path:silver_sand"})
				elseif name == "default:gravel" then
					minetest.set_node(pointed_thing.under, {name = "trample_path:gravel"})
				elseif name == "default:dirt_with_snow" then
					minetest.set_node(pointed_thing.under, {name = "trample_path:dirt_with_snow"})
				elseif name == "default:snow" then
					minetest.set_node(pointed_thing.under, {name = "trample_path:snow"})
				else
					return itemstack
				end

				if not minetest.setting_getbool("creative_mode") then
					uses = uses * 3 ^ (maxlevel - level)
					itemstack:add_wear(65536 / uses)
				end
				return itemstack
			end
		})
	end
end


--
-- Nodes
--

minetest.register_node("trample_path:dirt", {
	description = "Dirt",
	drawtype = 'nodebox',
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil = 1},
	sounds = default.node_sound_dirt_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {'default:dirt'}}
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5,  0.5, 0.5 - 1/16, 0.5},
		},
	},
})

minetest.register_node("trample_path:gravel", {
	description = "Gravel",
	drawtype = 'nodebox',
	tiles = {"default_gravel.png"},
	groups = {crumbly = 2, falling_node = 1},
	sounds = default.node_sound_gravel_defaults(),
	drop = {
		max_items = 1,
		items = {
			{items = {'default:gravel'}}
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5,  0.5, 0.5 - 1/16, 0.5},
		},
	},
})


minetest.register_node("trample_path:dirt_with_snow", {
	description = "Dirt with Snow",
	drawtype = 'nodebox',
	tiles = {"default_snow.png", "default_dirt.png",
		{name = "default_dirt.png^default_snow_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1, snowy = 1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
	}),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5,  0.5, 0.5 - 1/16, 0.5},
		},
	},
})


minetest.register_node("trample_path:sand", {
	description = "Sand",
	drawtype = 'nodebox',
	tiles = {"default_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5,  0.5, 0.5 - 1/16, 0.5},
		},
	},
})

minetest.register_node("trample_path:desert_sand", {
	description = "Desert Sand",
	drawtype = 'nodebox',
	tiles = {"default_desert_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5,  0.5, 0.5 - 1/16, 0.5},
		},
	},
})

minetest.register_node("trample_path:silver_sand", {
	description = "Silver Sand",
	drawtype = 'nodebox',
	tiles = {"default_silver_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5,  0.5, 0.5 - 1/16, 0.5},
		},
	},
})


minetest.register_node("trample_path:snow", {
	description = "Snow",
	tiles = {"default_snow.png"},
	inventory_image = "default_snowball.png",
	wield_image = "default_snowball.png",
	paramtype = "light",
	buildable_to = true,
	floodable = true,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.25 - 1/16, 0.5},
		},
	},
	groups = {crumbly = 3, falling_node = 1, puts_out_fire = 1, snowy = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2}
	}),

	on_construct = function(pos)
		pos.y = pos.y - 1
		if minetest.get_node(pos).name == "default:dirt_with_grass" then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		end
	end,
})

minetest.register_node("trample_path:snowblock", {
	description = "Snow Block",
	drawtype = 'nodebox',
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, puts_out_fire = 1, cools_lava = 1, snowy = 1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_snow_footstep", gain = 0.15},
		dug = {name = "default_snow_footstep", gain = 0.2},
		dig = {name = "default_snow_footstep", gain = 0.2}
	}),

	on_construct = function(pos)
		pos.y = pos.y - 1
		if minetest.get_node(pos).name == "default:dirt_with_grass" then
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
		end
	end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5,  0.5, 0.5 - 1/16, 0.5},
		},
	},
})

