extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal pick_me_up

var player_in_range = false
var item_name = "Extinguisher"
var smoke_quantity = 1000
onready var smoke = $Smoke

# Called when the node enters the scene tree for the first time.
func _ready():
	smoke.emitting = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_mouse_button_pressed(1)
	and _pointer_is_on_sprite()
	and player_in_range):
		emit_signal("pick_me_up", self)
	pass

func _use():
	if smoke_quantity > 0:
		smoke.emitting = true
		smoke_quantity -= 1

func _stop_use():
	smoke.emitting = false

func _on_Area2D_body_entered(body):
	player_in_range = true

func _on_Area2D_body_exited(body):
	player_in_range = false

func _pointer_is_on_sprite():
	return get_rect().has_point(get_local_mouse_position())
