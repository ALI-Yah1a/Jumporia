extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_sfx: AudioStreamPlayer2D = $SFX/AttackSFX
@onready var death_sfx: AudioStreamPlayer2D = $SFX/DeathSFX
@onready var hp_label: Label = $HPLabel

const SPEED = 280.0
const JUMP_VELOCITY = -480.0

var direction = 0
var is_attacking = false
var can_attack = true
var is_hurt = false
var max_hp = 4
var current_hp = 4

func _ready():
 update_hp_label()

func update_hp_label():
 hp_label.text = str(current_hp) + "/" + str(max_hp)

func _input(event):
 if is_hurt:
  return
 if event.is_action_pressed("jump") and is_on_floor():
  velocity.y = JUMP_VELOCITY
 if event.is_action_pressed("attack") and can_attack:
  attack()

func _physics_process(delta):
 if is_hurt:
  velocity.x = 0
  if not is_on_floor():
   velocity += get_gravity() * delta
  move_and_slide()
  return


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
  animated_sprite_2d.play("jump")
  
 direction = Input.get_axis("move_left", "move_right")
 if direction:
  velocity.x = direction * SPEED
 else:
  velocity.x = move_toward(velocity.x, 0, SPEED)

 move_and_slide()

 if direction == 1.0:
  animated_sprite_2d.flip_h = false
  animated_sprite_2d.position.x = 0
  $Hitbox.position.x = abs($Hitbox.position.x)
 elif direction == -1.0:
  animated_sprite_2d.flip_h = true
  animated_sprite_2d.position.x = -9
  $Hitbox.position.x = -abs($Hitbox.position.x)

 if not is_on_floor():
  if velocity.y < 0.0:
   animated_sprite_2d.play("jump")
  elif velocity.y > 0.0:
   animated_sprite_2d.play("fall")
 elif velocity.x != 0:
  animated_sprite_2d.play("run")
 else:
  animated_sprite_2d.play("idle")

func attack():
 is_attacking = true
 can_attack = false
 animated_sprite_2d.play("attack")
 attack_sfx.play()
 $Hitbox.monitoring = true

func take_damage(amount):
 if is_hurt:
  return
 current_hp -= amount
 update_hp_label()
 if current_hp > 0:
  is_hurt = true
  animated_sprite_2d.play("hurt")
  await get_tree().create_timer(0.3).timeout
  is_hurt = false
 if current_hp <= 0:
  die()

func die():
 set_physics_process(false)
 animated_sprite_2d.play("death")
 death_sfx.play()
 await get_tree().create_timer(1).timeout
 get_tree().reload_current_scene()

func _on_animated_sprite_2d_animation_finished():
 if animated_sprite_2d.animation == "attack":
  is_attacking = false
  can_attack = true
  $Hitbox.monitoring = false
