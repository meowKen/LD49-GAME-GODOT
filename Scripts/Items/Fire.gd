extends Node2D

class_name Fire

const MAX_LIFE = 1000
const PROPAGATION_THRESHOLD = 0.8
const START_LIFE = 500
const START_LIFE_VARIANCE = 0.20
const MIN_SCALE = Vector2(0.25, 0.25)
const MAX_SCALE = Vector2(2, 2)
const GROWTH_RATE = 1

onready var _animation = $AnimatedSprite

var current_life
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_animation.play("default")
	current_life = rng.randfn(START_LIFE, START_LIFE_VARIANCE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_life <= 0:
		print("fire is dead")
		pass
	if current_life < MAX_LIFE:
		current_life += GROWTH_RATE
		var scale_factor = current_life / MAX_LIFE
		var new_scale = lerp(MIN_SCALE, MAX_SCALE, scale_factor)
		print(new_scale)
		_animation.scale = new_scale

func _activate(activator):
	if activator is Extinguisher:
		current_life -= activator.power
