extends Node2D
@onready var key: Area2D = $Key
@onready var finish_line: Area2D = $FinishLine

var candles_collected = 0
var monsters_killed = 0
var has_key = false
const REQUIRED_CANDLES = 1
const REQUIRED_MONSTERS = 1

func candle_collected():
	candles_collected += 1
	
func monster_killed():
	monsters_killed += 1
func key_collected():
	has_key = true
	
func check_ready_to_finish():
	if has_key and candles_collected >= REQUIRED_CANDLES and monsters_killed >= REQUIRED_MONSTERS:
		finish_line.visible = true
		finish_line.disabled = false
		key.visible = true
	else:
		finish_line.visible = false
		finish_line.disabled = true
		key.visible = false
		
func finish_line_reached():
	if has_key and candles_collected >= REQUIRED_CANDLES and monsters_killed >= REQUIRED_MONSTERS:
		get_tree().change_scene_to_file("res://UI/main_menu.tscn") 
	else:
		print("You need the key first!")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
