extends Control
# refer to this for original crackle : https://github.com/tuxecure/crackle/blob/bash/crackle


var output : Array #use it to retrieve results from bash commands
# Configuration for Apt
var APTCACHE : String
var APTSTATE : String
var APTCONFIG : String

func _enter_tree():
	if "--help" in OS.get_cmdline_args():
		print("available commands:
		- GDE setup
		- GDE debug
		- GDE install $PKG
		- GDE reinstall $PKG
		- GDE download $PKG
		- GDE crack $PKG
		- GDE remove $PKG
		- GDE clean
		- GDE click $PKG
		- GDE search $PKG
		- GDE show $PKG
		- GDE update
		- GDE nuke")
	

func _ready():
	
	$RichTextLabel.text = ""
	OS.execute("bash",["-c","echo ${APTCACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/apt}"],output)
	OS.execute("bash",["-c","echo ${APTSTATE:-${XDG_STATE_HOME:-$HOME/.local/state}/apt}"],output)
	OS.execute("bash",["-c","echo ${APTCONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/crackle}"],output)
	APTCACHE = output[0]
	APTSTATE = output[1]
	APTCONFIG = output[2]
	for text in output: # for on screen debug only
		$RichTextLabel.text += text
	output.clear()
	
	


func _process(delta):
	pass

