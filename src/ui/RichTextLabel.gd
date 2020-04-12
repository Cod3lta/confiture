extends RichTextLabel

var dialogue = [
	"Hey, ceci est un exemple !", 
	"Trop cool, ça marche !!"
	]
var page = 0


func _ready():
	set_bbcode(dialogue[page])
	set_visible_characters(0)
	set_process_input(true)

func _input(event):
	if event is InputEventKey and event.is_pressed() and event.scancode == KEY_SPACE:
		if get_visible_characters() > get_total_character_count():
			if page < dialogue.size()-1:
				page += 1
				set_bbcode(dialogue[page])
				set_visible_characters(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
