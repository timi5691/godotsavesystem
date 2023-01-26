extends Control

signal new_game
signal continue_game
signal exit_game

func _on_button_newgame_pressed():
	new_game.emit()



func _on_button_exit_pressed():
	exit_game.emit()



func _on_button_continue_pressed():
	continue_game.emit()
