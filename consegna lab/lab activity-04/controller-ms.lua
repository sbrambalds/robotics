-- Put your global variables here

local vector = require "vector"

MOVE_STEPS = 5
MAX_VELOCITY = 15
LIGHT_THRESHOLD = 1.5
L = robot.wheels.axis_length

n_steps = 0

function init()
	n_steps = 0
    robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
end


function maxId(arr)
    max_id = 1
	max_val = arr[1].value
	for i=1,#arr do
		max = arr[i].value
		if max > max_val then
			max_id = i
			max_val = max
		end
	end
	return max_id
end

function sumArray(arr)
    obstacle_vector = {length = 0, angle = 0}
    for i=1,#arr do 
        obstacle_vector.length = obstacle_vector.length + arr[i].value
        obstacle_vector.angle = obstacle_vector.angle + arr[i].value*arr[i].angle
    end
    return obstacle_vector
end

function step()
    n_steps = n_steps + 1

    log("step number = " .. n_steps)

    if n_steps % MOVE_STEPS == 0 then

        maxLightId = maxId(robot.light)
        maxProxId = maxId(robot.proximity)

        light_polar = {length = 1 - robot.light[maxLightId].value , angle = robot.light[maxLightId].angle}

        prox_polar = {length = robot.proximity[maxProxId].value , angle = (robot.proximity[maxProxId].angle + math.pi) % (math.pi*2)}
        
        log("Prox Polar Length = "..prox_polar.length)

        v_polar = vector.vec2_polar_sum(light_polar, prox_polar)

        w = v_polar.angle
        v = v_polar.length * MAX_VELOCITY

        vl = 15 - (L*w)/2
        vr = 15 + (L*w)/2

        robot.wheels.set_velocity(vl, vr)

    end		
end

function reset()
    left_v = robot.random.uniform(0,MAX_VELOCITY)
    right_v = robot.random.uniform(0,MAX_VELOCITY)
    robot.wheels.set_velocity(left_v,right_v)
    n_steps = 0
    robot.leds.set_all_colors("black")
end



--[[ This function is executed only once, when the robot is removed
    from the simulation ]]
function destroy()
-- put your code here
end
