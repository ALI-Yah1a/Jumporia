extends Area2D

@onready var pickup_sound = $PickupSound
func _on_body_entered(body):
	
	if body.is_in_group("player") :
		get_parent().get_node("res://Levels/level_1.gd").key_collected()
		collect()
		
		
func collect():
	$CollisionShape2D.disabled = true
	pickup_sound.play()
	await pickup_sound.finished
	queue_free()
