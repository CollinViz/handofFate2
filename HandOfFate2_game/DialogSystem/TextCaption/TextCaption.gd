extends Control

onready var Talking1:TextureRect = $Panel/VBoxContainer/HBoxContainer/Talking1
onready var StoryText:RichTextLabel =$Panel/VBoxContainer/HBoxContainer/StoryText
onready var NextButton:Button =$Panel/VBoxContainer/HBoxContainer2/Button

export var ActionsOutCome={}
export var aStoryText:=[]
export var StoryTextIndex:=0
 
signal StoryDone(Actions)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func setStoryText(Text:Array)->void:
	aStoryText = Text
	StoryTextIndex = 0
	StoryText.bbcode_text = Text[StoryTextIndex]
	if Text.size()==1:
		NextButton.text="Done"
	else:		
		NextButton.text="Next"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	if NextButton.text=="Done":
		emit_signal("StoryDone",ActionsOutCome)
		return
	StoryTextIndex+=1
	StoryText.bbcode_text = aStoryText[StoryTextIndex]
	if StoryTextIndex+1== aStoryText.size():
		NextButton.text="Done"
	else:
		NextButton.text="Next"
