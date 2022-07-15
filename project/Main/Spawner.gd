extends Position3D

var _onscreen := false

func spawn(player:Player)->void:
	if _onscreen:
		var enemy = load("res://Dice/EnemyDie.tscn").instance() as Enemy
		enemy.target = player
		enemy.translation = translation
		enemy.translation.y += 1.73
		get_parent().get_parent().add_child(enemy)
		enemy.set_deferred("level", (randi() % 6) + 1)
		enemy.connect("killed", get_parent().get_parent(), "_on_enemy_killed", [], CONNECT_ONESHOT)


func _on_VisibilityNotifier_camera_entered(_camera)->void:
	_onscreen = true


func _on_VisibilityNotifier_camera_exited(_camera)->void:
	_onscreen = false
