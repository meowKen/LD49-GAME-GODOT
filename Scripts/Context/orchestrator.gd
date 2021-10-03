extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var global_id = "coucou depuis l'orchestrator"
var display_ratio = 1.77
var player_ref = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_player(player):
	player_ref = player
	
func get_player():
	return player_ref

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
