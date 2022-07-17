extends MeshInstance3D

var cookables = []

@onready var update_button = $"../CookSurfaceButton"

@export var intensity = 0
@export var color_gradient: Gradient
@export var update_delay = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	update_button.button_pressed.connect(_update_intensity_manual)
	
	# Duplicate the material, as we will be setting it's albedo_color for two instances
	var material = material_override.duplicate()
	material_override = material
	
	_update_intensity()
	
func _update_intensity():
	# Update intensity anywhere in between
	#intensity = randf()
	
	# Update intensity as distinctly 0 or 1
	intensity = round(randf())

	material_override.albedo_color = color_gradient.interpolate(intensity)
	await get_tree().create_timer(update_delay).timeout
	_update_intensity()
	
func _update_intensity_manual():
	intensity = round(randf())
	material_override.albedo_color = color_gradient.interpolate(intensity)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for cookable in cookables:
		cookable.cook_tick(intensity * delta)

func _on_area_3d_body_entered(body):
	# Assuming the collider mask already is looking for food
	if body is Cookable:
		cookables.append(body)

func _on_area_3d_body_exited(body):
	if body is Cookable:
		cookables.erase(body)
