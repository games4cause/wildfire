@tool
extends "res://addons/gaea/graph/nodes/root/data/filters/filter.gd"


func _passes_filter(_passed_data: Dictionary, cell: Vector3i, generator_data: GaeaData) -> bool:
	var point: Vector3 = get_arg("to_point", generator_data)
	var distance_range: Dictionary = get_arg("distance_range", generator_data)
	var distance: float = Vector3(cell).distance_squared_to(point)
	return distance >= distance_range.get("min", -INF) ** 2 and distance <= distance_range.get("max", INF) ** 2
