extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():	
	pass
 
func select(cardInfo)->void:	
	if PlayerData.ManageCardEvent(cardInfo) == false:		 
		print("Not sure what to do with this card %s" %cardInfo.Text) 
		pass




func _on_CardGambit_CardGambitDone(result):
	$CardGambit.visible=false
	match result:
		"Success":
			print("Well Done")
		"Huge Success":
			print("Huge Success")
		"Failure":
			print("Failure")
		"Huge Failure":
			print("Huge Failure")


func _on_GameBoard_PlayerPawnStart(node):
	$PlayerPawn.global_position = (node.rect_global_position + Vector2(25,25))


func _on_GameBoard_PlayerPawnMoveTo(node):
	var tween = get_node("PlayerMove")	
	tween.interpolate_property($PlayerPawn, "global_position",$PlayerPawn.global_position, (node.rect_global_position + Vector2(25,25)), 1,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	#$PlayerPawn.global_position = (node.rect_global_position + Vector2(25,25))
