extends Control

@onready var timer = $Timer
@onready var label = $Label

func _ready():
	timer.start()

func _on_timer_timeout():
	timer.stop()
	
	if label.text == "Waiting For Players":
		label.text = "Waiting For Players."
	elif label.text == "Waiting For Players.":
		label.text = "Waiting For Players.."
	elif label.text == "Waiting For Players..":
		label.text = "Waiting For Players..."
	elif label.text == "Waiting For Players...":
		label.text = "Waiting For Players"
	
	timer.start()
