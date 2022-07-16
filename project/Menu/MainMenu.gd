extends Control

const NAMES := [
	"mastermind",
	"muncher",
	"devioid",
	"observer",
	"hopper",
	"greeblin",
]

onready var _stat_menu = $StatMenu as Panel

func _ready()->void:
	var config := ConfigFile.new()
	var err = config.load("user://polyarena.cfg")
	if err != OK:
		print("could not load config")
		return
	for name in NAMES:
		var label = $StatMenu.find_node(name.capitalize()) as Label
		label.text = name.capitalize() + ":\n" + str(config.get_value("EnemiesKilled", name))


func _on_Button_pressed()->void:
	_stat_menu.visible = true


func _on_BackButton_pressed()->void:
	_stat_menu.visible = false
