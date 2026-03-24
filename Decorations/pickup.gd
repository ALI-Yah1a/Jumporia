extends Area2D
@onready var pickup_sound: AudioStreamPlayer2D = $PickupSound
func _on_body_entered(body):
	if body.name == "Player":
		pickup_sound.play()
		hide()
		await pickup_sound.finished
		queue_free()
