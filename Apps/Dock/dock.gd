extends Control
class_name Dock

@onready var time_date : Label = $ColorRect/TimeDate

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var date = Time.get_date_string_from_system()
	var time = Time.get_time_string_from_system()
	time_date.text = date + "    " + time

	
