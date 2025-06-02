MOVE_STEPS = 5
MAX_VELOCITY = 15
PROX_THRESHOLD = 0.2
LIGHT_THRESHOLD = 0.1

n_steps = 0

enabled = true

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
    if enabled then
        log("randomWalk active")
        robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
    end
end

function obstacleAvoidance()
    if getSum(1, 24, robot.proximity, PROX_THRESHOLD) > 0 and enabled then
        enabled = false
        log("obstacleAvoidance active")
        left_prox = getSum(1, 8, robot.proximity, PROX_THRESHOLD)
        right_prox = getSum(16, 24, robot.proximity, PROX_THRESHOLD)
        
        if(left_prox > right_prox) then 
            robot.wheels.set_velocity(MAX_VELOCITY, 0)
        else 
            robot.wheels.set_velocity(0, MAX_VELOCITY)
        end
    end
end

function phototaxis()
    if(getSum(1, 24, robot.light, 0) > LIGHT_THRESHOLD) and enabled then
        enabled = false
        log("phototaxis active")
        max_id = findMaxId()

        if (max_id < 13) and (max_id > 2) then
            robot.wheels.set_velocity(0,MAX_VELOCITY)
        elseif (max_id < 24) and (max_id > 12) then
            robot.wheels.set_velocity(MAX_VELOCITY,0)
        end
    end
end

function halt()
    if getSum(1, 4, robot.motor_ground, 0) < 0.1 then
        enabled = false
        robot.wheels.set_velocity(0,0)
    end
end

function step()
	n_steps = n_steps + 1
	
	log("step number = " .. n_steps)

	if n_steps % MOVE_STEPS == 0 then

        enabled = true

        halt()
        obstacleAvoidance()
        phototaxis()
        randomWalk()
        
	end		
end

function reset()
	robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
	n_steps = 0
end

function destroy()

end 
