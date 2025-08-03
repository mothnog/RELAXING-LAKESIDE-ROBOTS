@tool
extends CanvasLayer


func _on_child_entered_tree(node):
	if node is TextBox:
		node.in_playground = true
