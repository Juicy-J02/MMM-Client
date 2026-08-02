extends VBoxContainer

@onready var board = $"../Board"

func create_rows():
	for child in get_children():
		child.queue_free()

	for i in range(board.rows):
		var panel = Panel.new()
		panel.custom_minimum_size.x = board.board_size.x
		panel.custom_minimum_size.y = board.cell_height
		panel.modulate.a = 0.5
		
		panel.set_meta("row_index", i)
		
		add_child(panel)

func get_row_under_mouse():
	var mouse_pos = get_global_mouse_position()

	for child in get_children():
		if child.get_global_rect().has_point(mouse_pos):
			return child.get_meta("row_index")

	return -1
