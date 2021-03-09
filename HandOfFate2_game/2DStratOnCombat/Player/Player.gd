extends Actor


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var PlayerFSM = $PlayerFSM

var _isAnimationPlaying = false

var TargetingEnemy:Actor = null
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerFSM.set_state(PlayerFSM.states.idle)
	pass # Replace with function body.

 
func takeDamage(NumDamage,_FromObj):
	match PlayerFSM.state:
		PlayerFSM.states.Doge:
			if NumDamage<=25:
				print("Light Attach dogged")
				return
		PlayerFSM.states.Hit:
				print("Already hit cannot take damage")			
				return
		PlayerFSM.states.Counter:
			if NumDamage<=25:
				print("Counter need to give damage to attacher ")
				return
		PlayerFSM.states.Block:
			print("Flat block")
			return

	Aggro = true
	HitPoints-=NumDamage
	if HitPoints<=0:
		PlayerFSM.set_state(PlayerFSM.states.Dead)
	else:
		PlayerFSM.set_state(PlayerFSM.states.Hit)
	PlayerData.takeDamage(NumDamage,HitPoints,MaxHitPoints)
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

func isAnimationPlaying()->bool:
	#print("isAnimationPlaying %s %s %s" % [_isAnimationPlaying,$AnimatedSprite.animation,$AnimatedSprite.is_playing()])
	if $AnimatedSprite.animation!="Idel":
		return _isAnimationPlaying
	_isAnimationPlaying = false
	return false

func _on_AnimatedSprite_animation_finished():
	_isAnimationPlaying = false
	PlayerFSM.AnimationStopped($AnimatedSprite.animation)
	


func _on_HitLeft_body_entered(body):
	if FacingDirection==1:
		if body.has_method("takeDamage") and body.is_in_group("enemy"):
			TargetingEnemy = body 


func _on_HitRight_body_entered(body):
	if FacingDirection==2:
		if body.has_method("takeDamage") and body.is_in_group("enemy"):
			TargetingEnemy = body

func _on_HitLeft_body_exited(body):
	if FacingDirection==1:
		if body.has_method("takeDamage") and body.is_in_group("enemy") :
			TargetingEnemy = null
func _on_HitRight_body_exited(body):
	if FacingDirection==2:
		if body.has_method("takeDamage") and body.is_in_group("enemy"):
			TargetingEnemy = null





func DealDamage(BaseDamage):
	 
	if TargetingEnemy!=null:
		PlayerData.AddMultiply(1)
		print(" Damage %d" %int(BaseDamage * (1 + (float( PlayerData.PlayerMultiply)/100))))
		TargetingEnemy.takeDamage(int(BaseDamage * (1 + (float(PlayerData.PlayerMultiply)/100))),self)
	else:
		if FacingDirection==1:
			_FindSomething2Hit($LeftRay,BaseDamage)
		else:
			_FindSomething2Hit($RightRay,BaseDamage) 

func _FindSomething2Hit(Ray:RayCast2D,BaseDamage)->void:
	Ray.force_raycast_update()
	if Ray.is_colliding():
		var body = Ray.get_collider()
		if body.has_method("takeDamage") and body.is_in_group("enemy"):
			TargetingEnemy = body
			DealDamage(BaseDamage) 


func DoHeavyAttack():
	_isAnimationPlaying = true
	$AnimatedSprite.play("HeavyAttack") 
	DealDamage(50)
func DoLightAttack():
	_isAnimationPlaying = true
	$AnimatedSprite.play("LightAttack") 
	DealDamage(25)
func DoDoge():
	_isAnimationPlaying = true
	$AnimatedSprite.play("Dash") 
func DoCounter():
	_isAnimationPlaying = true
	$AnimatedSprite.play("Counter") 
func DoIdle():
	_isAnimationPlaying = true
	$AnimatedSprite.play("Idel") 
func DoHit():
	_isAnimationPlaying = true
	$AnimatedSprite.play("Hit") 
func DoDead():
	PlayerData.EndCombat("Failure",get_parent().getOptions())
	_isAnimationPlaying = true
	$AnimatedSprite.play("Dead") 
func DoBlock():
	$AnimatedSprite.play("Idel") 
	if FacingDirection==1:
		$ShieldLeft.visible=true
		$ShieldRight.visible = false
	else:
		$ShieldLeft.visible=false
		$ShieldRight.visible = true
func RemoveBlock():	
	$ShieldLeft.visible=false
	$ShieldRight.visible = false
	
func StopAnimationReset():
	_isAnimationPlaying = false
	$AnimatedSprite.play("Idel") 
	$AnimatedSprite.stop()



