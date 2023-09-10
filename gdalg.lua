--[[
IDss
141 - pink orb
36 - yellow orb
1333 - red orb
84 - blue orb
1022 - green orb
]]

local create_file = false --Create a .spwn file and compile it using SPWN


local function genrng(min,max)
	return math.random(min,max)
end

local path = "PATH_TO_SPWN_FILE"

local beats = { --times in which the player touches screen
	0,
	0.5,
	1,
	1.5,
	2,
	2.5,
	3,
	3.5,
	4
}

local speeds = { --inaccurate speeds/time in seconds to cover a block
	["0.5"] = 0.1195,
	["1"] = 0.09317499999,
	["2"] = 0.07749999999,
	["3"] = 0.064125,
	["4"] = 0.05212499999,
}

local speed = 1
local unit = 1/speeds[tostring(speed)] --real speed in blocks per second
local time = math.ceil(beats[#beats])+2
local playerx = 0
local playery = 0

local velocity = 0

local accsec = -41.2579753096
local minvel = -11.9287121102
local maxvel = 11.9287121102

local steps = 60

local objects = {} --{id,x,y}

local code = [[extract obj_props]]
local function additem(id,x,y)
	code=code.."\n$.add(obj { OBJ_ID: "..id..", X: "..x..", Y: "..y..",})"
end


for clock = 0,time*steps,1 do
	local dt = 1/steps
	playerx = playerx+(dt*unit)
	local gravity = accsec
	if (beats[1] or math.huge) <= clock/steps then
		--basically jump
		if #beats>0 then table.remove(beats,1) end
		velocity = 8.94653408313 --jump
		if playery<=0 then --is in floor
			
		end
		local rng = genrng(1,#jumporbs)
		local orbid = 0
		if rng == 1 then --pink
			orbid = 141
			velocity = 6.31791324427
		elseif rng == 2 then --yellow
			orbid = 36
			velocity = 8.80818561793
		elseif rng == 3 then --red
			orbid = 1333
			velocity = 12.3591295581
		end
		table.insert(objects,{i=orbid,x=(playerx+0.5)*28.57,y=(playery+0.5)*28.57})
	else
		if playery <=0 then gravity = 0 velocity = 0 end
	end
	velocity = velocity + gravity*dt
	velocity = (velocity>maxvel) and maxvel or velocity
	velocity = (velocity<minvel) and minvel or velocity
	playery=playery+velocity*(dt*2.55)
	playery =(playery<=0) and 0 or playery
--print(playerx,playery,velocity,clock/steps)
--print(playerx,playery,clock/steps,velocity)
	if (beats[1] or math.huge) <= clock/steps then error("steps underflow") end
end

for _,i in ipairs(objects) do
	additem(i.i,i.x,i.y)
end

print(code)

if create_file then
	local f = io.open(path,"w")
	f:write(code)
	f:close()
	os.execute("spwn build ".. path)
	print("Build Success!")
end
