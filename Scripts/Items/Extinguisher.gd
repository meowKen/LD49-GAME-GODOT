extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal pick_me_up

var player_in_range = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_mouse_button_pressed(1)
	and _pointer_is_on_sprite()
	and player_in_range):
		emit_signal("pick_me_up", self)
	pass


func _on_Area2D_body_entered(body):
	player_in_range = true

func _on_Area2D_body_exited(body):
	player_in_range = false

func _pointer_is_on_sprite():
	return get_rect().has_point(get_local_mouse_position())
