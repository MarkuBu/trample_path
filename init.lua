
local enable_path_while_walk = true

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
-- List of nodes
--

local nodes = {}
nodes["default:dirt"] = {count = 6, replace = "trample_path:dirt"}
nodes["default:dirt_with_grass"] = {count = 6, replace = "default:dirt"}
nodes["default:dirt_with_rainforest_litter"] = {count = 6, replace = "default:dirt"}
nodes["default:dirt_with_snow"] = {count = 3, replace = "trample_path:dirt_with_snow"}
nodes["default:sand"] = {count = 4, replace = "trample_path:sand"}
nodes["default:desert_sand"] = {count = 4, replace = "trample_path:desert_sand"}
nodes["default:silver_sand"] = {count = 4, replace = "trample_path:silver_sand"}
nodes["default:gravel"] = {count = 10, replace = "trample_path:gravel"}
nodes["default:snow"] = {count = 2, replace = "trample_path:snow"}
nodes["default:grass_1"] = {count = 1, replace = "air"}
nodes["default:grass_2"] = {count = 1, replace = "air"}
nodes["default:grass_3"] = {count = 2, replace = "air"}
nodes["default:grass_4"] = {count = 2, replace = "air"}
nodes["default:grass_5"] = {count = 3, replace = "air"}
nodes["flowers:rose"] = {count = 1, replace = "air"}
nodes["flowers:tulip"] = {count = 1, replace = "air"}
nodes["flowers:dandelion_yellow"] = {count = 1, replace = "air"}
nodes["flowers:geranium"] = {count = 1, replace = "air"}
nodes["flowers:viola"] = {count = 1, replace = "air"}
nodes["flowers:dandelion_white"] = {count = 1, replace = "air"}
nodes["flowers:mushroom_red"] = {count = 1, replace = "air"}
nodes["flowers:mushroom_brown"] = {count = 1, replace = "air"}

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

				if nodes[name] then
					minetest.set_node(pointed_thing.under, {name = nodes[node.name].replace})
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

local function replace_node(node, pos)
	if node.param2 > nodes[node.name].count then
		minetest.swap_node(pos, {name = nodes[node.name].replace})
	else
		minetest.swap_node(pos, {name = node.name, param2 = node.param2 + 1})
	end
end

local lastpos = {}

if enable_path_while_walk then
	minetest.register_globalstep(function(dtime)
		local players = minetest.get_connected_players()
		for id, player in ipairs(players) do
			local pos = vector.round(player:get_pos())
			local player_name = player:get_player_name()

			if not lastpos[player_name] then
				lastpos[player_name] = pos
			end

			if not vector.equals(pos, lastpos[player_name]) then
				local under = {x = pos.x, y = pos.y - 1, z = pos.z}
				local node = minetest.get_node(pos)
				local node_under = minetest.get_node(under)
				if nodes[node.name] then
					replace_node(node, pos)
				elseif nodes[node_under.name] then
					replace_node(node_under, under)
				end
				lastpos[player_name] = pos
			end
		end
	end)
end

--
-- Nodes
--

minetest.register_node("trample_path:dirt", {
	description = "Dirt",
	drawtype = 'nodebox',
	tiles = {"default_dirt.png"},
	groups = {crumbly = 3, soil = 1, not_in_creative_inventory = 1},
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
	groups = {crumbly = 2, falling_node = 1, not_in_creative_inventory = 1},
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
	paramtype = "light",
	drawtype = 'nodebox',
	tiles = {"default_snow.png", "default_dirt.png",
		{name = "default_dirt.png^default_snow_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_dirt_type = 1, snowy = 1,
			not_in_creative_inventory = 1},
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
	paramtype = "light",
	drawtype = 'nodebox',
	tiles = {"default_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1, not_in_creative_inventory = 1},
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
	paramtype = "light",
	drawtype = 'nodebox',
	tiles = {"default_desert_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1, not_in_creative_inventory = 1},
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
	paramtype = "light",
	drawtype = 'nodebox',
	tiles = {"default_silver_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1, not_in_creative_inventory = 1},
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
	groups = {crumbly = 3, falling_node = 1, puts_out_fire = 1, snowy = 1,
			not_in_creative_inventory = 1},
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
	paramtype = "light",
	drawtype = 'nodebox',
	tiles = {"default_snow.png"},
	groups = {crumbly = 3, puts_out_fire = 1, cools_lava = 1, snowy = 1,
			not_in_creative_inventory = 1},
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

