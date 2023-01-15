extends Node

var available_apps : Array[app_data]
var watcher = DirectoryWatcher.new()


func _ready():
	add_child(watcher)
	watcher.files_created.connect(on_files_created)
	watcher.files_modified.connect(on_files_modified)
	watcher.files_deleted.connect(on_files_deleted)
	
	var data_paths_array : PackedStringArray = OS.get_environment("XDG_DATA_DIRS").split(":")
	for path in data_paths_array:
		if DirAccess.dir_exists_absolute(str(path) + "applications/"):
			watcher.add_scan_directory(str(path) + "applications/")

	
	
func launch_app(app_name:String):
	var pid = OS.create_process("bash",["-c",app_name])
#	running_apps.append(pid)
#	print(running_apps)

func add_system_app(app:app_data):
	if !available_apps.has(app):
		available_apps.append(app)

func on_files_created(files):
	for file in files:
		if str(file).get_extension() == "desktop":
			add_standard_app_id(file)

func on_files_modified(files):
	pass
	
func on_files_deleted(files):
	pass


#https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#desktop-file-id
func add_standard_app_id(file: String):
	file = file.get_file()
	file = file.replace("/", "-");
	file = file.replace(".desktop", "")
	print(file)
