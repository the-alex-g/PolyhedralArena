class_name Player
extends KinematicBody

signal update_power(new_percentage)
signal update_health(new_value)

onready var _damage_timer = $DamageTimer as Timer
onready var _arm_animator = $ArmAnimator as AnimationPlayer
onready var _bomb_spawn_point = $ThrowPoint as Position3D
onready var _hit_area = $Area as Area

export var speed := 15

var _percent_powered := 0.0 setget _set_power
var _colliding_with_enemy := false
var _health := 6

func _physics_process(delta:float)->void:
	if _health <= 0:
		return
	rotation_degrees.y += Input.get_axis("turn_right", "turn_left") * 1.5
	var direction := Vector3(Input.get_axis("right", "left"), 0, Input.get_axis("backward", "forward")).rotated(Vector3.UP, rotation.y)
	# warning-ignore:return_value_discarded
	move_and_collide(direction * delta * speed)
	if Input.is_action_pressed("throw") and _percent_powered < 1:
		_set_power(_percent_powered + delta)
	if Input.is_action_just_released("throw"):
		_arm_animator.play("Throw")
	if _colliding_with_enemy:
		_check_for_damage()


func throw()->void:
	var bomb = load("res://Dice/Bomb.tscn").instance() as RigidBody
	bomb.global_transform = _bomb_spawn_point.global_transform
	get_parent().add_child(bomb)
	bomb.apply_central_impulse(Vector3.BACK.rotated(Vector3.UP, rotation.y) * 60 * _percent_powered)
	_set_power(0.0)


func _check_for_damage()->void:
	var enemies := false
	for body in _hit_area.get_overlapping_bodies():
		if body is Enemy:
			enemies = true
			break
	if not enemies:
		_damage_timer.stop()


func _set_power(value:float)->void:
	_percent_powered = value
	emit_signal("update_power", value)


func _on_Area_body_entered(body:PhysicsBody)->void:
	if body is Enemy:
		_colliding_with_enemy = true
		_damage_timer.start(0.5)


func _on_DamageTimer_timeout()->void:
	if _health <= 0:
		return
	_health -= 1
	$VariableAudio.play()
	emit_signal("update_health", _health)
