-- Put your global variables here

MOVE_STEPS = 10
MAX_VELOCITY = 10
LIGHT_THRESHOLD = 1.5

n_steps = 0


--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0
	robot.leds.set_all_colors("black")
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



--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	n_steps = n_steps + 1
	
	log("step number = " .. n_steps)
	
	max_id = findMaxId()
	max_val = robot.light[max_id].value
		
	log("max light val = " .. max_val)
	

	if n_steps % MOVE_STEPS == 0 then
		
		if (max_id < 13) and (max_id > 1) then
			robot.wheels.set_velocity(0,10)
			robot.leds.set_all_colors("blue")
		elseif (max_id < 23) and (max_id > 12) then
			robot.wheels.set_velocity(10,0)
			robot.leds.set_all_colors("green")
		else 
			robot.wheels.set_velocity(10,10)
			robot.leds.set_all_colors("yellow")
		end
			
		log("max id = " .. max_id)
		max_id = findMaxId()
		
		
		log("robot.position.x = " .. robot.positioning.position.x)
		log("robot.position.y = " .. robot.positioning.position.y)
		log("robot.position.z = " .. robot.positioning.position.z)

	end		
end



--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
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
