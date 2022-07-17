extends MeshInstance3D
class_name ExpectedCookablePreview

var cookable_list: Array = [
	"res://Shapes/Square.tres",
	"res://Shapes/Cylinder.tres",
	"res://Shapes/Sphere.tres"
]

var expected_cookable: CookableResource
var _value: float

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_expected()
	pass # Replace with function body.

func _update_expected():
	expected_cookable = load(cookable_list[randi() % cookable_list.size()])
	mesh = expected_cookable.mesh
	await get_tree().create_timer(10.0).timeout
	_update_expected()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_value += delta / 2
	rotation = Vector3(sin(_value), 0, cos(_value))
