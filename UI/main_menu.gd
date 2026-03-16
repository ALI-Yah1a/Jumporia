extends Control
@onready var buttons: VBoxContainer = $Buttons
@onready var options: Panel = $Options


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons.visible = true
	options.visible = false


func _on_start_pressed() -> void:
	pass # Replace with function body.


func _on_options_2_pressed() -> void:
	buttons.visible = false
	options.visible = true


func _on_exit_3_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	_ready()
