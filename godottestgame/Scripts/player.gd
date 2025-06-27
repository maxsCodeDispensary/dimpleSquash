extends CharacterBody3D
signal hit
var speed = 14
var fall_acceleration = 75
@export var jump_impulse = 20
var target_velocity = Vector3.ZERO
@export var bounce_impulse = 16
@onready var animationPlayer = $Pivot/godotMIXAMO/AnimationPlayer
var current_states = player_states.move
enum player_states {move,jump}


func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("moveRight"):
		direction.x += 1
	if Input.is_action_pressed("moveLeft"):
		direction.x -=1
	if Input.is_action_pressed("moveBack"):
		direction.z += 1
	if Input.is_action_pressed("moveForward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		animationPlayer.play("Running")
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)
	else:
		animationPlayer.play("Idle")
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration*delta)
		
	if is_on_floor() and Input.is_action_just_pressed("jump"):

			target_velocity.y = jump_impulse	

	

	
	
	for index in range(get_slide_collision_count()):
		
		var collision = get_slide_collision(index)
		
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("mob"):
			
			var mob = collision.get_collider()
			
			if Vector3.UP.dot(collision.get_normal()) > .5:
				mob.squash()
				target_velocity.y = bounce_impulse
				break
			
	
	velocity = target_velocity
	move_and_slide()
	
func die():
		hit.emit()
		queue_free()

func _on_mob_detector_body_entered(_body: Node3D) -> void:
	die()

		
