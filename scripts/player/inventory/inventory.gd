extends Resource
class_name Inv

signal update
@export var slots: Array[InvSlot]

func has_item() -> bool:
	for s in slots:
		if s.item != null and s.amount > 0:
			return true
	return false

func first_item() -> InvItem:
	for s in slots:
		if s.item != null and s.amount > 0:
			return s.item
	return null

func remove_one(item: InvItem = null) -> InvItem:
	if item != null:
		for s in slots:
			if s.item == item and s.amount > 0:
				s.amount -= 1
				if s.amount <= 0:
					s.item = null
					s.amount = 0
				update.emit()
				return item
		return null
	for s in slots:
		if s.item != null and s.amount > 0:
			var it := s.item
			s.amount -= 1
			if s.amount <= 0:
				s.item = null
				s.amount = 0
			update.emit()
			return it
	return null

# non-stacking insert: only into an empty slot
func insert_single(item: InvItem) -> bool:
	for s in slots:
		if s.item == null or s.amount == 0:
			s.item = item
			s.amount = 1
			update.emit()
			return true
	return false

# existing single-item behavior for the player
func insert(item: InvItem) -> bool:
	if has_item():
		return false
	for s in slots:
		if s.item == null or s.amount == 0:
			s.item = item
			s.amount = 1
			update.emit()
			return true
	return false

func is_full() -> bool:
	for s in slots:
		if s.item == null or s.amount == 0:
			return false
	return true
