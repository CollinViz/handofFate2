extends Node2D

export var CardFace := true  setget _showCardSide
export(String, MULTILINE) var CardText := ""  setget _showCardText
export var CardSelect := true setget __cardSelect
export var CardSelectFunc := "" 

onready var  bCardBack := $CardBack
onready var  bCardFace := $CardFront

# Called when the node enters the scene tree for the first time.
func _ready():
	__cardSelect(CardSelect)
 
func _showCardSide(value:bool)-> void:
	CardFace = value
	if CardFace:
		$CardFront.visible=true
		$CardBack.visible = false
		$CardText.visible = true
		$CardImg.visible = true
	else:
		$CardFront.visible=false
		$CardBack.visible = true
		$CardText.visible = false
		$CardImg.visible = false
		
func _showCardText(value:String) ->void:
	CardText = value
	$CardText.bbcode_enabled = true
	$CardText.bbcode_text = "[center]%s[/center]" %value

func __cardSelect(value:bool) ->void:
	CardSelect = value
	if bCardFace == null:
		return
	if CardSelect:		
		bCardFace.mouse_filter = 0
		bCardBack.mouse_filter = 0
	else:
		bCardFace.mouse_filter = 2
		bCardBack.mouse_filter = 2


func _on_CardFront_gui_input(event:InputEvent):
	if event.is_pressed() and CardSelect:
		if CardSelectFunc!="":
			get_parent().call_deferred(CardSelectFunc,CardText)


func _on_CardBack_gui_input(event):
	if event.is_pressed() and CardSelect:
		if CardSelectFunc!="":
			get_parent().call_deferred(CardSelectFunc,CardText)
