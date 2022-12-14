extends Node
var running_apps : Array



func launch_app(app_name:String):
	var pid = OS.create_process("bash",["-c",app_name])
	
	
	running_apps.append(pid)
	print(running_apps)
