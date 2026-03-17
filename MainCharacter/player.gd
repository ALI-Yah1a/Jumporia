extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_sfx: AudioStreamPlayer2D = $SFX/AttackSFX
@onready var death_sfx: AudioStreamPlayer2D = $SFX/DeathSFX

@onready var run_sfx: AudioStreamPlayer2D = $SFX/RunSFX

const SPEED = 280.0
const JUMP_VELOCITY = -550.0

var direction = 0
var is_attacking = false
var can_attack = true

func _input(event):
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if event.is_action_pressed("attack") and can_attack:
		attack()

func _physics_process(delta):

	if is_attacking:
		velocity.x = 0
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	direction = Input.get_axis("move_left", "move_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true

	if not is_on_floor():
		animated_sprite_2d.play("fall")
		if run_sfx.playing:
			run_sfx.stop()
	elif velocity.x != 0:
		animated_sprite_2d.play("run")
		if not run_sfx.playing:
			run_sfx.play()
	else:
		animated_sprite_2d.play("idle")
		if run_sfx.playing:
			run_sfx.stop()

func attack():
	is_attacking = true
	can_attack = false
	animated_sprite_2d.play("attack")
	run_sfx.stop()
	attack_sfx.play()
	$Hitbox.monitoring = true

func die():
	set_physics_process(false)
	animated_sprite_2d.play("death")
	death_sfx.play()
	await get_tree().create_timer(0.6).timeout
	get_tree().reload_current_scene()

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "attack":
		is_attacking = false
		can_attack = true
		$Hitbox.monitoring = false
