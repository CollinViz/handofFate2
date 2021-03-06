extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bPlayerHeath = $Heath
onready var bPlayerFood = $Food
onready var bPlayerGold = $Gold

# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = PlayerData.connect("UpdateResource",self,"_UpdateResource")
	_UpdateResource()


func _UpdateResource():
	bPlayerHeath.CurrentValue = PlayerData.PlayerHeath
	bPlayerHeath.MaxValue = PlayerData.PlayerHeathMax
	bPlayerFood.CurrentValue = PlayerData.PlayerFood
	bPlayerGold.CurrentValue = PlayerData.PlayerGold
