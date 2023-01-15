@tool
extends Control

var dir_path = '.'
var cmd_directory = ['ls', 'dir']
var history_loaded = false
var command_history = []
var history_file = 'user://.gdterm_history'
var history_enabled = false
var current_history_index = -1
var command_split = RegEx.new()
var pipe_file = 'user://.gdterm_pipe'
var cd = EditorFileSystemDirectory.new()
var file : FileAccess
var base_dir = "res://"
var sudo_args = []
var password_commands = ['sudo', 'git']
var help_full = """
intro:
	usage: intro [--help]
	--help			Show all help
godot:
	usage: godot [options] [path to scene or 'project.godot' file]
	-h, --help		Display full help message.
	Example:
		Run a scene on separated window:
			godot [options] path/to/scene/file.tscn [arguments]
shell commands:
	you can use shell commnads like:
		cd, ls, mkdir, chmod, echo, git, cat, etc...; into your godot project.
		pipes (|) with grep, awk, sed, etc...
navigation:
	←:				Back.
	→:				Forward.
	↑:				Prev command.
	↓:				Next command.
	history:		Show all executed commands.
	pwd:			Show current dir.
	reset:			Clean terminal.
theme:
	color:			change backgorund and foreground color
	Example:
		color ff000000 ffffffff  # ARGB format
		color back white  # X11 names format
	font:			change font attributes: font <size> [<outliner-size> [outliner-color]]
	Example with default values:
		font 12 0 white #color supported format

Terminal {version} - RKiemGames - MIT Licence
Report bugs: https://github.com/RKiemGames/godot-terminal-addons/issues
"""

var colors_array : Array = [ #256 colors array
  "#000000",
  "#800000",
  "#008000",
  "#808000",
  "#000080",
  "#800080",
  "#008080",
  "#c0c0c0",
  "#808080",
  "#ff0000",
  "#00ff00",
  "#ffff00",
  "#0000ff",
  "#ff00ff",
  "#00ffff",
  "#ffffff",
  "#000000",
  "#00005f",
  "#000087",
  "#0000af",
  "#0000d7",
  "#0000ff",
  "#005f00",
  "#005f5f",
  "#005f87",
  "#005faf",
  "#005fd7",
  "#005fff",
  "#008700",
  "#00875f",
  "#008787",
  "#0087af",
  "#0087d7",
  "#0087ff",
  "#00af00",
  "#00af5f",
  "#00af87",
  "#00afaf",
  "#00afd7",
  "#00afff",
  "#00d700",
  "#00d75f",
  "#00d787",
  "#00d7af",
  "#00d7d7",
  "#00d7ff",
  "#00ff00",
  "#00ff5f",
  "#00ff87",
  "#00ffaf",
  "#00ffd7",
  "#00ffff",
  "#5f0000",
  "#5f005f",
  "#5f0087",
  "#5f00af",
  "#5f00d7",
  "#5f00ff",
  "#5f5f00",
  "#5f5f5f",
  "#5f5f87",
  "#5f5faf",
  "#5f5fd7",
  "#5f5fff",
  "#5f8700",
  "#5f875f",
  "#5f8787",
  "#5f87af",
  "#5f87d7",
  "#5f87ff",
  "#5faf00",
  "#5faf5f",
  "#5faf87",
  "#5fafaf",
  "#5fafd7",
  "#5fafff",
  "#5fd700",
  "#5fd75f",
  "#5fd787",
  "#5fd7af",
  "#5fd7d7",
  "#5fd7ff",
  "#5fff00",
  "#5fff5f",
  "#5fff87",
  "#5fffaf",
  "#5fffd7",
  "#5fffff",
  "#870000",
  "#87005f",
  "#870087",
  "#8700af",
  "#8700d7",
  "#8700ff",
  "#875f00",
  "#875f5f",
  "#875f87",
  "#875faf",
  "#875fd7",
  "#875fff",
  "#878700",
  "#87875f",
  "#878787",
  "#8787af",
  "#8787d7",
  "#8787ff",
  "#87af00",
  "#87af5f",
  "#87af87",
  "#87afaf",
  "#87afd7",
  "#87afff",
  "#87d700",
  "#87d75f",
  "#87d787",
  "#87d7af",
  "#87d7d7",
  "#87d7ff",
  "#87ff00",
  "#87ff5f",
  "#87ff87",
  "#87ffaf",
  "#87ffd7",
  "#87ffff",
  "#af0000",
  "#af005f",
  "#af0087",
  "#af00af",
  "#af00d7",
  "#af00ff",
  "#af5f00",
  "#af5f5f",
  "#af5f87",
  "#af5faf",
  "#af5fd7",
  "#af5fff",
  "#af8700",
  "#af875f",
  "#af8787",
  "#af87af",
  "#af87d7",
  "#af87ff",
  "#afaf00",
  "#afaf5f",
  "#afaf87",
  "#afafaf",
  "#afafd7",
  "#afafff",
  "#afd700",
  "#afd75f",
  "#afd787",
  "#afd7af",
  "#afd7d7",
  "#afd7ff",
  "#afff00",
  "#afff5f",
  "#afff87",
  "#afffaf",
  "#afffd7",
  "#afffff",
  "#d70000",
  "#d7005f",
  "#d70087",
  "#d700af",
  "#d700d7",
  "#d700ff",
  "#d75f00",
  "#d75f5f",
  "#d75f87",
  "#d75faf",
  "#d75fd7",
  "#d75fff",
  "#d78700",
  "#d7875f",
  "#d78787",
  "#d787af",
  "#d787d7",
  "#d787ff",
  "#d7af00",
  "#d7af5f",
  "#d7af87",
  "#d7afaf",
  "#d7afd7",
  "#d7afff",
  "#d7d700",
  "#d7d75f",
  "#d7d787",
  "#d7d7af",
  "#d7d7d7",
  "#d7d7ff",
  "#d7ff00",
  "#d7ff5f",
  "#d7ff87",
  "#d7ffaf",
  "#d7ffd7",
  "#d7ffff",
  "#ff0000",
  "#ff005f",
  "#ff0087",
  "#ff00af",
  "#ff00d7",
  "#ff00ff",
  "#ff5f00",
  "#ff5f5f",
  "#ff5f87",
  "#ff5faf",
  "#ff5fd7",
  "#ff5fff",
  "#ff8700",
  "#ff875f",
  "#ff8787",
  "#ff87af",
  "#ff87d7",
  "#ff87ff",
  "#ffaf00",
  "#ffaf5f",
  "#ffaf87",
  "#ffafaf",
  "#ffafd7",
  "#ffafff",
  "#ffd700",
  "#ffd75f",
  "#ffd787",
  "#ffd7af",
  "#ffd7d7",
  "#ffd7ff",
  "#ffff00",
  "#ffff5f",
  "#ffff87",
  "#ffffaf",
  "#ffffd7",
  "#ffffff",
  "#080808",
  "#121212",
  "#1c1c1c",
  "#262626",
  "#303030",
  "#3a3a3a",
  "#444444",
  "#4e4e4e",
  "#585858",
  "#606060",
  "#666666",
  "#767676",
  "#808080",
  "#8a8a8a",
  "#949494",
  "#9e9e9e",
  "#a8a8a8",
  "#b2b2b2",
  "#bcbcbc",
  "#c6c6c6",
  "#d0d0d0",
  "#dadada",
  "#e4e4e4",
  "#eeeeee"
]

func _ready():
	var config = ConfigFile.new()
	config.load('addons/terminal/plugin.cfg')
	var version = config.get_value('plugin', 'version')
	config = null
	help_full = help_full.replace('{version}', version)
	$TextEdit.insert_text_at_caret("")
	load_history()


func load_history():
	if FileAccess.file_exists(history_file):
		file = FileAccess.open(history_file, FileAccess.READ)
		var content = file.get_as_text()
		for cmd in content.split('\n', false):
			command_history.append(cmd)
		current_history_index = command_history.size()
	history_loaded = true


func _on_LineEdit_gui_input(event):
	if not history_loaded:
		load_history()
	if event is InputEventKey and event.keycode in [KEY_UP, KEY_DOWN] and command_history.size():
		history_enabled = true
		$HBoxContainer/LineEdit.disconnect("gui_input", self._on_LineEdit_gui_input)
		if event.keycode == KEY_UP and current_history_index > 0:
			current_history_index -= 1
		if event.keycode == KEY_DOWN and current_history_index < command_history.size() - 1:
			current_history_index += 1
		$HBoxContainer/LineEdit.text = command_history[current_history_index]
		$HBoxContainer/LineEdit.connect("gui_input", self._on_LineEdit_gui_input)
		$HBoxContainer/LineEdit.grab_focus()
	if event is InputEventKey and not event.keycode in [KEY_ENTER, KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN]:
		history_enabled = false


func parse_command(text, pipe=false):
	command_split.compile('["\'][^"\']* +[^"\']*["\']')
	for g in command_split.search_all(text):
		var t = g.get_string()
		text = text.replace(t,t.replace(' ', '·'))
	var result = text.rsplit(' ', false)
	var command = result[0]
	var args = []
	result.remove_at(0)
	for a in result:
		if command == 'awk':
			a = a.replace('$', '\\$')
		a = a.replace("'", '').replace('"', '').replace('·', ' ')
		args.append(a)
	if pipe:
		file.open(pipe_file, FileAccess.READ)
		args.append(file.get_path_absolute())
	var output = []
	result = ""
	var blocking = true
	if command == 'color':
		var bg = Color(args[0])
		var fg = Color(args[1])
		if fg == bg || fg == null:
			fg = bg.inverted()
		$Background.color = bg
		$TextEdit.modulate = fg
		$HBoxContainer.modulate = fg
		return
	if command == 'font':
		var fz = int(args[0])
		var foz = 0
		var foc = Color('white')
		if args.size() > 1:
			foz = int(args[1])
		if args.size() > 2:
			foc = Color(args[2])
			if not foc:
				foc = Color(args[2])
		var dynamic_font:Font = get_theme().default_font
		dynamic_font.size = fz
		dynamic_font.outline_size = foz
		dynamic_font.outline_color = foc
		dynamic_font.update_changes()
		return
	if command == 'git':
		if 'push' in args or 'publish' in args:
			var dargs = args
			var fargs = dargs.pop_front()
			if fargs == 'flow':
				dargs.pop_front()
				dargs.pop_front()
			var repo = 'origin'
			if dargs.size() > 1:
				var aux_args = []
				for a in dargs:
					if not a.begins_with('-'):
						break
					aux_args.append(a)
					dargs.pop_front()
				if dargs.size() > 1:
					repo = dargs[0]
					dargs.pop_front()
			OS.execute("git", ['remote', 'get-url', '--push', repo], output)
			var git_url = output[0]
			if not git_url.begins_with('git@'):
				var url = git_url.rsplit('//')[1]
				if '@' in url:
					var user = url.rsplit('@')[0]
					$Dialog/User.text = user
					git_url = git_url.replace('%s@' % user, '')
				$Dialog.set_meta('args', dargs)
				$Dialog.set_meta('git_url', git_url)
				open_dialog('git_push', true)
				return
			output = []
	if command == 'godot':
		command = OS.get_executable_path()
		if args:
			var gdfile = args[args.size() - 1]
			if '.tscn' in gdfile or '.godot' in gdfile:
				args[args.size() - 1]  = dir_path + '/' + gdfile
			blocking = ('--help' in args or '-h' in args)
		else:
			args = ['-e']
	if command == 'cd':
		var chdir = ''
		var current_dir = dir_path
		if args:
			chdir = args[0]
		if chdir:
			var dirs = (dir_path + '/' + chdir).split('/', false)
			var di = 0
			for d in dirs:
				if d == '..':
					dirs.remove(di)
					di -= 1
					if di >= 0:
						dirs.remove(di)
						di -= 1
				elif d == '.':
					dirs.remove(di)
					di -= 1
				di += 1
			dir_path = dirs.join('/')
			dirs = null
		else:
			dir_path = '.'
		if not dir_path:
			dir_path = '.'
		if not cd.dir_exists('res://%s' % dir_path):
			print_results('directory not exists: %s\n' % chdir)
			dir_path = current_dir
			return
		$HBoxContainer/Prompt.text = 'res://%s>' % dir_path.lstrip('.')
		return
	if command == 'pwd':
		print_results($HBoxContainer/Prompt.text.replace('>', ''))
		return
	if command == 'history':
		var l = 1
		for c in command_history:
			print_results("%s\t%s\n" % [str(l),c])
			l+=1
		return
	if command == 'sudo' and OS.get_name() != 'Windows':
		open_dialog(command)
		sudo_args = args
		return
	if command in cmd_directory:
		args.append(dir_path)
	if command == 'start' and not '/?' in args:
		blocking = false
	# TODO: Implicitly blocks. Use create_process if blocking == false.
	OS.execute(command, args, output, true)
	if not blocking:
		return
	for l in output:
		result += l
	if command in ['reset', 'clear', 'cls']:
		$TextEdit.text = ""
		return
	return result


func open_dialog(command, username=false):
	
	var height = 32
	$Dialog/Password.margin_top = -12
	$Dialog/User.visible = false
	$Dialog.set_meta('command', command)
	if username:
		height = 64
		$Dialog/Password.margin_top = 3
		$Dialog/User.visible = true
	$Dialog/Password.text = ""
	$Dialog.popup_centered(Vector2(330,height))
	$Dialog/Password.grab_focus()


func print_results(result):
	print_rich(ansi_to_bbcode(result))
	$TextEdit.set_caret_line($TextEdit.get_line_count() - 1)
	$TextEdit.set_caret_column(0)
	$TextEdit.insert_text_at_caret(result)
	$TextEdit.clear_undo_history()
	
#	$TextEdit.append_text(result)

func ansi_to_bbcode(p_ansi: String) -> String:
	# `\u001b` is the Unicode escape sequence for the ANSI escape code
	# (also known as `\033` and `\x1b`).
	print(p_ansi)
	var begin := Time.get_ticks_usec()
	p_ansi = (p_ansi
			.replace("\u001b[0m","[color=white]")
			# Bold.
			.replace("\u001b[1m","[b]")
			.replace("\u001b[22m","[/b]")
			# Italic.
			.replace("\u001b[3m","[i]")
			.replace("\u001b[23m","[/i]")
			# Underline.
			.replace("\u001b[4m","[u]")
			.replace("\u001b[24m","[/u]")
			# Strikethrough.
			.replace("\u001b[9m","[s]")
			.replace("\u001b[29m","[/s]")
			# Indentation (looks equivalent to 4 spaces).
#			.replace("    ","[indent]")
#			.replace("","[/indent]")

			# Code.
			# Terminal fonts are already fixed-width, so use faint coloring to distinguish it
			# from normal text.
			.replace("\u001b[2m","[code]")
			.replace("\u001b[22m","[/code]")

			# Without knowing the terminal width, we can't fully emulate [center] and [right] behavior.
			# This is only an approximation that doesn't take the terminal width into account.
			.replace("\\n\\t\\t\\t","[center]")
			.replace("","[/center]")
			.replace("\\n\\t\\t\\t\\t\\t\\t","[right]")
			.replace("","[/right]")

			# URL (link).
			# Only unnamed URLs can be universally supported in terminals (by letting the terminal
			# recognize it as-is). As of April 2022, support for named URLs is still in progress
			# for many popular terminals.
			.replace("","[url]")
			.replace("","[/url]")

			# Text color.
			.replace("\u001b[30m","[color=black]")
			.replace("\u001b[31m","[color=red]")
			.replace("\u001b[32m","[color=green]")
			.replace("\u001b[33m","[color=yellow]")
			.replace("\u001b[34m","[color=blue]")
			.replace("\u001b[35m","[color=magenta]")
			.replace("\u001b[36m","[color=cyan]")
			.replace("\u001b[37m","[color=white]")
			.replace("\u001b[39m","[/color]")


			# Background color (highlighting text).
			.replace("\u001b[40m","[bgcolor=black]")
			.replace("\u001b[41m","[bgcolor=red]")
			.replace("\u001b[42m","[bgcolor=green]")
			.replace("\u001b[42m","[bgcolor=lime]")
			.replace("\u001b[43m","[bgcolor=yellow]")
			.replace("\u001b[44m","[bgcolor=blue]")
			.replace("\u001b[45m","[bgcolor=magenta]")
			.replace("\u001b[46m","[bgcolor=cyan]")
			.replace("\u001b[47m","[bgcolor=white]")
			.replace("\u001b[49m","[/bgcolor]")

			# Foreground color (redacting text).
			# Emulated by using the same color for both foreground and background.
#			.replace("\u001b[90m", "[fgcolor=black]")
#			.replace("\u001b[91m", "[fgcolor=red]")
#			.replace("\u001b[92m","[fgcolor=green]")
#			.replace("\u001b[92;102m", "[fgcolor=lime]")
#			.replace("\u001b[93;103m","[fgcolor=yellow]")
#			.replace("\u001b[94;104m","[fgcolor=blue]")
#			.replace("\u001b[95;105m","[fgcolor=magenta]")
#			.replace("\u001b[96;106m","[fgcolor=cyan]")
#			.replace("\u001b[97;107m","[fgcolor=white]")
#			.replace("\u001b[90;100m","[fgcolor=gray]")
#			.replace("\u001b[99;49m", "[/fgcolor]")
	)
	var regex : RegEx = RegEx.new()
	regex.compile("\u001b[0m") #reset each bbcode tag (needs work)
	for m in regex.search_all(p_ansi):
		print(m.get_string())

	regex.compile("\u001b\\[38;5;[0-255]+m")
	for m in regex.search_all(p_ansi):
		var color_code : String = m.get_string()
		color_code = color_code.lstrip(color_code.left(7))
		color_code = color_code.rstrip(color_code.right(1))
		print(m.get_string(),"[color="+colors_array[color_code.to_int()]+"]")
		p_ansi = p_ansi.replace(m.get_string(),"[color="+colors_array[color_code.to_int()]+"]")
	regex.compile("\u001b\\[48;5;[0-255]+m")
	for m in regex.search_all(p_ansi):
		var color_code : String = m.get_string()
		color_code = color_code.lstrip(color_code.left(7))
		color_code = color_code.rstrip(color_code.right(1))
		print(m.get_string(),"[bgcolor="+colors_array[color_code.to_int()]+"]")
		p_ansi = p_ansi.replace(m.get_string(),"[bgcolor="+colors_array[color_code.to_int()]+"]")
	var end := Time.get_ticks_usec()

	print("Replacing BBCode with ANSI escape codes in the text below took %d microseconds.\n----\n" % (end - begin))

	return p_ansi

func update_history(text):

	if history_enabled:
		return
	command_history.append(text)
	var mode = FileAccess.READ_WRITE
	if not FileAccess.file_exists(history_file):
		mode = FileAccess.WRITE
	var file = FileAccess.open(history_file, mode)
	file.seek_end()
	file.store_string(text + '\n')


func enter_text(new_text):
	update_history(new_text)
	current_history_index = command_history.size()
	var pipe_command = new_text.split('|')
	var result = null
	$HBoxContainer/LineEdit.text = ""
	if pipe_command.size() > 1:
		var array_cmd = []
		for cmd in pipe_command:
			array_cmd.append(cmd.lstrip(' ').rstrip(' '))
		var first = array_cmd.pop_front()
		result = parse_command(first)
		var f = FileAccess.open(pipe_file, FileAccess.WRITE)
		f.store_string(result)
		for cmd in array_cmd:
			result = parse_command(cmd, true)
			cd.remove(pipe_file)
			f = FileAccess.open(pipe_file, FileAccess.WRITE)
			f.store_string(result)
		cd.remove(pipe_file)
		print_results(result)
		return
	result = parse_command(new_text)
	if result:
		print_results(result)


func _on_LineEdit_text_entered(new_text):
	enter_text(new_text)


func _on_TextEdit_gui_input(event):
	pass
#	$HBoxContainer/LineEdit.grab_focus()


func _on_git_push(password):
	var git_url = $Dialog.get_meta('git_url').rsplit('//')
	var args = $Dialog.get_meta('args')
	var prefix = git_url[0]
	var repo = git_url[1].replace('\n','')
	var user = $Dialog/User.text
	var output = []
	password = HTTPClient.new().query_string_from_dict({u=password}).replace('u=', '')
	$Dialog.visible = false
	await get_tree().create_timer(0.034).timeout
	OS.execute('git', ['push', '%s//%s:%s@%s' % [prefix, user, password, repo]] + args, output, true)
	for o in output:
		print_results(o.replace(':%s' % password, ':*****'))
		o = null
	output = []


func _on_sudo(password):
	var output = []
	var base_args = ['SUDO_PASS=%s' % password, 'SUDO_ASKPASS=addons/terminal/pass.sh','sudo', '-A']
	$Dialog.visible = false
	await get_tree().create_timer(0.034).timeout
	OS.execute('env', base_args + sudo_args, output, false)
	for o in output:
		print_results(o)
		o = null


func _on_Password_text_entered(password):
	call('_on_%s' % $Dialog.get_meta('command'), password)
