extends "res://2DStratOnCombat/StateMachine.gd"

var bufferActions:=[]

func _ready():
	add_state("idle")
	add_state("HeavyAttack")
	add_state("LightAttack")
	add_state("Doge")
	add_state("Counter")
	add_state("Block")
	add_state("Dead")
	add_state("Hit")
	
	#call_deferred("set_state",states.idle)

func _input(event):
	if event.is_action_pressed("Doge"):
		_tryDoAction(states.Doge)
		#$AnimatedSprite.play("Dash")
	if event.is_action_pressed("Counter"):
		_tryDoAction(states.Counter)
		#$AnimatedSprite.play("Counter") 
	if event.is_action_pressed("attack_heavy"):
		_tryDoAction(states.HeavyAttack)
		#
	if event.is_action_pressed("attack_light"):
		_tryDoAction(states.LightAttack)
		#$AnimatedSprite.play("LightAttack") 
	if event.is_action_released("Block") and state!=states.idle:
		_tryDoAction(states.idle)

func _tryDoAction(newState)->void:
	if state==states.idle:
		set_state(newState)
	else:
		bufferActions.push_back(newState)
		if bufferActions.size()>1:
			bufferActions.pop_front()

func AnimationStopped(_PlayedAnimation)->void:
	#print("Animation Stopped %s" % PlayedAnimation)
	match state:
		states.idle,states.Block:
			pass
		_:
			set_state(states.idle)
	 

func _state_logic(_delta):
	pass

func _get_transition(_delta):
	if Input.is_action_pressed("Block") and state != states.Block:
		return states.Block
	#if Input.is_action_just_released("Block"):	
	if state == states.idle and bufferActions.size()==0:
		return null
	
	if parent.isAnimationPlaying():
		return null
	
	if bufferActions.size()>0:
		var newState =  bufferActions[0];
		bufferActions.pop_front()
		return newState;

	match state:
		states.idle:
			 pass
		states.HeavyAttack:
			 return states.idle
		states.LightAttack:
			return states.idle
		states.Doge:
			return states.idle
		states.Counter:
			return states.idle

	return null 

func _enter_state(new_state,old_state):
	match new_state:
		states.idle:
			parent.DoIdle()
		states.HeavyAttack:
			parent.DoHeavyAttack()
		states.LightAttack:
			parent.DoLightAttack()
		states.Doge:
			bufferActions=[]
			parent.DoDoge()
		states.Counter:			
			parent.DoCounter()
		states.Block:
			bufferActions=[]
			parent.DoBlock()
		states.Hit:
			bufferActions=[]
			parent.DoHit()
		states.Dead:
			bufferActions=[]
			parent.DoDead()
		
	print("_enter_state new ",_stateName(new_state)," old ",_stateName(old_state))
	 

func _exit_state(old_state,new_state):
	match old_state:
		states.Block:
			parent.RemoveBlock()
	print("_exit_state old ",_stateName(old_state)," new ",_stateName(new_state))
	pass
