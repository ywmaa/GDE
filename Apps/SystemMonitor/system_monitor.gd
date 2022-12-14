extends Window
class_name SystemMonitor

var output : Array #use it to retrieve results from bash commands
@onready var refresh_timer : Timer = get_node("RefreshTimer")
var connected_timer : bool = false

func _ready():
	refresh_timer.connect("timeout",refresh_app_list)

func refresh_app_list():
	output = []
	$ScrollContainer/RichTextLabel.clear()
	OS.execute("bash",["-c","ps"],output)
	for text in output: # for on screen debug only
		$ScrollContainer/RichTextLabel.add_text(text)
		

