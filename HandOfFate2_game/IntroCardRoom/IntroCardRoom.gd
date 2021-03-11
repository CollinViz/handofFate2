extends Node2D
 
var _CurrentEncounter : Array

onready var DialogSystem = $DialogSystem
# Called when the node enters the scene tree for the first time.
func _ready():
	var firstCard = PlayerData.getCard("IntroCardRoom")
	_CurrentEncounter = firstCard.Encounters
	DialogSystem.ShowStory(_CurrentEncounter[0].Text,_CurrentEncounter[0].Actions)
 

func _on_DialogSystem_StoryDone(_Actions):
	DialogSystem.visible=false	
	get_parent().get_parent().IntroCardRoomDone()
	self.queue_free()


func _on_DialogSystem_questionAnswer(_Answer):
	DialogSystem.visible=false
	get_parent().get_parent().IntroCardRoomDone()
	self.queue_free()
