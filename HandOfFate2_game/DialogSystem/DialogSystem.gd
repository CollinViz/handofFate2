extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bQuestion := $Question
onready var bTextCaption := $TextCaption

signal questionAnswer(Answer)
signal StoryDone(Actions)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func ShowQuestion(Text:Array,Answers:Array)->void:
	self.visible=true
	bQuestion.visible= true
	bTextCaption.visible = false
	if Text.size()==1:
		bQuestion.setStoryText(Text[0])
		bQuestion.setAnswers(Answers)
	else:
		bQuestion.setStoryText(Text[0])
		bQuestion.setAnswers([])
 
func ShowStory(Text:Array,Action):
	self.visible=true
	bQuestion.visible= false
	bTextCaption.visible = true
	bTextCaption.setStoryText(Text)
	bTextCaption.ActionsOutCome = Action[0]

func _on_Question_questionAnswer(Answer):
	bQuestion.visible= false
	bTextCaption.visible = false
	self.visible=true
	emit_signal("questionAnswer",Answer)


func _on_TextCaption_StoryDone(Actions):
	bQuestion.visible= false
	bTextCaption.visible = false
	self.visible=true
	emit_signal("StoryDone",Actions)
