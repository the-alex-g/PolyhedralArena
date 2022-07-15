class_name Enemy
extends KinematicBody

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

export var speed := 10

onready var _face = $Face as AnimatedSprite3D
onready var _legs = $AnimationPlayer as AnimationPlayer
onready var _body = $CSGBox as CSGBox

var level := 0 setget _set_level
var target : KinematicBody


func _physics_process(delta:float)->void:
	# warning-ignore:return_value_discarded
	move_and_collide(Vector3.BACK.rotated(Vector3.UP, rotation.y + PI) * speed * delta)


func hit(damage:int)->void:
	_set_level(level - damage)


func _set_level(value:int)->void:
	level = value
	if level > 0:
		_body.material_override.albedo_color = LEVEL_TO_COLOR[level]
		_face.play(LEVEL_TO_NAME[level])


func _on_AimTimer_timeout()->void:
	look_at(target.translation, Vector3.UP)
