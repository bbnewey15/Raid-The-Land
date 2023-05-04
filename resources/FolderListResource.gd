extends Node
class_name FolderListResource

		
@export
var ResourceCategory : String

# if I call load_all_resources multiple times than this will be overwritten
var all_resources = []

func load_all_resources(FolderPath: String)-> Array[Resource]:
	all_resources.clear()
	if FolderPath:
		var folder = DirAccess.open(FolderPath)
		folder.list_dir_begin()
		
		var file_name = folder.get_next()
		while file_name != "":
			if not folder.current_is_dir() and file_name.find(".gd"):
				all_resources.push_back(load(FolderPath.path_join(file_name)))
			
			file_name = folder.get_next()
		
		folder.list_dir_end()
	else:
		print("An error occured when trying to acces the resource folder")
		
	return all_resources
		
func load_specific_resources(ResourcePath: String)-> Resource:
	if ResourcePath:
		return load(ResourcePath)
	else:
		print("An error occured when trying to acces the specific resource")
	return
		
func find_index_of(resource: Resource) -> int:
	return all_resources.find(resource)
