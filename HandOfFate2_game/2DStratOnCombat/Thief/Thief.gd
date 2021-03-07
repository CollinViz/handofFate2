extends Actor

var stop = false
 


# Called when the node enters the scene tree for the first time.
func _ready():
	##set_physics_process(false)
	_velocity.x = -speed.x
	##stop=false
	
func _physics_process(_delta: float) -> void:
	if stop:
		return
	_velocity.x *= -1 if is_on_wall() else 1
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	if _velocity.x <0:
		$AnimatedSprite.flip_h = false
		FacingDirection = 1
	else:
		if _velocity.x!=0:
			$AnimatedSprite.flip_h = true
			FacingDirection = 2


func _on_HitLeft_body_entered(body):
	if body.is_in_group("player"):
		print("We hit something")
		stop = true


func _on_HitRight_body_entered(body):
	if body.is_in_group("player"):
		print("We hit something")
		stop = true


func _on_HitLeft_body_exited(body):
	if body.is_in_group("player"):
		print("Player Leaving")
		stop = false


func _on_HitRight_body_exited(body):
	if body.is_in_group("player"):
		print("Player Leaving")
		stop = false
