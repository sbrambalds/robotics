MOVE_STEPS = 5
MAX_VELOCITY = 15
PROX_THRESHOLD = 0.5

n_steps = 0

function init()
	robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
end

function getProximity(a, b)
	sum = 0	
	for i=a,b do
		if(robot.proximity[i].value > PROX_THRESHOLD) then
			sum = sum + robot.proximity[i].value
		end
	end
	return sum
end

function step()
	n_steps = n_steps + 1
	
	log("step number = " .. n_steps)

	if n_steps % MOVE_STEPS == 0 then

		left_prox = getProximity(1, 8)
		right_prox = getProximity(16, 24)
		
		if(left_prox == 0 and right_prox == 0) then
			robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
		else 
			if(left_prox > right_prox) then 
				robot.wheels.set_velocity(MAX_VELOCITY, 0)
			else 
				robot.wheels.set_velocity(0, MAX_VELOCITY)
			end
		end
	end		
end

function reset()
	robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
	n_steps = 0
end

function destroy()

end 
