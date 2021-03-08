extends "res://2DStratOnCombat/StateMachine.gd"

func _ready():
	add_state("idle")
	add_state("Aggro")
	add_state("Aggro_Thinking")
	add_state("LightAttack")
	add_state("HeavyAttack")	
	add_state("Counter")
	add_state("Block")
	add_state("Hit")
	add_state("Dead")

func AnimationStopped(_PlayedAnimation,_isAggro)->void:
	pass
	# #print("Animation Stopped %s" % PlayedAnimation)
	# match state:
	# 	states.idle,states.Block:
	# 		pass
	# 	_:
	# 		set_state(states.idle)
	# 		# if isAggro:
	# 		# 	set_state(states.Aggro)
	# 		# else:
	# 		# 	set_state(states.idle)

func _state_logic(_delta):
	pass

func _get_transition(_delta):
	 
	match state:
		states.Aggro:
			return parent.selectAttack()
	return null 

func _enter_state(new_state,old_state):
	match new_state:
		states.idle:
			parent.DoIdle()
		states.Aggro:
			parent.DoAggro()
		states.HeavyAttack:
			parent.DoHeavyAttack()
		states.LightAttack:
			parent.DoLightAttack()		 
		states.Counter:			
			parent.DoCounter()
		states.Block: 
			parent.DoBlock()
		states.Hit: 
			parent.DoHit()
		states.Dead: 
			parent.DoDead()
	print("_enter_state new ",_stateName(new_state)," old ",_stateName(old_state))
	pass

func _exit_state(old_state,new_state):
	print("_exit_state old ",_stateName(old_state)," new ",_stateName(new_state))
	pass
