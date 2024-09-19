extends Node2D
@onready var label = $Label
var interactable = false
@onready var player = $Player
func check_exit():
	var door_collisions= $Area2D2.get_overlapping_bodies()
	if player in door_collisions:
		get_tree().change_scene_to_file("res://win_screen.tscn")
		

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player entered the area.")
	if label:
		label.visible = true
		interactable = true

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player exited the area.")
	if label:
		label.visible = false
		interactable = false

func _physics_process(delta):
	if Input.is_action_just_pressed("interact") and interactable == true:
		check_exit()
