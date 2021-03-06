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
onready var _options_menu = $OptionsMenu as Panel
onready var _instrux = $InstruxDisplay as Panel
onready var _stat_button = $VBoxContainer/StatButton as Button
onready var _click_sound = $Clicked as AudioStreamPlayer

var _config = ConfigFile.new()
var _music := AudioServer.get_bus_index("Music")
var _sfx := AudioServer.get_bus_index("SFX")

func _ready()->void:
	$VBoxContainer/PlayButton.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_hide_menus()
	var err = _config.load(CONFIGPATH)
	if err != OK:
		_reset_config()
	_update_stats()
	$OptionsMenu/VBoxContainer2/Music.pressed = !AudioServer.is_bus_mute(_music)
	$OptionsMenu/VBoxContainer2/SFX.pressed = !AudioServer.is_bus_mute(_sfx)
	$OptionsMenu/VBoxContainer2/Fullscreen.pressed = OS.window_fullscreen


func _reset_config()->void:
	for name in NAMES:
		_config.set_value("EnemiesKilled", name, 0)
	_config.set_value("Records", "best_time", 0)
	_config.set_value("Records", "most_kills", 0)
	_config.save(CONFIGPATH)


func _hide_menus()->void:
	_stat_menu.visible = false
	_options_menu.visible = false
	_instrux.visible = false


func _update_stats()->void:
	for name in NAMES:
		var label = $StatMenu.find_node(name.capitalize()) as Label
		label.text = name.capitalize() + ": " + str(_config.get_value("EnemiesKilled", name))
	$StatMenu/VBoxContainer8/BestTime.text = "Best Time: " + str(_config.get_value("Records", "best_time"))
	$StatMenu/VBoxContainer8/MostKills.text = "Most Kills: " + str(_config.get_value("Records", "most_kills"))


func _on_StatButton_pressed()->void:
	_stat_menu.visible = true
	$StatMenu/VBoxContainer7/BackButton.grab_focus()
	_click_sound.play()


func _on_BackButton_pressed()->void:
	_hide_menus()
	$VBoxContainer/StatButton.grab_focus()
	_click_sound.play()


func _on_ClearButton_pressed()->void:
	_reset_config()
	_update_stats()
	_click_sound.play()


func _on_PlayButton_pressed()->void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Main/Main.tscn")
	_click_sound.play()


func _on_Options_pressed()->void:
	_options_menu.visible = true
	$OptionsMenu/VBoxContainer2/Music.grab_focus()
	_click_sound.play()


func _on_Music_toggled(button_pressed:bool)->void:
	AudioServer.set_bus_mute(_music, !button_pressed)
	_click_sound.play()


func _on_SFX_toggled(button_pressed:bool)->void:
	AudioServer.set_bus_mute(_sfx, !button_pressed)
	_click_sound.play()


func _on_Fullscreen_toggled(button_pressed:bool)->void:
	OS.window_fullscreen = button_pressed
	_click_sound.play()


func _on_QuitButton_pressed()->void:
	get_tree().quit()
	_click_sound.play()


func _on_InstruxButton_pressed()->void:
	_instrux.visible = true
	$InstruxDisplay/VBoxContainer/BackButton.grab_focus()
	_click_sound.play()


func _on_OptionsBack_pressed()->void:
	_hide_menus()
	$VBoxContainer/Options.grab_focus()
	_click_sound.play()


func _on_InstruxBackButton_pressed()->void:
	_hide_menus()
	$VBoxContainer/InstruxButton.grab_focus()
	_click_sound.play()
