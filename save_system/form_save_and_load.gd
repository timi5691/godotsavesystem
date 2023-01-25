# every objects want to save must have 
# var obj_name = "xyz"
# add_to_group("save")
#func get_save_properties() -> Dictionary:
#	return {
#		"file_path": scene_file_path,
#		"parent_path": str(get_path()).replace("/" + name, ""),
#		"obj_name": obj_name,
#	}


######### HOW TO USE ##########

# connect save_game_button_pressed, load_game_button_pressed
# to a scen. or you can save directly by call save_game(password) to save.
# and call laod_game(password) to load default saved game.
# 
# to show save form, call: show_save_form()
# to show load form, call: show_load_form()

class_name SaveSystem
extends Control

signal save_game_btn_pressed
signal load_game_btn_pressed

func delete_a_saved_file(file_name: String):
	DirAccess.remove_absolute("user://saved/" + file_name)

func save_game_data(save_name: String, game_data: Dictionary, password: String) -> bool:
	var content = game_data.duplicate(true)
	if !DirAccess.dir_exists_absolute("user://saved/"):
		DirAccess.make_dir_absolute("user://saved/")
	var f = FileAccess.open_encrypted_with_pass("user://saved/" + save_name + ".sav", FileAccess.WRITE, password)
	f.store_var(content, true)
	return true

func load_game_data(load_name: String, password: String) -> Dictionary:
	var path = "user://saved/" + load_name + ".sav"
	var f = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, password)
	if f:
		return f.get_var(true)
	return {}

func list_saved_files(is_sort: bool) -> Array:
	var result_list = []
	var dir = DirAccess.open("user://saved/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				result_list.append(file_name)
			file_name = dir.get_next()
	if is_sort:
		result_list.sort()
	return result_list


func is_game_data_loaded(content: Dictionary) -> bool:
	return content.size() > 0

#####################################################
# gui funcs
func update_itemlist(itemlist: ItemList, saved_files: Array):
	itemlist.clear()
	for i in saved_files:
		itemlist.add_item(i, null, true)


func show_save_form():
	$form_load_game.hide()
	$form_save.show()
	show()

func show_load_form():
	$form_save.hide()
	$form_load_game.show()
	show()

func close():
	hide()
	$form_load_game.hide()
	$form_save.hide()

func save_game(password):
	var game_data: Dictionary = {
		"objects": {},
	}
	for obj in get_tree().get_nodes_in_group("save"):
		game_data["objects"][obj.obj_name] = obj.get_save_properties()
	var save_name = $form_save/save_name_input.text
	save_game_data(save_name, game_data, password)
	var saved_files_list = list_saved_files(true)
	update_itemlist($ItemList_saved, saved_files_list)
	close()

func load_game(password):
	if $ItemList_saved.is_anything_selected():
		for obj in get_tree().get_nodes_in_group("save"):
			obj.queue_free()
		var selected = $ItemList_saved.get_selected_items()[0]
		var saved_file_name = $ItemList_saved.get_item_text(selected)
		saved_file_name = saved_file_name.replace(".sav", "")
		var new_game_data = load_game_data(saved_file_name, password)
		add_new_objects(new_game_data)
	close()

func add_new_objects(new_game_data):
	for obj_name in new_game_data["objects"]:
		var obj_file_path = new_game_data["objects"][obj_name]["file_path"]
		var obj_parent_path = new_game_data["objects"][obj_name]["parent_path"]
		var obj = load(obj_file_path).instantiate()
		get_node(obj_parent_path).add_child(obj, true)
		for property in new_game_data["objects"][obj_name].keys():
			var property_value = new_game_data["objects"][obj_name][property]
			obj.set(property, property_value)

func _init():
	randomize()

func _ready():
	close()
	var saved_files_list = list_saved_files(true)
	update_itemlist($ItemList_saved, saved_files_list)

#####################################################
# events
func _on_button_save_pressed():
	save_game_btn_pressed.emit()

func _on_button_load_pressed():
	load_game_btn_pressed.emit()

func _on_button_delete_a_saved_pressed():
	if $ItemList_saved.is_anything_selected():
		var selected = $ItemList_saved.get_selected_items()[0]
		var saved_file_name = $ItemList_saved.get_item_text(selected)
		delete_a_saved_file(saved_file_name)
		$ItemList_saved.remove_item(selected)

func _on_button_close_pressed():
	close()

func _on_item_list_saved_item_clicked(index, at_position, mouse_button_index):
	var item_name = $ItemList_saved.get_item_text(index).replace(".sav", "")
	$form_save/save_name_input.text = item_name
	

