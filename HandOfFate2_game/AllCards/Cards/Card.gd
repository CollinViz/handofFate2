extends Control

export var CardFace := true  setget _showCardSide
export(String) var CardType := ""  setget _showCardText
export var CardSelect := true setget __cardSelect
export var CardSelectFunc := "" 
export var AutoFlipOnClick :=false

onready var  bCardBack := $CardBack
onready var  bCardFace := $CardFront
onready var  bCardImg := $CardImg

var CurrentCardInfo :={}
# Called when the node enters the scene tree for the first time.
func _ready():
	__cardSelect(CardSelect)
	_showCardText(CardType)
 
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
	CardType = value
	CurrentCardInfo = PlayerData.getCard(CardType)
	$CardText.bbcode_enabled = true
	$CardText.bbcode_text = "[center]%s[/center]" % CurrentCardInfo.Text
	var idx= PlayerData.AllCardImages.find_tile_by_name(CurrentCardInfo.img)
	$CardImg.texture =PlayerData.AllCardImages.tile_get_texture(idx)

func __cardSelect(value:bool) ->void:
	CardSelect = value
	if bCardFace == null:
		return
	if CardSelect:		
		bCardFace.mouse_filter = 0
		bCardBack.mouse_filter = 0
		bCardImg.mouse_filter = 0
	else:
		bCardFace.mouse_filter = 2
		bCardBack.mouse_filter = 2
		bCardImg.mouse_filter = 2


func _on_CardFront_gui_input(event:InputEvent):
	if event.is_pressed() and CardSelect:
		if AutoFlipOnClick:
			_showCardSide(!CardFace)
		if CardSelectFunc!="":
			get_parent().call_deferred(CardSelectFunc,CurrentCardInfo,CardType)


 
