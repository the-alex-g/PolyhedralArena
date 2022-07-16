extends Spatial

var _onscreen := false
var _player

func spawn(player:Player)->void:
	if _onscreen:
		_player = player
		$AnimationPlayer.play("Spawn")


func _create_enemy()->void:
	var enemy = load("res://Dice/EnemyDie.tscn").instance() as Enemy
	enemy.target = _player
	enemy.translation = translation
	enemy.translation.y += 1.73
	get_parent().get_parent().add_child(enemy)
	enemy.set_deferred("level", (randi() % 6) + 1)


func _on_VisibilityNotifier_camera_entered(_camera)->void:
	_onscreen = true


func _on_VisibilityNotifier_camera_exited(_camera)->void:
	_onscreen = false
