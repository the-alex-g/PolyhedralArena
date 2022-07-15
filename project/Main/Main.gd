extends Spatial

onready var _spawns = $Spawns as Spatial
onready var _player = $PlayerDie as Player


func _ready()->void:
	randomize()


func _on_SpawnTimer_timeout()->void:
	for spawn_point in _spawns.get_children():
		spawn_point.spawn(_player)
