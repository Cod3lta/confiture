extends Control

onready var label = $NinePatchRect/ColorRect/RichTextLabel
var dialogue
var page = 0
var stop_player
onready var timer = $Timer


func _ready():
	hide_dialogue_ui()

func write(new_dialogue, stop_player = true):
	self.stop_player = stop_player
	dialogue = new_dialogue
	show_dialogue_ui()
	page = 0
	label.set_bbcode(dialogue[page])
	label.set_visible_characters(0)
	label.set_process_input(true)
	timer.start()

func show_dialogue_ui():
	$NinePatchRect.set_visible(true)
	if stop_player:
		get_node("../..").emit_signal("show_dialogue", false)

func hide_dialogue_ui():
	$NinePatchRect.set_visible(false)
	get_node("../..").emit_signal("show_dialogue", true)

func _input(event):
	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_ENTER:
		if label.get_visible_characters() > label.get_total_character_count():
			if page < dialogue.size()-1:
				page += 1
				label.set_bbcode(dialogue[page])
				label.set_visible_characters(0)
				timer.start()
			else:
				hide_dialogue_ui()
				dialogue = [""]
				page = 0


func _on_Timer_timeout():
	label.set_visible_characters(label.get_visible_characters() + 1)
	if label.get_visible_characters() <= label.get_total_character_count(): #Si tous les charactères sont affichés
		timer.start()
