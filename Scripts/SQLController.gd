extends Control

var database: SQLite

# Called when the node enters the scene tree for the first time.
func _ready():
	database = SQLite.new()
	database.path ="res://data.db"
	database.open_db()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_create_table_button_down():
	var table = {
		"id": {"data_type":"int", "primary_key": true, "not_null": true, "auto_increment": true},
		"name": {"data_type":"text"},
		"score": {"data_type":"int"}
	}
	database.create_table("players", table)
	pass # Replace with function body.


func _on_insert_data_button_down():
	var data = {
		"name": $Name.text,
		"score": int($Score.text)
	}
	
	database.insert_row("players", data)
	pass # Replace with function body.


func _on_select_data_button_down():
	print(database.select_rows("players", "score > 10", ["*"]))
	pass # Replace with function body.


func _on_update_data_button_down():
	database.update_rows("players", "name = '" + $Name.text + "'", {"score": int($Score.text), "name": "mark"})
	pass # Replace with function body.


func _on_delete_data_button_down():
	database.delete_rows("players", "name = '" + $Name.text + "'")
	pass # Replace with function body.


func _on_custom_select_button_down():
	database.query("select * from players
join playerInfo on playerInfo.id = players.playerinfoid
where score > " + $Score.text)
	for i in database.query_result:
		print(i)
	pass # Replace with function body.
