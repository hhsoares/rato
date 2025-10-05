extends Resource
class_name Inv

signal update

@export var slots: Array[InvSlot]

func has_item() -> bool:
	for s in slots:
		if s.item != null and s.amount > 0:
			return true
	return false
	
func insert(item: InvItem) -> bool:
	# single-item inventory: refuse if already holding something
	if has_item():
		return false

	# put item into first empty slot
	for s in slots:
		if s.item == null or s.amount == 0:
			s.item = item
			s.amount = 1
			update.emit()
			return true
	return false
