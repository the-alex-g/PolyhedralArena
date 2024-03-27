extends Control

const CONFIGPATH := "user://polyarena.cfg"
const ENEMY_NAMES := [
	"mastermind",
	"muncher",
	"devioid",
	"observer",
	"hopper",
	"greeblin",
]

@onready var _stat_menu = $StatMenu as Panel
@onready var _options_menu = $OptionsMenu as Panel
@onready var _instrux = $InstruxDisplay as Panel
@onready var _stat_button = $VBoxContainer/StatButton as Button
@onready var _click_sound = $Clicked as AudioStreamPlayer

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
	$OptionsMenu/VBoxContainer2/Music.button_pressed = !AudioServer.is_bus_mute(_music)
	$OptionsMenu/VBoxContainer2/SFX.button_pressed = !AudioServer.is_bus_mute(_sfx)
	$OptionsMenu/VBoxContainer2/Fullscreen.button_pressed = ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))


func _reset_config()->void:
	for enemy_name in ENEMY_NAMES:
		_config.set_value("EnemiesKilled", enemy_name, 0)
	_config.set_value("Records", "best_time", 0)
	_config.set_value("Records", "most_kills", 0)
	_config.save(CONFIGPATH)


func _hide_menus()->void:
	_stat_menu.visible = false
	_options_menu.visible = false
	_instrux.visible = false


func _update_stats()->void:
	for enemy_name in ENEMY_NAMES:
		var label = $StatMenu.find_child(enemy_name.capitalize()) as Label
		label.text = enemy_name.capitalize() + ": " + str(_config.get_value("EnemiesKilled", enemy_name))
	$StatMenu/VBoxContainer8/BestTime.text = "Best Time: " + str(_config.get_value("Records", "best_time"))
	$StatMenu/VBoxContainer8/MostKills.text = "Most Kills: " + str(_config.get_value("Records", "most_kills"))


func _on_StatButton_pressed()->void:
	_stat_menu.visible = true
	$StatMenu/VBoxContainer7/BackButton.grab_focus()
	_click_sound.play()


func _on_BackButton_pressed()->void:
	_hide_menus()
	_stat_button.grab_focus()
	_click_sound.play()


func _on_ClearButton_pressed()->void:
	_reset_config()
	_update_stats()
	_click_sound.play()


func _on_PlayButton_pressed()->void:
	get_tree().change_scene_to_file("res://Main/Main.tscn")


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
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (button_pressed) else Window.MODE_WINDOWED
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
