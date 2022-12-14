extends Control



func _ready():
	var output : Array #use it to retrieve results from bash commands
	$RichTextLabel.text = ""
	print(OS.get_distribution_name())
	OS.execute("bash",["-c","echo ${APTCACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/apt}"],output,true)
	OS.execute("bash",["-c","echo ${APTSTATE:-${XDG_STATE_HOME:-$HOME/.local/state}/apt}"],output,true)
	OS.execute("bash",["-c","echo ${APTCONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/crackle}"],output,true)
	
	
#	OS.execute("ls",[],output,true)
	
	for text in output:
		$RichTextLabel.text += text



#APTCACHE=${APTCACHE:-${XDG_CACHE_HOME:-$HOME/.cache}/apt};
#APTSTATE=${APTSTATE:-${XDG_STATE_HOME:-$HOME/.local/state}/apt};
#APTCONFIG=${APTCONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/crackle};
