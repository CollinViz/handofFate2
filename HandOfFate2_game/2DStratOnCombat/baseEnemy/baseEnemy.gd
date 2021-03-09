extends Actor

var stop = false

var intend_heavy = Color(255, 0.0, 0.0, 0.8) #FF0000
var intend_Light = Color(0, 0.0, 255, 0.8) #FF0000
var intend_finish = Color(255, 255, 0, 0.8) #FF0000
var intend_Nothing = Color(0, 0, 0, 0.0) #FF0000
var intend_Aggro = Color(0, 255, 255, 0.1) #FF0000

onready var FSM = $FSM

var _isAnimationPlaying = false
var TargetingPlayer:Actor = null
var DoAttack=0
# Called when the node enters the scene tree for the first time.
func _ready():
	##set_physics_process(false)
	_velocity.x = -speed.x
	$intent.modulate = intend_Nothing
	FSM.set_state(FSM.states.idle)
	##stop=false
func Dead():
	FSM.set_state(FSM.states.Dead)
	$AnimatedSprite.play("Dead") 
	print("Enemy is dead")	
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
	if Aggro:
		$intent.visible = true
	else:
		$intent.visible = false

func _shouldAttack():
	return Aggro

func selectAttack():
	if randi() % 3 == 1:
		DoAttack= FSM.states.HeavyAttack
		$intent.modulate = intend_heavy
	DoAttack= FSM.states.LightAttack
	$intent.modulate = intend_Light
	$AttackTimer.start(1)
	return FSM.states.Aggro_Thinking

func isAnimationPlaying()->bool:
	print("isAnimationPlaying %s %s %s" % [_isAnimationPlaying,$AnimatedSprite.animation,$AnimatedSprite.is_playing()])
	if $AnimatedSprite.animation!="Run":
		return _isAnimationPlaying
	_isAnimationPlaying = false
	return false


func takeDamage(NumDamage,_FromObj):
	FSM.set_state(FSM.states.Hit)
	Aggro = true
	HitPoints-=NumDamage
	if HitPoints<=0:
		Dead()
func DealDamage(BaseDamage):	
	if TargetingPlayer!=null:
		TargetingPlayer.takeDamage(BaseDamage,self)
		$AttackTimer.start(3)

func DoIdle():
	$AnimatedSprite.play("Run")
func DoAggro():
	$intent.modulate = intend_Aggro
	$AnimatedSprite.play("Run")

func DoHeavyAttack():
	_isAnimationPlaying = true
	$AnimatedSprite.play("Attack_Heavy")
	DealDamage(50)
	 
func DoLightAttack():
	_isAnimationPlaying = true
	$AnimatedSprite.play("Attack_Light")
	DealDamage(25)
	pass
func DoDoge():
	_isAnimationPlaying = true
	pass
func DoCounter():
	_isAnimationPlaying = true
	pass
func DoBlock():
	_isAnimationPlaying = true
	pass 
func DoHit():
	stop = true
	_isAnimationPlaying = true
	$AnimatedSprite.play("Hit")
	pass 
func DoDead():
	stop = true
	_isAnimationPlaying = true
	$AnimatedSprite.play("Dead")
	pass 

func _on_HitLeft_body_entered(body):
	if body.is_in_group("player"):
		if _shouldAttack():
			TargetingPlayer = body
			FSM.set_state(FSM.states.Aggro)
		stop = _shouldAttack()


func _on_HitRight_body_entered(body):
	if body.is_in_group("player"):
		if _shouldAttack():			
			TargetingPlayer = body 
			FSM.set_state(FSM.states.Aggro)
		stop = _shouldAttack()


func _on_HitLeft_body_exited(body):
	if body.is_in_group("player"):		
		stop = false


func _on_HitRight_body_exited(body):
	if body.is_in_group("player"): 
		stop = false


func _on_AnimatedSprite_animation_finished():
	_isAnimationPlaying = false
	if FSM.state == FSM.states.Dead:
		self.queue_free()
		return
	FSM.AnimationStopped($AnimatedSprite.animation,Aggro)
	 

func _on_AnimatedSprite_frame_changed():
	pass
	# if $AnimatedSprite.animation=="Attack_Heavy" and $AnimatedSprite.frame==2:
	# 	_isAnimationPlaying= false


func _on_AttackTimer_timeout():
	if DoAttack!=0:
		FSM.set_state(DoAttack)
		DoAttack =0		
	else:
		if Aggro:
			FSM.set_state(FSM.states.Aggro)
