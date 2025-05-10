class_name Compose

static var _dict := {}  # entity => ComponentMap

static func _register(entity: Node) -> void:
	if entity not in _dict:
		var map := ComponentMap.new_map(entity)
		_dict[entity] = map

static func get_component(entity: Node, cls: Variant) -> Node:
	_register(entity)
	var map : ComponentMap = _dict[entity]
	var all_matches := map.get_components(cls)
	if all_matches.size() > 1:
		push_warning("Multiple components of type '%s' found on node '%s', using the first one." % [str(cls), entity.name])
	return all_matches[0] if all_matches.size() > 0 else null

static func get_components(entity: Node, cls: Variant) -> Array:
	_register(entity)
	var map : ComponentMap = _dict[entity]
	return map.get_components(cls)

static func get_component_recursive(entity: Node, cls: Variant) -> Node:
	if not is_instance_valid(entity):
		return null
	if Compose.is_of_class(entity, cls):
		return entity
	for child in entity.get_children():
		if not is_instance_valid(child):
			continue
		var found = get_component_recursive(child, cls)
		if found:
			return found
	return null

static func get_components_recursive(entity: Node, cls: Variant) -> Array:
	var results := []
	_get_components_recursive_helper(entity, cls, results)
	return results

static func _get_components_recursive_helper(node: Node, cls: Variant, results: Array) -> void:
	if not is_instance_valid(node):
		return
	if Compose.is_of_class(node, cls):
		results.append(node)
	for child in node.get_children():
		if is_instance_valid(child):
			_get_components_recursive_helper(child, cls, results)

static func is_of_class(node: Node, cls: Variant) -> bool:
	if node == null or cls == null:
		return false

	# Case 1: Script resource
	if cls is Script:
		var current_script := node.get_script()
		while current_script:
			if current_script == cls:
				return true
			current_script = current_script.get_base_script()
		return false

	# Case 2: String (built-in or named custom class)
	if typeof(cls) == TYPE_STRING:
		var cls_name := cls

		# Check class_name (custom scripts)
		var current_script := node.get_script()
		while current_script:
			if current_script.get_class() == cls_name:
				return true
			current_script = current_script.get_base_script()

		# Check native hierarchy
		var current_class := node.get_class()
		while current_class != "":
			if current_class == cls_name:
				return true
			current_class = ClassDB.get_parent_class(current_class)

	return false


class ComponentMap:
	var _entity: Node = null
	var _cache := {}  # cls => Array of Nodes

	func get_component(cls: Variant) -> Node:
		var comps := get_components(cls)
		return comps[0] if comps.size() > 0 else null

	func get_components(cls: Variant) -> Array:
		if not is_instance_valid(_entity):
			return []

		# Use cache if available and valid
		if cls in _cache:
			var valid_cached = _cache[cls].filter(is_instance_valid)
			if valid_cached.size() > 0:
				_cache[cls] = valid_cached
				return valid_cached
			else:
				_cache.erase(cls)

		var matches := []
		for child in _entity.get_children():
			if not is_instance_valid(child):
				continue
			if Compose.is_of_class(child, cls):
				matches.append(child)

		_cache[cls] = matches
		return matches

	static func new_map(entity: Node) -> ComponentMap:
		var map := ComponentMap.new()
		map._entity = entity
		return map
