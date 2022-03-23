extends Area2D

export var path = ""
var inArea = false;

func _on_Door_body_entered(body):
	if body.is_in_group("player"):
		inArea = true


func _on_Door_body_exited(body):
	if body.is_in_group("player"):
		inArea = false


func _process(delta):
	if inArea:
		if Input.is_action_just_pressed("ui_select"):
			if path == "res://scenes/MainScene.tscn":
				Data.add_to_overall_tokens()
			else:
				Data.current_tokens = get_parent().find_node("Player").current_tokens
			SceneChanger.change_scene(path)
