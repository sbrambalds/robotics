-- Put your global variables here

MOVE_STEPS = 5
MAX_VELOCITY = 15

n_steps = 0

function init()
	robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
end

function getSum(a, b, list)
	sum = 0.0001	
	for i=a,b do
		sum = sum + list[i].value
	end
	return sum / (b - a + 1)
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

    max_id = findMaxId()
	max_val = robot.light[max_id].value

    log("step number = " .. n_steps)

    if n_steps % MOVE_STEPS == 0 then

        left_prox = getSum(1, 8, robot.proximity)
        right_prox = getSum(17, 24, robot.proximity) 

		right_wheel = MAX_VELOCITY
		left_wheel = MAX_VELOCITY

        if (max_id < 13) and (max_id > 2)  then
			robot.wheels.set_velocity(0,MAX_VELOCITY)
		elseif (max_id < 24) and (max_id > 12) then
			robot.wheels.set_velocity(MAX_VELOCITY,0)
		else 
			if right_prox > left_prox then
				left_wheel =  MAX_VELOCITY * (1 - right_prox) 
			else
				right_wheel = MAX_VELOCITY * (1 - left_prox)
			end
			robot.wheels.set_velocity(left_wheel, right_wheel)
        end 
    end		
end

function reset()
	robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
end

function destroy()

end
