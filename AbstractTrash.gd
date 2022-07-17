extends Node3D

signal on_score_positive
signal on_score_negative

var positive_food_sound = "res://assets/impactGeneric_light_004.ogg"
var negative_food_sound = "res://assets/impactBell_heavy_002.ogg"

@onready var fall_sensor: Area3D = $FallSensor
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var expected_cookable_preview: ExpectedCookablePreview = $ExpectedCookablePreview

# Called when the node enters the scene tree for the first time.
func _ready():
	fall_sensor.body_entered.connect(_destroy_food)
	
func _is_expected_food(body) -> bool:
	if not body is Cookable: return false
	if not body.is_done(): return false
	if not body.cookable_resource.id == expected_cookable_preview.expected_cookable.id: return false

	return true

func _destroy_food(body):
	if _is_expected_food(body): 
		_play_audio(positive_food_sound)
		emit_signal("on_score_positive")
	else: 
		_play_audio(negative_food_sound)
		emit_signal("on_score_negative")
	body.queue_free()

func _play_audio(resource):
	audio_player.stream = load(resource)
	audio_player.stream.loop = false
	audio_player.play()
