extends Spatial

const CONFIGPATH := "user://polyarena.cfg"

onready var _spawns = $Spawns as Spatial
onready var _player = $PlayerDie as Player
onready var _hud = $HUD as CanvasLayer

var _time_elapsed := 0


func _ready()->void:
	randomize()


func _on_SpawnTimer_timeout()->void:
	for spawn_point in _spawns.get_children():
		spawn_point.spawn(_player)


func _on_enemy_killed(enemy_type:String)->void:
	var config = ConfigFile.new()
	var err = config.load(CONFIGPATH)
	if err != OK:
		print("could not load file")
		return
	config.set_value("EnemiesKilled",
		enemy_type,
		config.get_value("EnemiesKilled", enemy_type) + 1
	)
	config.save(CONFIGPATH)


func _on_GameTimer_timeout()->void:
	_time_elapsed += 1
	_hud.time = _time_elapsed


func _on_PlayerDie_update_power(new_percentage:float)->void:
	_hud.percent_powered = new_percentage
