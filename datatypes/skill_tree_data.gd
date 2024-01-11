extends Resource
class_name SkillTreeData

# to scale, make mutlidemensional
@export var skill_tree_level_1: Array[SkillTreeItemData] = []

func level_up(item_name: String, increase_by: int) -> bool:
	for item in skill_tree_level_1:
		if item.item_name == item_name:
			item.increase_level(increase_by)
			return true
	
	push_error("Failed to find item to increase level in level_up")
	return false
