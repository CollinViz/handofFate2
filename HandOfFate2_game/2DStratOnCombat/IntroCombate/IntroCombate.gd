extends Node2D

var CombatOptions = null
var CombatIndex = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setOptions(options):
	CombatOptions = options

func setCombatIndex(index):
	CombatIndex = index

func enterCombat():
	PlayerData.StartCombat(CombatIndex,CombatOptions)

func _on_Timer_timeout():
	enterCombat()


func _on_Button_pressed():
	enterCombat()
