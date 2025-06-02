MOVE_STEPS = 5
MAX_VELOCITY = 15

n_steps = 0

function init()
	robot.wheels.set_velocity(MAX_VELOCITY,MAX_VELOCITY)
end


function findMaxId()
	max_id = 1
	max_val = robot.light[1].value
	for i=1,#robot.light do
		max = robot.light[i].value
		if max > max_val then
			max_id = i
			max_val = max
		end
	end
	return max_id
end


function step()
	n_steps = n_steps + 1
	
	log("step number = " .. n_steps)
	
	max_id = findMaxId()

	if n_steps % MOVE_STEPS == 0 then
		
		if (max_id < 13) and (max_id > 1) then
			robot.wheels.set_velocity(0,MAX_VELOCITY)
		elseif (max_id < 23) and (max_id > 12) then
			robot.wheels.set_velocity(MAX_VELOCITY,0)
		else 
			robot.wheels.set_velocity(MAX_VELOCITY,MAX_VELOCITY)
		end
	end		
end

function reset()
	robot.wheels.set_velocity(MAX_VELOCITY,MAX_VELOCITY)
	n_steps = 0
end


function destroy()

end
