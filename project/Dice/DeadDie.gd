extends RigidBody

onready var _tween = $Tween as Tween

var start : Color
var end : Color
var player : Player
var level : int


func _ready()->void:
	_tween.interpolate_property($Die.material_override, "albedo_color", start, end, 1, Tween.TRANS_QUAD)
	_tween.start()


func _on_Timer_timeout()->void:
	if level > 0:
		var enemy = load("res://Dice/EnemyDie.tscn").instance()
		enemy.target = player
		enemy.translation = translation
		enemy.translation.y = 1.73
		get_parent().add_child(enemy)
		enemy.set_deferred("level", level)
	queue_free()
