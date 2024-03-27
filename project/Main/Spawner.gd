extends Node3D

var _onscreen := false
var _player : Player
var _level := 1


func spawn(player:Player)->void:
	if _onscreen:
		_player = player
		$AnimationPlayer.play("Spawn")


func _create_enemy()->void:
	var enemy_levels := [randi_range(1, 6)]
	var total_enemy_levels : int = enemy_levels[0]
	while total_enemy_levels < _level:
		var enemy_level := randi_range(1, 6)
		if total_enemy_levels + enemy_level <= _level:
			enemy_levels.append(enemy_level)
			total_enemy_levels += enemy_level
		else:
			break
	for enemy_level in enemy_levels:
		var enemy = load("res://Dice/EnemyDie.tscn").instantiate() as Enemy
		enemy.target = _player
		enemy.position = position
		get_parent().get_parent().add_child(enemy)
		enemy.set_deferred("level", enemy_level)
		await get_tree().create_timer(0.2).timeout


func _on_visible_on_screen_notifier_3d_screen_entered()->void:
	_onscreen = true


func _on_visible_on_screen_notifier_3d_screen_exited()->void:
	_onscreen = false


func _on_level_up_timer_timeout()->void:
	_level += 1
