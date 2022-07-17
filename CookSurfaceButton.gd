extends Area3D

signal button_pressed

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var _is_toggled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func reset():
	animation_player.play_backwards("surface_button")

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && not _is_toggled:
			_is_toggled = true
			
			# Not sure why, but the loop setting isn't respected in the editor
			# and needs manual coaxing here.
			var stream = audio_player.stream as AudioStreamOGGVorbis
			stream.loop = false
			audio_player.play()
			
			animation_player.play("surface_button")
			emit_signal("button_pressed")
			await get_tree().create_timer(0.5).timeout
			animation_player.play_backwards("surface_button")
			_is_toggled = false
