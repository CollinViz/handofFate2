extends Control

export(Array, PackedScene) var game_combat_array = []
export(PackedScene) var DealerScene
export(PackedScene) var IntroDealer
export(PackedScene) var IntroCombate
export(PackedScene) var menu_settings
export(PackedScene) var menu_credits
export(PackedScene) var menu_main_menu
export(PackedScene) var menu_pause
export(PackedScene) var menu_empty
#onready var DealerScene = load("res://2DStratOnCombat/ForestAmbush/ForestAmbush.tscn")
export var hasPlayedCombateIntor :=false
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	hasPlayedCombateIntor = false
	var _x = PlayerData.connect("CardsLoaded",self,"_CardsLoaded")
	var _y = PlayerData.connect("StartCombat",self,"_loadCombat")
	var _p = PlayerData.connect("EndCombat",self,"_showDealer")
	PlayerData.LoadCardData()


func _CardsLoaded():
	#load send
	#var x = IntroDealer.instance()
	var x = menu_main_menu.instance()
	#var x = DealerScene.instance()
	#var x = game_combat_array[1].instance()
	$MainMenu.add_child(x)

func StartGame():
	$MainMenu.visible= false
	var x = IntroDealer.instance()
	$Dealer.add_child(x)

func IntroCardRoomDone():
	if $Dealer.get_child_count()>0:
		for c  in $Dealer.get_children():			
			$Dealer.remove_child(c)
	var x = DealerScene.instance()
	#var x = game_combat_array[0].instance()
	$Dealer.add_child(x)

func _showDealer(_Outcome:String,_CombatOptions):
	$DealerMusic.stream_paused=false
	$Dealer.visible = true
	$Combat.visible = false
	if $Combat.get_child_count()>0:
		for c  in $Combat.get_children():			
			$Combat.remove_child(c)

func _loadCombat(CombatIdx:int,CombatOptions)->void:
	$DealerMusic.stream_paused=true
	if $Combat.get_child_count()>0:
		for c  in $Combat.get_children():			
			$Combat.remove_child(c)
	if hasPlayedCombateIntor==false:
		hasPlayedCombateIntor = true
		var intro = IntroCombate.instance()
		$Combat.add_child(intro)
		intro.setOptions(CombatOptions)
		intro.setCombatIndex(CombatIdx)
	else:
		var newCombat = game_combat_array[CombatIdx].instance()	
		$Combat.add_child(newCombat)
		if newCombat.has_method("setOptions"):
			newCombat.setOptions(CombatOptions)
			
	$Dealer.visible = false
	$Combat.visible = true
