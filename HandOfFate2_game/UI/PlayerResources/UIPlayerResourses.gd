extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bPlayerHeath = $Heath
onready var bPlayerFood = $Food
onready var bPlayerGold = $Gold

# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = PlayerData.connect("UpdateResource",self,"UpdateResource")
	bPlayerHeath.CurrentValue = PlayerData.PlayerHeath
	bPlayerHeath.MaxValue = PlayerData.PlayerHeathMax
	bPlayerFood.CurrentValue = PlayerData.PlayerFood
	bPlayerGold.CurrentValue = PlayerData.PlayerGold


func UpdateResource():
	yield(get_tree().create_timer(1.5), "timeout")
	bPlayerHeath.CurrentValue = PlayerData.PlayerHeath
	bPlayerHeath.MaxValue = PlayerData.PlayerHeathMax
	bPlayerFood.CurrentValue = PlayerData.PlayerFood
	bPlayerGold.CurrentValue = PlayerData.PlayerGold
