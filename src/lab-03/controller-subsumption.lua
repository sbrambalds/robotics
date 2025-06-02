MOVE_STEPS = 5
MAX_VELOCITY = 15
PROX_THRESHOLD = 0.2
LIGHT_THRESHOLD = 0.1

n_steps = 0

active_layer = true

function init()
	robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
end

function getSum(a, b, list, threshold)
	sum = 0	
	for i=a,b do
        if list[i].value > threshold then
		    sum = sum + list[i].value
        end
	end
	return sum
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

function randomWalk()
    if active_layer then
        log("randomWalk active")
        robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
    end
end

function obstacleAvoidance()
    if getSum(1, 24, robot.proximity, PROX_THRESHOLD) > 0 and active_layer then
        active_layer = false
        log("obstacleAvoidance active")
        left_prox = getSum(1, 8, robot.proximity, PROX_THRESHOLD)
        right_prox = getSum(16, 24, robot.proximity, PROX_THRESHOLD)
        
        if(left_prox > right_prox) then 
            robot.wheels.set_velocity(MAX_VELOCITY, 0)
        else 
            robot.wheels.set_velocity(0, MAX_VELOCITY)
        end
    else
        phototaxis()
    end
end

function phototaxis()
    if(getSum(1, 24, robot.light, 0) > LIGHT_THRESHOLD) and active_layer then
        active_layer = false
        log("phototaxis active")
        max_id = findMaxId()

        if (max_id < 13) and (max_id > 2) then
            robot.wheels.set_velocity(0,MAX_VELOCITY)
        elseif (max_id < 24) and (max_id > 12) then
            robot.wheels.set_velocity(MAX_VELOCITY,0)
        end
    else 
        randomWalk()
    end
end

function halt()
    if getSum(1, 4, robot.motor_ground, 0) < 0.1 then
        active_layer = false
        robot.wheels.set_velocity(0,0)
    else 
        obstacleAvoidance()
    end
end

function step()
	n_steps = n_steps + 1
	
	log("step number = " .. n_steps)

	if n_steps % MOVE_STEPS == 0 then

        active_layer = true

        halt()
        
	end		
end

function reset()
	robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
	n_steps = 0
end

function destroy()

end 
