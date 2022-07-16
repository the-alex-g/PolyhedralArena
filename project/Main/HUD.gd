extends CanvasLayer

onready var _time_display = $Label as Label
onready var _power_display = $ProgressBar as ProgressBar
onready var _health_animator = $AnimationPlayer as AnimationPlayer

var time := 0 setget _set_time
var percent_powered := 0.0 setget _set_power
var health := 6 setget _set_health


func _set_time(value:int)->void:
	time = value
	_time_display.text = str(time)


func _set_power(value:float)->void:
	percent_powered = value
	_power_display.value = percent_powered * 100


func _set_health(value:int)->void:
	health = value
	if health > 0:
		_health_animator.play(str(health))
