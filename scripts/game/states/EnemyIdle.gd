extends State
class_name EnemyIdle


@export var enemy : CharacterBody2D
@export var move_component : MoveComponent
@export var vision_area : Area2D
@export var movement_speed : float = 10.0

var _move_direction : Vector2
var _wander_time : float


func _randomize_wander() -> void:
	_move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	_wander_time = randf_range(1, 3)


func Enter() -> void:
	enemy.update_animation("idle")
	_randomize_wander()
	vision_area.body_entered.connect(func(_x): Transitioned.emit(self, "follow"))


func Update(delta: float) -> void:
	if _wander_time > 0:
		_wander_time -= delta
	else:
		_randomize_wander()


func Physics_Update(_delta: float) -> void:
	if move_component:
		move_component.velocity = _move_direction * movement_speed
