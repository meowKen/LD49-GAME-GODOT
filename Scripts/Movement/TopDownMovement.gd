tool
extends KinematicBody2D

class_name EmitGreen

const FLOOR_NORMAL = Vector2(0, -1)
const MAX_SPEED = 200
const ACCELERATION = 0.05
const FRICTION = 0.1
const JUMP_HEIGHT = 700
var LEFT_HAND_OFFSET = {
	"up": Vector2(3, 8),
	"down": Vector2(13, 8),
	"left": Vector2(0, 8),
	"right": Vector2(8, 5),
}

onready var _context = get_node("/root/Orchestrator")
onready var _animation = $AnimatedSprite
var current_left_hand_offset
var motion = Vector2()
var x_axis = 0
var y_axis = 0
var handled_item
var handled_item_z_index = 0

func _ready():
	_context.set_player(self)

func _physics_process(_delta):
	_determine_axises()
	_apply_movement()
	_handle_animation()
	_determine_item_action()
	_handle_item_position_and_rotation()

func _use_item():
	if (handled_item != null):
		handled_item._use()

func _stop_use_item():
	if (handled_item != null):
		handled_item._stop_use()

func _on_Extinguisher_pick_me_up(item):
	if handled_item == null:
		handled_item = item

func _determine_axises():
	# check inputs
	var right = int(Input.is_action_pressed("ui_right"))
	var left = int(Input.is_action_pressed("ui_left"))
	var up = int(Input.is_action_pressed("ui_up"))
	var down = int(Input.is_action_pressed("ui_down"))
	
	# Compute axises
	x_axis = right - left
	y_axis = down - up

func _determine_item_action():
	# Drop item if necessary
	if Input.is_action_just_pressed("ui_drop_item"):
		handled_item.reset()
		handled_item = null

	# Use item if necessary
	if Input.is_action_pressed("ui_select"):
		_use_item()

	# Stop use item if necessary
	if Input.is_action_just_released("ui_select"):
		_stop_use_item()

func _apply_movement():
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

func _handle_animation():
	var animation_type
	var animation_direction = _determine_animation_direction()

	if _animation != null and _is_moving() and animation_direction != "none":
		if _not_realy_moving():
			animation_type = "idle"
		else:
			animation_type = "walk"
		
		var animation_key = animation_type + "_" + animation_direction
		_animation.play(animation_key)

func _handle_item_position_and_rotation():
	if handled_item != null:
		var item_pos = self.position + current_left_hand_offset
		handled_item.z_index = handled_item_z_index
		handled_item.set_position(item_pos)
		handled_item.look_at(get_global_mouse_position())

func _determine_animation_direction():
	var strongest_direction = _get_strongest_direction()
	if strongest_direction.x == 1 and _animation != null:
		_animation.flip_h = false
		current_left_hand_offset = LEFT_HAND_OFFSET["right"]
		handled_item_z_index = 0
		return "right"
	if strongest_direction.x == -1 and _animation != null:
		_animation.flip_h = true
		current_left_hand_offset = LEFT_HAND_OFFSET["left"]
		handled_item_z_index = 2
		return "right"
	if strongest_direction.y == 1:
		current_left_hand_offset = LEFT_HAND_OFFSET["down"]
		handled_item_z_index = 2
		return "down"
	if strongest_direction.y == -1:
		current_left_hand_offset = LEFT_HAND_OFFSET["up"]
		handled_item_z_index = 0
		return "up"
	return "none"

func _get_strongest_direction():
	if abs(motion.x) > abs(motion.y):
		if motion.x > 0:
			return Vector2(1, 0)
		elif motion.x < 0:
			return Vector2(-1, 0)
	else:
		if motion.y > 0:
			return Vector2(0, 1)
		if motion.y < 0:
			return Vector2(0, -1)
	return Vector2(0, 0)

func _not_realy_moving():
	return abs(motion.x) < 10 and abs(motion.y) < 10

func _is_moving():
	return abs(motion.x) != 0 or abs(motion.y) != 0
