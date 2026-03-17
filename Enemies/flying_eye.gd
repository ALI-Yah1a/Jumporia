extends CharacterBody2D
class_name Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var killzone: Area2D = $Killzone
@onready var ground_ray: RayCast2D = $GroundRay


var speed = 120
var direction = 1
var is_alive = true

func _physics_process(delta):
	if not is_alive:
		return
	if is_on_wall():
		direction *= -1
	if not ground_ray.is_colliding():
		direction *= -1
	velocity.x = speed * direction
	move_and_slide()
	if  direction != 0:
		animated_sprite_2d.play("idle")
		animated_sprite_2d.flip_h = direction < 0
func die():
	if not is_alive:
		return
	is_alive = false 
	velocity = Vector2.ZERO
	animated_sprite_2d.play("death")
	collision_shape_2d.disabled = true
	killzone.monitoring = false
	await get_tree().create_timer(0.5).timeout
	queue_free()

	


func _on_killzone_body_entered(body: Node2D) -> void:
	if not is_alive:
		return
	if body.is_in_group("player"):
		if body.is_attacking:
			die()
		else:
			body.die()
