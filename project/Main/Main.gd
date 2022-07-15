extends Spatial

onready var _spawns = $Spawns as Spatial
onready var _player = $PlayerDie as Player
onready var _enemy_container = $EnemyContainer as Spatial


func _ready()->void:
	randomize()


func _on_SpawnTimer_timeout()->void:
	var spawn_index := randi() % 6
	var spawn_point = _spawns.get_child(spawn_index) as Position3D
	var enemy = load("res://Dice/EnemyDie.tscn").instance() as Enemy
	enemy.target = _player
	enemy.translation = spawn_point.translation
	enemy.translation.y += 1.73
	_enemy_container.add_child(enemy)
	enemy.set_deferred("level", (randi() % 6) + 1)
