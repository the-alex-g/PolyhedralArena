extends RigidBody3D

var start : Color
var end : Color
var player : Player
var level := 0

@onready var _die : CSGBox3D = $Die


func _ready()->void:
	_die.material_override = StandardMaterial3D.new()
	_die.material_override.albedo_color = start
	create_tween().tween_property(_die.material_override, "albedo_color", end, 1).set_trans(Tween.TRANS_QUAD)


func _on_Timer_timeout()->void:
	if level > 0:
		var enemy = load("res://Dice/EnemyDie.tscn").instantiate()
		enemy.target = player
		enemy.position = position
		enemy.position.y = 1.73
		get_parent().add_child(enemy)
		enemy.set_deferred("level", level)
	queue_free()
