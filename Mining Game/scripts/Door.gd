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
		if Input.is_action_pressed("ui_select"):
			SceneChanger.change_scene(path)
