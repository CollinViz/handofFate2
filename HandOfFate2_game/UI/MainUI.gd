extends Control

export(Array, PackedScene) var game_combat_array = []
export(PackedScene) var DealerScene
export(PackedScene) var menu_settings
export(PackedScene) var menu_credits
export(PackedScene) var menu_main_menu
export(PackedScene) var menu_pause
export(PackedScene) var menu_empty
#onready var DealerScene = load("res://2DStratOnCombat/ForestAmbush/ForestAmbush.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var _x = PlayerData.connect("CardsLoaded",self,"_CardsLoaded")
	var _y = PlayerData.connect("StartCombat",self,"_loadCombat")
	var _p = PlayerData.connect("EndCombat",self,"_showDealer")
	PlayerData.LoadCardData()


func _CardsLoaded():
	#load send
	var x = DealerScene.instance()
	$Dealer.add_child(x)


func _showDealer(_Outcome:String,_CombatOptions):
	$Dealer.visible = true
	$Combat.visible = false
	if $Combat.get_child_count()>0:
		for c  in $Combat.get_children():			
			$Combat.remove_child(c)

func _loadCombat(CombatIdx:int,CombatOptions)->void:
	var newCombat = game_combat_array[CombatIdx].instance()
	if $Combat.get_child_count()>0:
		for c  in $Combat.get_children():			
			$Combat.remove_child(c)
	$Combat.add_child(newCombat)
	if newCombat.has_method("setOptions"):
		newCombat.setOptions(CombatOptions)
	$Dealer.visible = false
	$Combat.visible = true
