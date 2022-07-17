extends Node3D

var _start_position: Vector3
var _random_offset: float
var _value: float

# Called when the node enters the scene tree for the first time.
func _ready():
	_random_offset = randi() % 1000
	_start_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_value += delta / 2
	var val = (_value + _random_offset)
	position = _start_position + Vector3(0, sin(val) / 2, 0)
