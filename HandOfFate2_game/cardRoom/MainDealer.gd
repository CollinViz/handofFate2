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
		pass


func _CombatResoled(Outcome:String,CombatOptions):
	ResoleAnswer(CombatOptions[Outcome])
	pass

func ResoleAnswer(Answer):
	match Answer.Action: 
		"CardGambits":
			_showCardGambit(Answer)
		"Skip":
			if Answer.Skip.is_valid_integer():
				_MoveToEncounterIndex(int(Answer.Skip))

func _on_CardGambit_CardGambitDone(Answer):
	$CardGambit.visible=false
	ResoleAnswer(Answer)


func _on_GameBoard_PlayerPawnStart(node):
	$PlayerPawn.global_position = (node.rect_global_position + Vector2(25,25))
	 
	yield(get_tree().create_timer(.5), "timeout")	
	var firstCard = PlayerData.getCard(node.CardType)
	_CurrentEncounter = firstCard.Encounters
	_MoveToEncounterIndex(0)
	


func _on_GameBoard_PlayerPawnMoveTo(node):
	PlayerData.ManageCardEvent({"ResourceType":"Food","ResourceValue":-1})
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
			PlayerData.StartCombat(0,_CurrentEncounter[Index])

func _showCardGambit(Answer):
	$CardGambit.ListOfCardName = Answer.CardGambits.Cards as Array
	$CardGambit.ActionsOutCome = Answer.CardGambits
	$CardGambit.showGambit()
	

func _hideAllUI():
	$DialogSystem.visible=false
	$CardGambit.visible=false

func _on_DialogSystem_StoryDone(Actions):
	_hideAllUI()
	ResoleAnswer(Actions)
	 
