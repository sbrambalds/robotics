-- Put your global variables here

MOVE_STEPS = 5
MAX_VELOCITY = 15
MAXRANGE = 30

n_steps = 0

moving = true

Ds = 0
Dw = 0
W = 0.1
S = 0.01
PSmax = 0.99
PWmin = 0.005
alpha = 0.1
beta = 0.05

--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	n_steps = 0
	robot.leds.set_all_colors("green")
end

function getProximity(a, b)
	sum = 0	
	for i=a,b do
		sum = sum + robot.proximity[i].value
	end
	return sum
end

function CountRAB()
    number_robot_sensed = 0
    for i = 1, #robot.range_and_bearing do
        -- for each robot seen, check if it is close enough.
        if robot.range_and_bearing[i].range < MAXRANGE and robot.range_and_bearing[i].data[1]==1 then
            number_robot_sensed = number_robot_sensed + 1
        end 
    end
    return number_robot_sensed
end

function rwCollisionAvoidance()
    right_prox = getProximity(18,24)
    left_prox = getProximity(1,4)
    if right_prox > 0 or left_prox > 0  then
        robot.wheels.set_velocity(-MAX_VELOCITY, MAX_VELOCITY)
    else 
        robot.wheels.set_velocity(MAX_VELOCITY, MAX_VELOCITY)
    end
end

function on_spot()
    for i=1,4 do
        if robot.motor_ground[i].value <= 0.1 then
            return true
        end
    end
    return false
end

--[[ This function is executed at each time step
It must contain the logic of your controller ]]
function step()
    n_steps = n_steps + 1

    if n_steps % MOVE_STEPS == 0 then

        N = CountRAB()

        if on_spot() then
            Ds = 0.05
            Dw = 0.5
        else
            Ds = 0
            Dw = 0
        end

        Ps = math.min(PSmax,S+alpha*N+Ds)
        Pw = math.max(PWmin,W-beta*N-Dw)

        if moving then
            robot.range_and_bearing.set_data(1,0)
        else 
            robot.range_and_bearing.set_data(1,1)
        end

        t = robot.random.uniform()
        if moving then
            if t <= Ps then
                robot.wheels.set_velocity(0,0)
                robot.leds.set_all_colors("red")
                moving = false
            else 
                rwCollisionAvoidance()
            end
        else 
            if t <= Pw then
                rwCollisionAvoidance()
                robot.leds.set_all_colors("green")
                moving = true
            end
        end
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
