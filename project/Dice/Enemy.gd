extends KinematicBody

const LEVEL_TO_NAME := {
	1:"greeblin",
	2:"hopper",
	3:"deviod",
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

export var speed := 200

onready var _face = $Face as AnimatedSprite
onready var _legs = $AnimationPlayer as AnimationPlayer
onready var _body = $CSGBox as CSGBox

var _level := 0


func _ready()->void:
	_body.material.albedo_color = LEVEL_TO_COLOR[_level]


func hit(damage:int)->void:
	var previous_level := _level
	_level -= damage
	if _level > 0:
		_body.material.albedo_color = LEVEL_TO_COLOR[_level]
		_face.play(LEVEL_TO_NAME[_level])
