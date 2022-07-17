extends CPUParticles3D

# How long between random changes
@export var idle_rate = 10
@onready var timer: Timer = $Timer

@onready var light: OmniLight3D = $OmniLight3D
@onready var area: Area3D = $Area3D

@export var amount_curve: Curve
@export var lifetime_curve: Curve

@export var scale_min = 0.25
@export var scale_max = 0.50

@export var light_min = 0
@export var light_max = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = idle_rate
	timer.timeout.connect(_on_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timeout():
	# Randomly decide how strong this flame will be
	_scale_particle_power(randf())

func _scale_particle_power(power: float):
	print("power to %f" % power)
	#amount = amount_curve.interpolate(power)
	#lifetime = lifetime_curve.interpolate(power)
	scale_amount_min = scale_min * power
	scale_amount_max = scale_max * power
	light.light_energy = (light_max - light_min) * power
	area.intensity = power
