class_name Player
extends CharacterBody3D

signal update_power(new_percentage)
signal update_health(new_value)

@onready var _damage_timer = $DamageTimer as Timer
@onready var _arm_animator = $ArmAnimator as AnimationPlayer
@onready var _bomb_spawn_point = $ThrowPoint as Marker3D
@onready var _hit_area = $Area3D as Area3D

var _percent_powered := 0.0: set = _set_power
var _health := 6

@export var speed := 15

func _physics_process(delta:float)->void:
	if _health <= 0:
		return
	rotation_degrees.y += Input.get_axis("turn_right", "turn_left") * 1.5
	var direction := Vector3(Input.get_axis("right", "left"), 0, Input.get_axis("backward", "forward")).rotated(Vector3.UP, rotation.y)
	move_and_collide(direction * delta * speed)
	if Input.is_action_pressed("throw") and _percent_powered < 1:
		_set_power(_percent_powered + delta)
	if Input.is_action_just_released("throw"):
		_arm_animator.play("Throw")
	_check_for_damage()


func throw()->void:
	var bomb = load("res://Dice/Bomb.tscn").instantiate() as RigidBody3D
	bomb.global_transform = _bomb_spawn_point.global_transform
	get_parent().add_child(bomb)
	bomb.apply_central_impulse(Vector3.BACK.rotated(Vector3.UP, rotation.y) * 30 * _percent_powered)
	_set_power(0.0)


func _check_for_damage()->void:
	for body in _hit_area.get_overlapping_bodies():
		if body is Enemy:
			if _damage_timer.is_stopped():
				_damage_timer.start(0.5)
			return
	_damage_timer.stop()


func _set_power(value:float)->void:
	_percent_powered = value
	update_power.emit(value)


func _on_DamageTimer_timeout()->void:
	if _health <= 0:
		return
	_health -= 1
	$VariableAudio.play()
	update_health.emit(_health)
