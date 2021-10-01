extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0, -1)
const MAX_SPEED = 300
const ACCELERATION = 0.1
const FRICTION = 0.2
const GRAVITY = 40
const JUMP_HEIGHT = 700

var motion = Vector2()
var x_axis = 0
onready var _animation_player = $Animation

	
func _process(delta):
	#Handle flip sprite
	if x_axis == -1:
		_animation_player.flip_h = true
	elif x_axis == 1:
		_animation_player.flip_h = false

	#Handle switch animation	
	if motion.y < -10:
		_animation_player.play("jump_up")
	elif motion.y > 10:
		_animation_player.play("jump_down")
	elif abs(motion.x) > 100:
		_animation_player.play("run")
	else:
		_animation_player.play("idle")
	pass

func _physics_process(delta):
	# Apply gravity
	motion.y = motion.y + GRAVITY if motion.y < 1000 else motion.y
	
	# check horizontal input
	var right = int(Input.is_action_pressed("ui_right"))
	var left = int(Input.is_action_pressed("ui_left"))

	x_axis = right - left
	
	# Apply horizontal input
	if !x_axis:
		motion.x = lerp(motion.x, 0, FRICTION)
	else:
		motion.x = lerp(motion.x, MAX_SPEED * x_axis, ACCELERATION)

	# Handle vertical input
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		motion.y = -JUMP_HEIGHT

	motion = move_and_slide(motion, FLOOR_NORMAL)
	print(motion)
	pass
