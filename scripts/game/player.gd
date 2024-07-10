extends CharacterBody2D


@onready var move_input_component: MoveInputComponent = $MoveInputComponent
@onready var move_component: MoveComponent = $MoveComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var scale_component: ScaleComponent = $ScaleComponent
@onready var flash_component: FlashComponent = $FlashComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var last_direction : String = "right"
var idle_animations : Dictionary = {
	"left": ["idle_right", true],
	"right": ["idle_right", false],
	"up": ["idle_up", false],
	"down": ["idle", false]}
var walk_animations : Dictionary = {
	"left": ["walk_right", true],
	"right": ["walk_right", false],
	"up": ["walk_up", false],
	"down": ["walk_down", false]}

var _is_dead : bool = false


func _ready() -> void:
	move_input_component.last_direction_pressed.connect(func(x: String): last_direction = x)


func _physics_process(_delta: float) -> void:
	if _is_dead:
		return
	move_and_slide()
	update_animation()


func update_animation() -> void:
	# conditionally defines animation variable
	var animations = idle_animations if move_component.velocity == Vector2.ZERO else walk_animations
	
	if last_direction in animations:
		var animation_data = animations[last_direction]
		animated_sprite_2d.play(animation_data[0])
		animated_sprite_2d.flip_h = animation_data[1]


func _on_health_component_damage_taken(_value: float) -> void:
	scale_component.tween_scale()
	flash_component.flash()
	# fake knockback
	var knockback : float = 15
	global_position += Vector2(randf_range(-knockback, knockback), randf_range(-knockback, knockback))


func _on_health_component_health_depleted() -> void:
	_is_dead = true
	move_input_component.disable_input()
	animated_sprite_2d.play("death")
