extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = PlayerData.connect("PlayerDamage",self,"_PlayerDamage")
	var _t = PlayerData.connect("PlayerMultiply",self,"_PlayerMultiply")
	_PlayerDamage()


func _PlayerDamage():
	$HBoxContainer/PlayerHeath.text = "%d/%d" % [PlayerData.PlayerHeath,PlayerData.PlayerHeathMax]

func _PlayerMultiply():
	$HBoxContainer/PlayerMultyply.text ="Multiply %d" % PlayerData.PlayerMultiply
	
