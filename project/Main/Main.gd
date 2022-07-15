extends Spatial

const CONFIGPATH := "user://polyarena.cfg"

onready var _spawns = $Spawns as Spatial
onready var _player = $PlayerDie as Player


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
