extends Node
class_name MiscUtils

static func setDisabledForChildrenCollisionShapes(node: Node, disabled: bool, recursive: bool) -> void:
	for child in node.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", disabled)
		if recursive:
			setDisabledForChildrenCollisionShapes(child, disabled, recursive)

static func setDisabledForChildrenSprite2D(node: Node, disabled: bool, recursive: bool) -> void:
	for child in node.get_children():
		if child is AnimatedSprite2D or child is Sprite2D:
			child.set_deferred("disabled", disabled)
		if recursive:
			setDisabledForChildrenSprite2D(child, disabled, recursive)
