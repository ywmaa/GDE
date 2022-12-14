extends Control

var system_monitor := preload("res://Apps/SystemMonitor/system_monitor.tscn")
var launcher := preload("res://Apps/Launcher/launcher.tscn")
var launcher_inst : Launcher = launcher.instantiate()

func _ready():
	var system_monitor_inst : SystemMonitor = system_monitor.instantiate()
	add_child(system_monitor_inst)
	add_child(launcher_inst)
	launcher_inst.visible = false

func _process(delta):
	if Input.is_action_just_pressed("Launcher"):
		launcher_inst.position = DisplayServer.window_get_size()/2-launcher_inst.size/2
		launcher_inst.visible = !launcher_inst.visible
