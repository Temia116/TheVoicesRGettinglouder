extends CharacterBody2D



const SPEED = 300
const JUMP_VELOCITY = -500
enum state {idle, move_right, jump_up, jump_down, hurt}

var anim_state = state.idle
var direction
@onready var animator = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	update_state()
	update_animation(direction)
	move_and_slide()
	



func update_state():
	if anim_state == state.hurt:
		return
	if is_on_floor():
		if velocity == Vector2.ZERO:
			anim_state = state.idle
		elif velocity.x != 0:
			anim_state = state.move_right
	else:
		if velocity.y < 0:
			anim_state = state.jump_up
		else:
			anim_state = state.jump_down

func update_animation(direction):
	if direction > 0:
		animator.flip_h = false
	elif direction < 0:
		animator.flip_h = true
	match anim_state:
		state.idle:
			animation_player.play("idle")
		state.move_right:
			animation_player.play("move_right")
		state.jump_up:
			animation_player.play("jump_up")
		state.jump_down:
			animation_player.play("jump_down")
		state.hurt:
			animation_player.play("hurt")


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	

func _on_area_2d_body_entered(body: Node2D):
	get_tree().change_scene_to_file("res://game_over.tscn")
