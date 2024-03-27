extends Node3D

signal game_over

const CONFIGPATH := "user://polyarena.cfg"
const NAME_TO_LEVEL := {
	"greeblin":1,
	"hopper":2,
	"devioid":3,
	"observer":4,
	"muncher":5,
	"mastermind":6
}

@onready var _spawns : Node3D = $Spawns
@onready var _player : Player = $PlayerDie
@onready var _hud : CanvasLayer = $HUD

var _score := 0.0
var _config := ConfigFile.new()


func _ready()->void:
	randomize()
	_config.load(CONFIGPATH)


func _on_SpawnTimer_timeout()->void:
	_spawn()


func _spawn()->void:
	for spawn_point in _spawns.get_children():
		spawn_point.spawn(_player)


func _on_enemy_killed(enemy_type:String)->void:
	_config.set_value("EnemiesKilled",
		enemy_type,
		_config.get_value("EnemiesKilled", enemy_type, 0) + 1
	)
	_config.save(CONFIGPATH)
	_score += NAME_TO_LEVEL[enemy_type]
	_hud.score = round(_score)


func _on_GameTimer_timeout()->void:
	_score += 0.2
	_hud.score = round(_score)


func _on_PlayerDie_update_power(new_percentage:float)->void:
	_hud.percent_powered = new_percentage


func _on_PlayerDie_update_health(new_value:int)->void:
	_hud.health = new_value
	if new_value <= 0:
		if round(_score) > _config.get_value("Records", "best_score", 0):
			_config.set_value("Records", "best_score", round(_score))
			_config.save(CONFIGPATH)
		_hud.display_game_over(_config.get_value("Records", "best_score", 0))
		game_over.emit()
		$SpawnTimer.stop()
		$GameTimer.stop()
