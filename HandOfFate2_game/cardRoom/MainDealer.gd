extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var DialogSystem = $DialogSystem

var _CurrentEncounter :=[]

# Called when the node enters the scene tree for the first time.
func _ready():	
	var _p = PlayerData.connect("EndCombat",self,"_CombatResoled")
 
func select(cardInfo)->void:	
	if PlayerData.ManageCardEvent(cardInfo) == false:		 
		print("Not sure what to do with this card %s" %cardInfo.Text) 
		 


func _CombatResoled(Outcome:String,CombatOptions):
	var _y = PlayerData.ManageCardEvent({"ResourceType":"Food","ResourceValue":-1})
	var _p = PlayerData.ManageCardEvent({"ResourceType":"Heath","ResourceValue":5})
	$PlayerRecorce.UpdateResource()
	ResoleAnswer(CombatOptions[Outcome])
	
	

func ResoleAnswer(Answer):
	match Answer.Action: 
		"CardGambits":
			_showCardGambit(Answer)
		"CardSelect":
			_showCardSelect(Answer)
		"boon":
			_resolveBoon(Answer)
		"Skip":
			if Answer.Skip.is_valid_integer():
				_MoveToEncounterIndex(int(Answer.Skip))
		"Done":
			$GameBoard.isActive = true
		"AFriendInNeed":
			movePlayerOnGameBoard(Answer.Action)
		"FindingForestFolk":
			movePlayerOnGameBoard(Answer.Action)
		"TheLeader":
			movePlayerOnGameBoard(Answer.Action)
		"TheEnd":
			_showEndScreen()

func _showEndScreen():
	get_parent().get_parent().ShowEndGame()
	
func movePlayerOnGameBoard(CardName:String):
	$GameBoard.isActive = true
	$GameBoard.MoveToActiveCard(CardName)

func _on_CardGambit_CardGambitDone(Answer):
	$CardGambit.visible=false
	ResoleAnswer(Answer)


func _on_GameBoard_PlayerPawnStart(node):
	$PlayerPawn.global_position = (node.rect_global_position + Vector2(25,25))
	 
	yield(get_tree().create_timer(1), "timeout")	
	var firstCard = PlayerData.getCard(node.CardType)
	_CurrentEncounter = firstCard.Encounters
	_MoveToEncounterIndex(0)
	


func _on_GameBoard_PlayerPawnMoveTo(node):
	var _y = PlayerData.ManageCardEvent({"ResourceType":"Food","ResourceValue":-1})
	var tween = get_node("PlayerMove")	
	tween.interpolate_property($PlayerPawn, "global_position",$PlayerPawn.global_position, (node.rect_global_position + Vector2(25,25)), 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	var firstCard = PlayerData.getCard(node.CardType)
	_CurrentEncounter = firstCard.Encounters
	_MoveToEncounterIndex(0)
	
	#$PlayerPawn.global_position = (node.rect_global_position + Vector2(25,25))


func _on_DialogSystem_questionAnswer(Answer):
	_hideAllUI()
	ResoleAnswer(Answer[0])
	 

func _MoveToEncounterIndex(Index:int) ->void:
	
	_hideAllUI()
	match _CurrentEncounter[Index].Type:
		"Question":
			DialogSystem.ShowQuestion(_CurrentEncounter[Index].Text,_CurrentEncounter[Index].Answers)
		"Story":
			DialogSystem.ShowStory(_CurrentEncounter[Index].Text,_CurrentEncounter[Index].Actions)
		"Combat":			
			_ShowCombat(_CurrentEncounter[Index])
		"Done":
			$GameBoard.isActive = true

func _ShowCombat(Encounter):
	var CombatIndex = 0
	match Encounter.Combat:
		"type3":
			CombatIndex=1

	PlayerData.StartCombat(CombatIndex,Encounter)

func _showCardGambit(Answer):
	$CardGambit.ListOfCardName = Answer.CardGambits.Cards as Array
	$CardGambit.ActionsOutCome = Answer.CardGambits
	$CardGambit.showGambit()

func _showCardSelect(Answer):	
	$CardSelect.ActionsOutCome = Answer.Actions
	$CardSelect.showCardSelect(Answer.CardSelect as Array)
	

func _hideAllUI():
	$GameBoard.isActive = false
	$DialogSystem.visible=false
	$CardGambit.visible=false

func _on_DialogSystem_StoryDone(Actions):
	_hideAllUI()
	ResoleAnswer(Actions)
	  
func _on_CardSelect_CardSelectDone(CardName):
	$CardSelect.visible=false
	_addCardInventory(CardName)
	ResoleAnswer($CardSelect.ActionsOutCome[0])

func _addCardInventory(_NewCard):
	print("ToDo add Inventory System")


func _resolveBoon(Answer):
	match Answer.boon:
		"cards":
			for c  in Answer.Cards:
				var _x = PlayerData.ManageCardEvent(PlayerData.getCard(c))
		"token":
			print("Token in Inventory")
	ResoleAnswer(Answer.Actions[0])


func _on_Button_pressed():
	var _y = PlayerData.ManageCardEvent({"ResourceType":"Food","ResourceValue":1})
	var _p = PlayerData.ManageCardEvent({"ResourceType":"Heath","ResourceValue":-5})
