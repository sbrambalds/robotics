-- Put your global variables here

MOVE_STEPS = 5
MAX_VELOCITY = 10
LIGHT_THRESHOLD = 1.5

n_steps = 0


--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	n_steps = 0
	robot.leds.set_all_colors("black")
end

function getProximity(a, b)

	sum = 0	
	for i=a,b do
		sum = sum + robot.proximity[i]
	end
	return sum
end


--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	n_steps = n_steps + 1
	
	log("step number = " .. n_steps)
	
	left = getProximity(1, 4)
	right = getProximity(20, 24)
		
	log("right proximity level = " .. right)
	log("left proximity level = " .. left)
	

	if n_steps % MOVE_STEPS == 0 then
		
		if right > 0 then
			robot.wheels.set_velocity(0,10)
			robot.leds.set_all_colors("blue")
		elseif left > 0 then
			robot.wheels.set_velocity(10,0)
			robot.leds.set_all_colors("green")
		else 
			left_v = robot.random.uniform(0,MAX_VELOCITY)
			right_v = robot.random.uniform(0,MAX_VELOCITY)
			robot.wheels.set_velocity(left_v,right_v)
			robot.leds.set_all_colors("yellow")
		end
		
		
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
