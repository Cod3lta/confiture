extends Node2D


onready var dialogue_box = $CanvasLayer/DialogueBox
var dialogue_box_scene
onready var music_1 = $Sounds/Music_1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Trigger1_body_entered(body):
	if body is KinematicBody2D:
		$Level/Jamy/AnimationPlayer.play("introduction_zoom_out")
		var dialog = [
			"Bon, on en est au 26ème jour de confinement. . .", 
			"L'ennui est TOTAL !",
			"Faut vraiment que je trouve quelque chose à faire sans sortir de la maison.",
			"Peut-être que je trouverai quelque chose au grenier ?"
			]
		dialogue_box.write(dialog)
		$Triggers/Trigger1.queue_free()


func _on_Trigger2_body_entered(body):
	if body is KinematicBody2D:
		var dialog = [
			"ça fait vraiment super longtemps que j'ai pas remis les pieds ici !",
			"Il faudra que je nettoie tout ça, c'est vraiment poussiéreux ",
			". . . ouais, je le ferai un de ces 4."
			]
		dialogue_box.write(dialog)
		$Triggers/Trigger2.queue_free()


func _on_Trigger3_body_entered(body):
	if body is KinematicBody2D:
		var dialog = [
			"Tiens, mon vieux chevalet de peinture !",
			"J'avais oublié qu'il était là",
			]
		dialogue_box.write(dialog)
		$Triggers/Trigger3.queue_free()


func _on_Trigger4_body_entered(body):
	if body is KinematicBody2D:
		var dialog = [
			"Et si je me mettais à la peinture ?",
			"Autant profiter d'avoir du temps !",
			"Bon par contre, où est le pinceau ?",
			"Mmh. . . ",
			"Ah, je crois savoir !",
			"Il me semble l'avoir vu dans la cabane de jardin en rangeant des affaires l'autre jour",
			"Bon, il va falloir redescendre",
			]
		dialogue_box.write(dialog)
		$Triggers/Trigger5.set_monitoring(true)
		$Level.open_garden()
		$Triggers/Trigger4.queue_free()


func _on_Trigger5_body_entered(body):
	print("Enter area 5")
	if body is KinematicBody2D:
		$Sounds/Music_1.play()
		$Triggers/Trigger5.queue_free()
