extends Node2D

@onready var key: Area2D = $Key
@onready var finish_line: Area2D = $FinishLine
@onready var player: CharacterBody2D = $Player
@onready var candles_label: Label = $UI/VBoxContainer/CandlesLabel
@onready var monsters_label: Label = $UI/VBoxContainer/MonstersLabel

var candles_collected = 0
var monsters_killed = 0
var has_key = false
var key_spawned = false

const REQUIRED_CANDLES = 5
const REQUIRED_MONSTERS = 3

func _ready():
 key.visible = false
 key.get_node("CollisionShape2D").set_deferred("disabled", true)
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
  get_tree().change_scene_to_file("res://UI/main_menu.tscn") 
 else:
  print("You need the key first!")
