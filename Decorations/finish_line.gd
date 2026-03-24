extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_parent().get_node("res://Levels/level_1.gd").finish_line_reached()
