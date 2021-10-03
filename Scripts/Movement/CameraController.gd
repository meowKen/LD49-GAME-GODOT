extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _context = get_node("/root/Orchestrator")
var player_ref = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player_ref = _context.get_player()
	position = player_ref.position
	
func _process(_delta):
	position = _context.player_ref.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
