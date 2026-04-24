local grug = require("grug")

local state = grug.init({
	mod_api_path = "Mods/example-gun.rte/mod_api.json",
	mods_dir_path = "Mods/example-gun.rte/mods"
})

state:register_game_fn("get_rate_of_fire", function(state)
	return grug.self.RateOfFire
end)

state:register_game_fn("set_rate_of_fire", function(state, rate_of_fire)
	grug.self.RateOfFire = rate_of_fire
end)

file = state:compile_grug_file("example/burton-Gun.grug")
e = file:create_entity()

function OnFire(self)
	grug.self = self
	e:on_fire()

	-- Existing Lua code can coexist with grug code.
	local randomSmoke = math.floor(math.random() * 4) + 3

	for i = 1, randomSmoke do
		local smokefx = CreateMOSParticle("Loyalist Tiny Gun Smoke Ball")
		smokefx.Pos = self.MuzzlePos
		smokefx.Vel = self.Vel / 4
			+ Vector(((math.random() * 6) + 3) * self.FlipFactor, 0):RadRotate(
				self.RotAngle + (math.random() * 0.6) - 0.2
			)
		MovableMan:AddParticle(smokefx)
		smokefx = nil
	end

	local glowfx = CreateMOPixel("Loyalist Gun Glow A")
	glowfx.Pos = self.MuzzlePos
	MovableMan:AddParticle(glowfx)
end
