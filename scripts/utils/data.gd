extends Node

var startingId = 10000

func getNewId() -> int:
	startingId += 1
	return startingId
