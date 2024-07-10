class_name EnemyFollow
extends State

@export var enemy : CharacterBody2D
@export var move_component : MoveComponent
@export var vision_area : Area2D
@export var movement_speed : float = 20.0
@export var follow_trigger_distance : float = 25.0
@export var follow_exit_distance : float = 50.0

var _target : CharacterBody2D


func Enter() -> void:
	enemy.update_animation("follow")
	if !vision_area:
		return
	
	vision_area.body_entered.connect(func(x : CharacterBody2D): _target = x)


func Physics_Update(_delta: float) -> void:
	if !_target:
		return
	
	var direction = _target.global_position - enemy.global_position
	
	if direction.length() > follow_trigger_distance:
		move_component.velocity = direction.normalized() * movement_speed
	else:
		move_component.velocity = Vector2.ZERO
	
	if direction.length() > follow_exit_distance:
		Transitioned.emit(self, "idle")
