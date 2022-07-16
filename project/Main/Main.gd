extends Spatial

signal game_over

const CONFIGPATH := "user://polyarena.cfg"

onready var _spawns = $Spawns as Spatial
onready var _player = $PlayerDie as Player
onready var _hud = $HUD as CanvasLayer

var _time_elapsed := 0
var _kills := 0
var _config := ConfigFile.new()


func _ready()->void:
	randomize()
	var err := _config.load(CONFIGPATH)
	if err != OK:
		print("could not load config")
	yield(get_tree().create_timer(0.1), "timeout")
	_spawn()


func _on_SpawnTimer_timeout()->void:
	_spawn()


func _spawn()->void:
	for spawn_point in _spawns.get_children():
		spawn_point.spawn(_player)


func _on_enemy_killed(enemy_type:String)->void:
	_config.set_value("EnemiesKilled",
		enemy_type,
		_config.get_value("EnemiesKilled", enemy_type) + 1
	)
	# warning-ignore:return_value_discarded
	_config.save(CONFIGPATH)
	_kills += 1
	_hud.kills = _kills


func _on_GameTimer_timeout()->void:
	_time_elapsed += 1
	_hud.time = _time_elapsed


func _on_PlayerDie_update_power(new_percentage:float)->void:
	_hud.percent_powered = new_percentage


func _on_PlayerDie_update_health(new_value:int)->void:
	_hud.health = new_value
	if new_value <= 0:
		if _kills > _config.get_value("Records", "most_kills"):
			_config.set_value("Records", "most_kills", _kills)
			# warning-ignore:return_value_discarded
			_config.save(CONFIGPATH)
		if _time_elapsed > _config.get_value("Records", "best_time"):
			_config.set_value("Records", "best_time", _time_elapsed)
			# warning-ignore:return_value_discarded
			_config.save(CONFIGPATH)
		_hud.display_game_over(_config.get_value("Records", "best_time"), _config.get_value("Records", "most_kills"))
		emit_signal("game_over")
		$SpawnTimer.stop()
		$GameTimer.stop()
