extends Node2D

@onready var key: Area2D = $Key
@onready var finish_line: Area2D = $FinishLine
@onready var player: CharacterBody2D = $Player
@onready var candles_label: Label = $UI/VBoxContainer/CandlesLabel
@onready var monsters_label: Label = $UI/VBoxContainer/MonstersLabel
@onready var objective_label: Label = $UI/VBoxContainer/ObjectiveLabel
@onready var level_complete_ui: CanvasLayer = $LevelCompleteUI
@onready var main_menu_button: Button = $LevelCompleteUI/HBoxContainer/MainMenuButton
@onready var button_sfx: AudioStreamPlayer = $LevelCompleteUI/ButtonSFX
@onready var end_sfx: AudioStreamPlayer = $EndSFX

var candles_collected = 0
var monsters_killed = 0
var has_key = false
var key_spawned = false

const REQUIRED_CANDLES = 20
const REQUIRED_MONSTERS = 10

func _ready():
 key.visible = false
 key.get_node("CollisionShape2D").set_deferred("disabled", true)
 level_complete_ui.visible = false
 main_menu_button.pressed.connect(_on_main_menu_pressed)
 
 objective_label.text = "Complete the objectives to get the key."
 
 update_ui()

func update_ui():
 candles_label.text = "Candles: " + str(candles_collected) + " / " + str(REQUIRED_CANDLES)
 monsters_label.text = "Monsters: " + str(monsters_killed) + " / " + str(REQUIRED_MONSTERS)

func candle_collected():
 candles_collected += 1
 update_ui()
 check_ready_to_finish()

func monster_killed():
 monsters_killed += 1
 update_ui()
 check_ready_to_finish()

func key_collected():
 has_key = true
 objective_label.text = "Go to the finish line."

func check_ready_to_finish():
 if not key_spawned and candles_collected >= REQUIRED_CANDLES and monsters_killed >= REQUIRED_MONSTERS:
  spawn_key_above_player()

func spawn_key_above_player():
 key_spawned = true
 key.global_position = player.global_position + Vector2(0, -60)
 key.visible = true
 key.get_node("CollisionShape2D").set_deferred("disabled", false)
 
 var tween = get_tree().create_tween()
 tween.tween_property(key, "global_position", key.global_position + Vector2(0, 20), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func finish_line_reached():
 if has_key:
  get_tree().paused = true
  end_sfx.play()
  await end_sfx.finished
  level_complete_ui.visible = true
 else:
  print("You need the key first!")

func _on_main_menu_pressed():
 get_tree().paused = false
 get_tree().change_scene_to_file("res://UI/main_menu.tscn")
