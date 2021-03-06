class_name Enemy
extends KinematicBody

signal killed(level_name)

const LEVEL_TO_NAME := {
	1:"greeblin",
	2:"hopper",
	3:"devioid",
	4:"observer",
	5:"muncher",
	6:"mastermind"
}
const LEVEL_TO_COLOR := {
	1:"69FF00",
	2:"B80000",
	3:"F0FF00",
	4:"00FFD2",
	5:"E500FF",
	6:"FF9D00",
}

export var speed := 7

onready var _face = $Face as AnimatedSprite3D
onready var _legs = $AnimationPlayer as AnimationPlayer
onready var _body = $CSGBox as CSGBox

var level := 0 setget _set_level
var target : KinematicBody
var _game_over := false


func _ready()->void:
	# warning-ignore:return_value_discarded
	connect("killed", get_parent(), "_on_enemy_killed", [], CONNECT_ONESHOT)
	# warning-ignore:return_value_discarded
	get_parent().connect("game_over", self, "_on_Main_game_over", [], CONNECT_ONESHOT)
	_body.material_override = SpatialMaterial.new()
	_legs.play("Run")


func _physics_process(delta:float)->void:
	if _game_over:
		return
	# warning-ignore:return_value_discarded
	move_and_collide(Vector3.BACK.rotated(Vector3.UP, rotation.y + PI) * speed * delta)


func hit(damage:int)->void:
	if _game_over:
		return
	if level - damage <= 0:
		emit_signal("killed", LEVEL_TO_NAME[level])
	var dead_die = load("res://Dice/DeadDie.tscn").instance() as RigidBody
	dead_die.translation = translation
	dead_die.start = LEVEL_TO_COLOR[level]
	if level - damage > 0:
		dead_die.end = LEVEL_TO_COLOR[level - damage]
		dead_die.level = level - damage
		dead_die.player = target
	else:
		dead_die.end = Color.black
	get_parent().add_child(dead_die)
	var twist := Vector3.ZERO
	match randi() % 3:
		0:
			twist.x = randf()
		1:
			twist.y = randf()
		2:
			twist.z = randf()
	dead_die.apply_impulse(twist, Vector3.BACK.rotated(Vector3.UP, rotation.y) * 50)
	queue_free()


func _set_level(value:int)->void:
	level = value
	if level > 0:
		_body.material_override.albedo_color = LEVEL_TO_COLOR[level]
		_face.play(LEVEL_TO_NAME[level])


func _on_AimTimer_timeout()->void:
	if _game_over:
		return
	look_at(target.translation, Vector3.UP)


func _on_Main_game_over()->void:
	_game_over = true
	_legs.stop()
