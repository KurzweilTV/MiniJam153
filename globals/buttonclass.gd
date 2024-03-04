extends CanvasLayer

var game_scene : PackedScene = load("res://scenes/main.tscn")

func _ready() -> void:
	pass

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_how_to_play_pressed() -> void:
	$menu_panel.hide()
	$tutorial_panel.show()

func _on_exit_pressed() -> void:
	Truck.quit_game()



func _on_back_button_pressed() -> void:
	$tutorial_panel.hide()
	$menu_panel.show()
