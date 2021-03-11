extends Control

onready var Talking1:TextureRect = $Panel/VBoxContainer/HBoxContainer/Talking1
onready var StoryText:RichTextLabel =$Panel/VBoxContainer/HBoxContainer/StoryText
onready var OptionsList:VBoxContainer = $Panel/VBoxContainer/CenterContainer/OptionsList

signal questionAnswer(Answer)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setStoryText(Text:String)->void:
	StoryText.bbcode_text = Text
	
func setAnswers(Answer:Array):
	for n in OptionsList.get_children():
		OptionsList.remove_child(n)
		n.queue_free()
	var index :=1
	for n in Answer:
		var b=  Button.new()
		b.text = "%d. %s" % [index,n.Text]
		b.flat=true
		b.align =Button.ALIGN_LEFT
		b.connect("pressed", self, "_on_Button_pressed",[b,n])
		OptionsList.add_child(b)
		index+=1
	


func _on_Button_pressed(_but:Button,n):
	print("%s - > %s" % [n.Text,n.Actions[0].Action])
	emit_signal("questionAnswer",n.Actions)
	pass # Replace with function body.
