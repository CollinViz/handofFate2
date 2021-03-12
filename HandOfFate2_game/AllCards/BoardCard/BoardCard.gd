extends Control


export var isActive: bool = false setget _setActive
export var CardType:="" setget _setCardType
export var CardFace := true  setget _showCardSide
export var CardSelect := true setget _cardSelect
export var IndexPos := 0
export var ActiveIndexPos := 0
signal cardClick(CardType,Node)

onready var  bCardBack := $CardBack
onready var  bCardFace := $CardFront 

# Called when the node enters the scene tree for the first time.
func _ready():
	_cardSelect(CardSelect)	 
	pass # Replace with function body.


func _cardSelect(value:bool) ->void:
	CardSelect = value
	if bCardFace == null:
		return
	$CardFront/Tween.stop_all()
	if CardSelect:		
		bCardFace.mouse_filter = 0
		bCardBack.mouse_filter = 0 
		$CardFront/Active.visible=true
		$CardFront/Tween.interpolate_property($CardFront/Active, "energy", 
		0, 
		1.5,
		3, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$CardFront/Tween.repeat = true
		$CardFront/Tween.start()
	else:
		bCardFace.mouse_filter = 2
		bCardBack.mouse_filter = 2 
		$CardFront/Active.visible=false


func _on_Card_gui_input(event):
	if event.is_pressed() and CardFace:
		_showCardSide(false)
		emit_signal("cardClick",CardType,self)

func _setCardType(value:String):
	CardType=value


func _showCardSide(value:bool)->void:
	CardFace=value


func _setActive(value:bool)->void:
	isActive = value
	if value == false:
		$CardFront/Tween.stop_all()
		$CardFront/Active.visible=false
	else:
		if bCardFace.mouse_filter==0:
			_cardSelect(CardSelect)
