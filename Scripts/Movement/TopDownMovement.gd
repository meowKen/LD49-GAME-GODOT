tool
extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0, -1)
const MAX_SPEED = 600
const ACCELERATION = 0.05
const FRICTION = 0.1
const JUMP_HEIGHT = 700

onready var _context = get_node("/root/Orchestrator")
onready var _animation = $AnimatedSprite
var motion = Vector2()
var x_axis = 0
var y_axis = 0
var handled_item

func _process(delta):
	if _context != null and _animation != null:
		if abs(motion.x) < 10 and abs(motion.y) < 10:
			_animation.play("idle")
		elif motion.y > 0:
			_animation.play("down")

func _physics_process(delta):
	# check inputs
	var right = int(Input.is_action_pressed("ui_right"))
	var left = int(Input.is_action_pressed("ui_left"))
	var up = int(Input.is_action_pressed("ui_up"))
	var down = int(Input.is_action_pressed("ui_down"))
	
	# Drop item if necessary
	if Input.is_action_just_pressed("ui_drop_item"):
		handled_item = null

	# Use item if necessary
	if Input.is_action_pressed("ui_select"):
		if (handled_item != null):
			print("using item " + handled_item.item_name)
		else:
			print("try using no item")
	# Compute axises
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

	if handled_item != null:
		var item_pos = self.position + Vector2(16, 16)
		handled_item.set_position(item_pos)

func _on_Extinguisher_pick_me_up(item):
	if handled_item == null:
		print("Took the " + item.item_name)
		handled_item = item
	else:
		print("Didn't took the " + item.item_name)
		print("Already handling" + handled_item.item_name)
