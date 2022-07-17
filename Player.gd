extends Node3D

@export var dragSpeed: float = 20

@onready var camera: Camera3D = $Camera3D

var heldFood: Object

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if EngineDebugger.is_active():
		if Input.is_action_just_pressed("right_click"):
			var res = load("res://SquareCookable.tscn") as PackedScene
			$"..".add_child(res.instantiate())
	
func _raycast_for_food():
	var mouse_pos = get_viewport().get_mouse_position()
	var params = PhysicsRayQueryParameters3D.new()
	params.from = camera.project_ray_origin(mouse_pos)
	params.to = camera.project_ray_normal(mouse_pos) * 1000
	params.collision_mask = 0b1000

	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(params)
	if not result.is_empty():
		return result

func _physics_process(delta):
	if Input.is_action_just_released("left_click") && heldFood != null:
		var collider = heldFood.collider
		heldFood = null
		
		if collider == null: return
		var rigidBody = collider as RigidDynamicBody3D
		rigidBody.freeze = false
		##rigidBody.gravity_scale = 1
		rigidBody.angular_damp = 0.0
		
	if Input.is_action_just_pressed("left_click"):
		var food = _raycast_for_food()
		if food:
			heldFood = food
		
	if (heldFood != null):
		var mouse_pos = get_viewport().get_mouse_position()
		var params = PhysicsRayQueryParameters3D.new()
		params.from = camera.project_ray_origin(mouse_pos)
		params.to = camera.project_ray_normal(mouse_pos) * 1000
		params.collision_mask = 0b0111 

		var space_state = get_world_3d().direct_space_state
		var result = space_state.intersect_ray(params)
		
		var collider = heldFood.collider
		if (collider == null): return
		
		var parent_node = collider.get_parent()
		var rigidBody = (collider as RigidDynamicBody3D)
	
		var direction = rigidBody.position.direction_to(result.position).normalized()
		var distance = rigidBody.position.distance_to(result.position)
		var velocity = direction * dragSpeed * distance
		rigidBody.linear_velocity = velocity
		rigidBody.angular_damp = 10.0
		#rigidBody.position += Vector3(0, 0.1, 0)

	



