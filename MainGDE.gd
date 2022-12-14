extends Control


var system_monitor := preload("res://Apps/SystemMonitor/system_monitor.tscn")

var launcher := preload("res://Apps/Launcher/launcher.tscn")
var launcher_inst : Launcher = launcher.instantiate()

var dock := preload("res://Apps/Dock/dock.tscn")
var dock_inst : Dock = dock.instantiate()


var context_menu : PopupMenu = PopupMenu.new()
@onready var desktop_background : TextureRect = get_node("Desktop Background")

func _ready():
	desktop_background.connect("gui_input",_on_desktop_background_gui_input)
	add_child(dock_inst)
	var system_monitor_inst : SystemMonitor = system_monitor.instantiate()
	add_child(system_monitor_inst)
	add_child(launcher_inst)
	add_child(context_menu)
	launcher_inst.visible = false

func _process(delta):
	if Input.is_action_just_pressed("Launcher"):
		launcher_inst.position = DisplayServer.window_get_size()/2-launcher_inst.size/2
		launcher_inst.visible = !launcher_inst.visible

func create_desktop_context_menu():
	context_menu.clear()
	context_menu.add_item("Change Background")
	context_menu.connect("id_pressed",desktop_context_menu_item_pressed)
	context_menu.position = get_global_mouse_position()
	context_menu.visible = true

func desktop_context_menu_item_pressed(id: int):
	match id:
		0:
			var background_images : Array = [load("res://Default Wallpapers/PlanetEarthBlenderEevee.png"),load("res://Default Wallpapers/wallpaperflare.com_wallpaper (2).jpg"),load("res://Default Wallpapers/wallpaperflare.com_wallpaper.jpg")]
			var current_texture : int
			for t in background_images:
				if desktop_background.texture == t:
					current_texture = background_images.find(t)
					break
			desktop_background.texture = background_images[current_texture + 1 if current_texture < 2 else 0]
	
func _on_desktop_background_gui_input(event):
	if Input.is_action_just_pressed("context menu"):
		create_desktop_context_menu()
