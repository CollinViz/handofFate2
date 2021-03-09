extends Node2D

var CombatOptions = null
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Base Level Load")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setOptions(options):
	CombatOptions = options

func getOptions():
	return CombatOptions

func _on_checkAllEnenies_timeout():	 
	if $AllEnemies.get_child_count()==0:
		PlayerData.EndCombat("Success",CombatOptions)
