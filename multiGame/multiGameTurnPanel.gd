extends Panel

var active_style
var inactive_style

func _ready():
	active_style = StyleBoxFlat.new()
	active_style.bg_color = Color.DARK_GREEN
	active_style.corner_radius_bottom_left = 16
	active_style.corner_radius_bottom_right = 16
	active_style.corner_radius_top_left = 16
	active_style.corner_radius_top_right = 16

	inactive_style = StyleBoxFlat.new()
	inactive_style.bg_color = Color.DARK_RED
	inactive_style.corner_radius_bottom_left = 16
	inactive_style.corner_radius_bottom_right = 16
	inactive_style.corner_radius_top_left = 16
	inactive_style.corner_radius_top_right = 16

func _process(_delta):
	if Game.turn == Game.current_turn:
		add_theme_stylebox_override("panel", active_style)
	else:
		add_theme_stylebox_override("panel", inactive_style)
