extends Resource
class_name UnitStatData

@export var attributes : Array[UnitStatItemData]

func getAttribute(attribute_name: GameData.UNIT_DATA_ATTRIBUTES  )-> UnitStatItemData:
	assert(attribute_name or attribute_name == 0)
	for attribute in attributes:
		if attribute.accessor == attribute_name:
			return attribute
			
	assert(false, "No attribute found in getAttribute")
	return null
		
	
func getAttributes() -> Array[UnitStatItemData]:
	# order attriutes according to UnitStatItemData.display_order
	var ordered_attributes = self.sort_attributes(self.attributes)
	return ordered_attributes
	
func sort_attributes(full_array: Array[UnitStatItemData], custom_sorter = null) -> Array[UnitStatItemData]:
	if(custom_sorter != null):
		full_array.sort_custom(custom_sorter)
	else:
		full_array.sort_custom(self.sortByDisplayOrderComparison)
	var final_array : Array[UnitStatItemData] = []
	final_array.append_array(full_array)
	return final_array

func sortByDisplayOrderComparison(a : UnitStatItemData, b : UnitStatItemData):
	return a.display_order < b.display_order

func updateAttribute(attribute_name: GameData.UNIT_DATA_ATTRIBUTES, new_value: int):
	assert(attribute_name or attribute_name == 0)
	assert(new_value or new_value == 0)
	
	for attribute in attributes:
		if attribute.accessor == attribute_name:
			attribute.updateValue(new_value)
			print("Updated attribute %s with new value %s" % [attribute.display_name, new_value])
			EncounterBus.slot_data_changed.emit()
			return
		
	assert(false, "No attribute found in getAttribute")
