extends CharacterBody2D

var hp := 500
var maxhp := 500
var vel := Vector2.ZERO
var vel_spd := 100.0
@export var is_ai := false
@export var obj_name := "godot icon"

func get_save_properties() -> Dictionary:
	return {
		"file_path": scene_file_path,
		"parent_path": str(get_path()).replace("/" + name, ""),
		"obj_name": obj_name,
		"modulate": modulate,
		"global_position": global_position,
		"rotation_degrees": rotation_degrees,
		"scale": scale,
		"is_ai": is_ai,
		"hp": hp,
		"maxhp": maxhp,
		"vel": vel,
	}

func get_obj_name() -> String:
	return obj_name

func _ready():
	add_to_group("save")
	$Timer.wait_time = randf_range(0.1, 4)
	$Timer.start()
	set_physics_process(true)
	

func _physics_process(delta):
	$ProgressBar.max_value = maxhp
	$ProgressBar.value = hp
	$Label.text = obj_name
	if !is_ai:
		if Input.is_action_pressed("ui_up"):
			vel = Vector2.UP
		elif Input.is_action_pressed("ui_down"):
			vel = Vector2.DOWN
		elif Input.is_action_pressed("ui_left"):
			vel = Vector2.LEFT
		elif Input.is_action_pressed("ui_right"):
			vel = Vector2.RIGHT
		else:
			vel = Vector2.ZERO
	velocity = vel*vel_spd
	move_and_slide()


func _on_timer_timeout():
	if is_ai:
		var vel_id = randi_range(0, 5)
		if vel_id == 0:
			vel = Vector2.ZERO
		elif vel_id == 1:
			vel = Vector2.LEFT
		elif vel_id == 2:
			vel = Vector2.RIGHT
		elif vel_id == 3:
			vel = Vector2.UP
		elif vel_id == 4:
			vel = Vector2.DOWN
	$Timer.wait_time = randf_range(0.1, 4)
	$Timer.start()
	
