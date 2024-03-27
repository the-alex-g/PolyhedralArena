extends Node3D

var _onscreen := false
var _player

func spawn(player:Player)->void:
	if _onscreen:
		_player = player
		$AnimationPlayer.play("Spawn")


func _create_enemy()->void:
	var enemy = load("res://Dice/EnemyDie.tscn").instantiate() as Enemy
	enemy.target = _player
	enemy.position = position
	enemy.position.y += 1.73
	get_parent().get_parent().add_child(enemy)
	enemy.set_deferred("level", (randi() % 6) + 1)


func _on_visible_on_screen_notifier_3d_screen_entered()->void:
	_onscreen = true


func _on_visible_on_screen_notifier_3d_screen_exited()->void:
	_onscreen = false
