extends Node3D

signal tray_away
signal tray_at_grill

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var abstract_cookable = "res://SquareCookable.tscn"
@export var cookable_list: Array = [
	"res://Shapes/Square.tres",
	"res://Shapes/Cylinder.tres",
	"res://Shapes/Sphere.tres"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.seek(1.0)
	
func enter_tray():
	animation_player.play_backwards("tray_slide")
	
func exit_tray():
	animation_player.play("tray_slide")
	
func renew_tray():
	exit_tray()
	await get_tree().create_timer(2.0).timeout # Roughly the animation time
	# TODO: remove cookables!
	_spawn_cookables()
	enter_tray()
	await get_tree().create_timer(2.0).timeout # Roughly the animation time
	emit_signal("tray_at_grill")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Spawns a bunch of cookables on the tray
func _spawn_cookables():
	print(position)
	for i in range(0,4):
		var abstract = load(abstract_cookable).instantiate() as Cookable
		var resource = load(cookable_list[randi() % cookable_list.size()])
		var game_scene = get_node("/root/AbstractWorld")
		abstract.cookable_resource = resource
		
		game_scene.add_child(abstract)

		var spawn_scale = 0.5
		var rand_x = randf() * spawn_scale - (spawn_scale / 2)
		var rand_z = randf() * spawn_scale - (spawn_scale / 2)
		abstract.position = position + Vector3(rand_x, 0.1, rand_z)
	
