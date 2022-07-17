extends Node3D

@onready var button_node = $AbstractGrill/TrayButton
@onready var tray_node = $AbstractIngredientTray
@onready var trash = $AbstractTrash

@onready var score_label: Label = $ScoreViewport/Control/Label
var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	button_node.connect("button_pressed", _on_renew_tray)
	tray_node.connect("tray_at_grill", _on_tray_reset)
	trash.connect("on_score_positive", _on_score_positive)
	trash.connect("on_score_negative", _on_score_negative)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_renew_tray():
	tray_node.renew_tray()

func _on_tray_reset():
	button_node.reset()

func _on_score_positive():
	score += 1
	_update_score()
func _on_score_negative():
	score -= 1
	_update_score()
	
func _update_score():

	score_label.text = "%d" % score
