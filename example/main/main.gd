extends  Control

@onready var save_sys: SaveSystem = $gui/form_save_and_load

func _init():
	randomize()

func _ready():
	$gui/form_title_menu.show()
	$gui/form_save_and_load.hide()
	

##############################################################
# events
func _on_form_save_and_load_save_game_btn_pressed():
	var password = "abcd4567"
	save_sys.save_game(password)

func _on_form_save_and_load_load_game_btn_pressed():
	var password = "abcd4567"
	save_sys.load_game(password)
	$gui/form_title_menu.hide()

func _on_form_title_menu_exit_game():
	get_tree().call_deferred("quit")

func _on_form_title_menu_continue_game():
	$gui/form_save_and_load.show_load_form()

func _on_form_title_menu_new_game():
	$gui/form_title_menu.hide()

func _on_button_save_pressed():
	$gui/form_save_and_load.show_save_form()

func _on_button_load_pressed():
	$gui/form_save_and_load.show_load_form()


func _on_form_save_and_load_visibility_changed():
	get_tree().paused = $gui/form_save_and_load.visible
	


