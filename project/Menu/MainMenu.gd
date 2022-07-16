extends Control

const CONFIGPATH := "user://polyarena.cfg"
const NAMES := [
	"mastermind",
	"muncher",
	"devioid",
	"observer",
	"hopper",
	"greeblin",
]

onready var _stat_menu = $StatMenu as Panel

var _config = ConfigFile.new()

func _ready()->void:
	_stat_menu.visible = false
	var err = _config.load(CONFIGPATH)
	if err != OK:
		print("could not load config")
		return
	_update_stats()


func _update_stats()->void:
	for name in NAMES:
		var label = $StatMenu.find_node(name.capitalize()) as Label
		label.text = name.capitalize() + ":\n" + str(_config.get_value("EnemiesKilled", name))
	$StatMenu/VBoxContainer8/BestTime.text = "Best Time: " + str(_config.get_value("Records", "best_time"))
	$StatMenu/VBoxContainer8/MostKills.text = "Most Kills: " + str(_config.get_value("Records", "most_kills"))


func _on_StatButton_pressed()->void:
	_stat_menu.visible = true


func _on_BackButton_pressed()->void:
	_stat_menu.visible = false


func _on_ClearButton_pressed()->void:
	for name in NAMES:
		_config.set_value("EnemiesKilled", name, 0)
	_config.set_value("Records", "best_time", 0)
	_config.set_value("Records", "most_kills", 0)
	_config.save(CONFIGPATH)
	_update_stats()


func _on_PlayButton_pressed()->void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/Main.tscn")
