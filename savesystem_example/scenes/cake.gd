extends Area2D

@export var obj_name := "cake"

func get_save_properties() -> Dictionary:
	return {
		# require
		"file_path": scene_file_path,
		"parent_path": str(get_path()).replace("/" + name, ""),
		"obj_name": obj_name,
		"global_position": global_position,
		"rotation_degrees": rotation_degrees,
		"scale": scale,
	}

func _ready():
	$Label.top_level = true

func _process(delta):
	rotation_degrees += 1
	$Label.global_position = global_position + Vector2(-20, -42)
	$Label.text = obj_name


func _on_body_entered(body):
	if body.has_method("get_obj_name"):
		var body_name = body.get_obj_name()
		if body_name == "player":
			queue_free()
			

