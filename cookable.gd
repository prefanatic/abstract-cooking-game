extends Node3D
class_name Cookable


@export var color_gradient: Gradient


# Represents when this cookable is "done"
@export var done_value = 0.5

# Represents when this item has burned
@export var burn_value = 0.85

# Represents when this item should catch fire
@export var fire_value = 1.0

@export var cook_factor = 0.1

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var smoke_particles: CPUParticles3D = $SmokeParticles

var cookable_resource: CookableResource

const SMOKE_PARTICLES_MIN = 0
const SMOKE_PARTICLES_MAX = 200

var cook_value = 0
var cook_rate = 0

var _material: StandardMaterial3D

func _ready():
	if cookable_resource == null:
		cookable_resource = load("res://Shapes/Square.tres")
	var mesh = cookable_resource.mesh.duplicate()
	mesh_instance.mesh = mesh
	
	_material = load("res://cookable_raw.tres").duplicate()
	mesh_instance.set_surface_override_material(0, _material)
	
	# Update the collision shape
	var resource_shape = cookable_resource.collision_shape
	if (resource_shape == null):
		resource_shape = mesh_instance.create_convex_collision(true, true)
	collision_shape.shape = resource_shape

func cook_tick(value):
	var rate = value * cook_factor
	
	cook_rate = rate
	cook_value += rate

	_material.albedo_color = color_gradient.interpolate(cook_value)
	
	if cook_value >= burn_value:
		if not smoke_particles.emitting:
			smoke_particles.emitting = true

	if cook_value >= fire_value:
		queue_free()

func adjust_smoke_particles(rate):
	# Update the emitted particles to correspond with how quickly it's cooking
	#smoke_particles.amount = (SMOKE_PARTICLES_MAX - SMOKE_PARTICLES_MIN) * rate
	print(cook_rate)
	
func is_done() -> bool:
	return cook_value >= done_value && cook_value <= burn_value
