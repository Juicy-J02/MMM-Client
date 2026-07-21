extends HBoxContainer

@onready var board = $"../Board"

func create_columns():
	for child in get_children():
		child.queue_free()

	for i in range(board.cols):
		var panel = Panel.new()
		panel.custom_minimum_size.x = board.cell_width
		panel.custom_minimum_size.y = board.board_size.y
		panel.modulate.a = 0.5
		
		panel.set_meta("column_index", i)
		
		add_child(panel)

func get_column_under_mouse():
	var mouse_pos = get_global_mouse_position()

	for child in get_children():
		if child.get_global_rect().has_point(mouse_pos):
			return child.get_meta("column_index")

	return -1
