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
		var scene_root = get_parent().get_parent() as Spatial
		enemy.connect("killed", scene_root, "_on_enemy_killed", [], CONNECT_ONESHOT)
		scene_root.connect("game_over", enemy, "_on_Main_game_over", [], CONNECT_ONESHOT)


func _on_VisibilityNotifier_camera_entered(_camera)->void:
	_onscreen = true


func _on_VisibilityNotifier_camera_exited(_camera)->void:
	_onscreen = false
