extends Actor


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("Doge"):
		$AnimatedSprite.play("Dash")
	if event.is_action_pressed("Counter"):
		$AnimatedSprite.play("Counter") 
	if event.is_action_pressed("attack_heavy"):
		$AnimatedSprite.play("HeavyAttack") 
	if event.is_action_pressed("attack_light"):
		$AnimatedSprite.play("LightAttack") 


func _physics_process(_delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	if direction.x <0:
		$AnimatedSprite.flip_h = false
		FacingDirection = 1
	else:
		if direction.x!=0:
			$AnimatedSprite.flip_h = true
			FacingDirection = 2
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity = move_and_slide_with_snap(
		_velocity, snap, FLOOR_NORMAL, true
	)
	
	if Input.is_action_pressed("Block"):
		if FacingDirection==1:
			$ShieldLeft.visible=true
			$ShieldRight.visible = false
		else:
			$ShieldLeft.visible=false
			$ShieldRight.visible = true
	if Input.is_action_just_released("Block"):
		$ShieldLeft.visible=false
		$ShieldRight.visible = false
		
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var velocity: = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation !="Idel":
		$AnimatedSprite.play("Idel")


func _on_HitLeft_body_entered(body):
	pass # Replace with function body.


func _on_HitRight_body_entered(body):
	pass # Replace with function body.
