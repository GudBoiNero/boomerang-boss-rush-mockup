extends EditorPlugin

var singleton: Compose

func _enter_tree():
	singleton = Compose.new()
	get_tree().get_root().add_child(singleton)
	singleton.name = "Compose"  # name it for global access

func _exit_tree():
	singleton.queue_free()
