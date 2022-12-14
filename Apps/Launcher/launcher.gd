extends Window
class_name Launcher


func _ready():
	$Search.connect("text_submitted",search)
	$Search.connect("text_changed",suggest)
	self.connect("visibility_changed",focus)



func _process(delta):
	pass

func search(text):
	AppManager.launch_app(text)

func suggest(text):
	pass

func focus():
	if visible:
		$Search.grab_focus()
