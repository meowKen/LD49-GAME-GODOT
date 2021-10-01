extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0, -1)
const SPEED = 300
const GRAVITY = 40
const JUMP_HEIGHT = 700
var motion = Vector2()
onready var _animation_player = $Animation
	
func _process(delta):
	if motion.y < -10:
		_animation_player.play("jump_up")
	elif motion.y > 10:
		_animation_player.play("jump_down")
	elif motion.x != 0:
		_animation_player.play("run")
	elif motion.x == 0:
		_animation_player.play("idle")
	pass

func _physics_process(delta):
	motion.y = motion.y + GRAVITY if motion.y < 1000 else motion.y
	
	if Input.is_action_pressed("ui_right"):
		motion.x = SPEED
		_animation_player.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		motion.x = -SPEED
		_animation_player.flip_h = true
	else:
		motion.x = 0
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_HEIGHT

	motion = move_and_slide(motion, FLOOR_NORMAL)
	pass
