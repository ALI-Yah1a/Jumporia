extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_sfx: AudioStreamPlayer2D = $SFX/AttackSFX
@onready var death_sfx: AudioStreamPlayer2D = $SFX/DeathSFX
@onready var jump_sfx: AudioStreamPlayer2D = $SFX/JumpSFX
@onready var run_sfx: AudioStreamPlayer2D = $SFX/RunSFX


const SPEED = 130.0
const JUMP_VELOCITY = -350.0
var direction = 0
var is_attacking = false
var can_attack = true

func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if event.is_action_pressed("attack") and can_attack:
		attack()
func _physics_process(delta):
	
	if velocity.x != 0 and is_on_floor():
		animated_sprite_2d.animation = "run"
		if not run_sfx.playing:
			run_sfx.play()
	else:
		animated_sprite_2d.animation = "idle"
		run_sfx.stop()
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sfx.play()

	elif velocity.y > 0.0:
		animated_sprite_2d.play("fall")
	
	

	direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:           
		velocity.x = move_toward(velocity.x, 0, SPEED )

	move_and_slide()

	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
	
	if is_attacking:
		velocity.x = 0
		move_and_slide()
		return
func attack():
	is_attacking = true
	can_attack = false
	animated_sprite_2d.play("attack")
	attack_sfx.play()
	$Hitbox.monitoring = true


func die():
	print("Player is dying...")
		
	set_physics_process(false)
	animated_sprite_2d.play("death")
	death_sfx.play()
	
	await get_tree().create_timer(0.6).timeout 
	
	get_tree().reload_current_scene()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "attack":
		is_attacking = false
		can_attack = true
		$Hitbox.monotoring = false
