tool
extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0, -1)
const MAX_SPEED = 300
const ACCELERATION = 0.05
const FRICTION = 0.1
const JUMP_HEIGHT = 700

onready var _context = get_node("/root/Orchestrator")
onready var _animation = $AnimatedSprite
var motion = Vector2()
var x_axis = 0
var y_axis = 0

func _process(delta):
	if _context != null and _animation != null:
		print(_context["global_id"])
		if abs(motion.x) < 10 and abs(motion.y) < 10:
			_animation.play("idle")
		elif motion.y > 0:
			_animation.play("down")

func _physics_process(delta):
	
	# check horizontal input
	var right = int(Input.is_action_pressed("ui_right"))
	var left = int(Input.is_action_pressed("ui_left"))
	
	var up = int(Input.is_action_pressed("ui_up"))
	var down = int(Input.is_action_pressed("ui_down"))

	x_axis = right - left
	y_axis = down - up
	
	# Apply horizontal input
	if !x_axis:
		motion.x = lerp(motion.x, 0, FRICTION)
	else:
		motion.x = lerp(motion.x, MAX_SPEED * x_axis, ACCELERATION)
		
	# Apply horizontal input
	if !y_axis:
		motion.y = lerp(motion.y, 0, FRICTION)
	else:
		motion.y = lerp(motion.y, MAX_SPEED * y_axis, ACCELERATION)

	motion = move_and_slide(motion)
