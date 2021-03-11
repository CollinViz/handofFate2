extends Control

export var ActionsOutCome={}

onready var Card1 := $Card
onready var Card2 := $Card2
onready var Card3 := $Card3
signal CardSelectDone(CardName)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func selectCard(cardInfo,CardType)->void:	
	yield(get_tree().create_timer(1), "timeout")
	self.visible =false;
	emit_signal("CardSelectDone",CardType)

func showCardSelect(CardList:Array):
	self.visible =true;
	Card1.CardType=CardList[0]
	Card2.CardType=CardList[1]
	Card3.CardType=CardList[2]

