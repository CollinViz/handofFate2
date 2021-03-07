extends Control


onready var DealerScene = load("res://2DStratOnCombat/ForestAmbush/ForestAmbush.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var _x = PlayerData.connect("CardsLoaded",self,"_CardsLoaded")
	PlayerData.LoadCardData()


func _CardsLoaded():
	#load send
	var x = DealerScene.instance()
	self.add_child(x)
