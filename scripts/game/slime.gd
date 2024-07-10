extends CharacterBody2D

@onready var move_component: MoveComponent = $MoveComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	move_and_slide()
	if move_component.velocity.length() > 0:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true


func update_animation(animation : String):
	if !animated_sprite_2d:
		return
	
	match animation:
		"idle":
			animated_sprite_2d.play("idle")
		"follow":
			animated_sprite_2d.play("move_down")
	
