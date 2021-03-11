extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var ListOfCardName:=["Success","Success","Success","Failure"]
export var ActionsOutCome={}

signal CardGambitDone(result)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func gambit(cardInfo,_CardType)->void:	
	yield(get_tree().create_timer(1), "timeout")
	emit_signal("CardGambitDone",ActionsOutCome[cardInfo.Text])

func switchtoBack():
	ListOfCardName.shuffle()
	$Card.CardType=ListOfCardName[0]
	$Card2.CardType=ListOfCardName[1]
	$Card3.CardType=ListOfCardName[2]
	$Card4.CardType=ListOfCardName[3]
	$Card.CardFace=false
	$Card2.CardFace=false
	$Card3.CardFace=false
	$Card4.CardFace=false
	$Card.CardSelect=false
	$Card2.CardSelect=false
	$Card3.CardSelect=false
	$Card4.CardSelect=false

func switchtoFront():
	 pass
		
func changeCardOrder():
	pass

func _on_DoSort_timeout():
	$CardsAnims.play("DoSort")


func _on_CardsAnims_animation_finished(anim_name):
	if anim_name=="DoSort":
		$CardsAnims.play("MoveBack")
	if anim_name=="MoveBack":
		$Card.CardSelect=true
		$Card2.CardSelect=true
		$Card3.CardSelect=true
		$Card4.CardSelect=true


func _on_revelCard_timeout():
	pass # Replace with function body.

func showGambit():
	$CardsAnims.play("default")
	self.visible =true;
	$Card.CardFace=true
	$Card2.CardFace=true
	$Card3.CardFace=true
	$Card4.CardFace=true
	$DoSort.start()
