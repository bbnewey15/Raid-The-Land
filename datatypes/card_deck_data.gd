extends Resource
class_name CardDeckData

@export var name: String
#@export var unit_type # TODO#
@export var full_deck_data: Array[CardData] = []
@export var in_play_deck_data: Array[CardData]

func _init():
	self.in_play_deck_data = self.full_deck_data

func grab_slot_data(index: int) -> CardData:
	var data = full_deck_data[index]

	if data: 
		return data
	else:
		return null

func shuffle(deck : Array[CardData]) -> Array[CardData]:
	var tmp_deck = deck.duplicate()
	var array_length = tmp_deck.size()

	# Fisher-Yates shuffle algorithm
	for i in range(array_length - 1, 0, -1):
		var random_index = randi() % (i + 1) # Generate a random index between 0 and i (inclusive).
		tmp_deck.swap(i, random_index) # Swap the elements at index i and the random index.
	
	return tmp_deck

func draw(num: int) -> Array[CardData]:
	var drawn_cards = []
	for i in range(num-1):
		# Check if deck is empty
		if self.in_play_deck_data.size() == 0:
			# Animate 
			
			# Shuffle deck
			print("Shuffling deck...")
			
			# exclude cards already drawn or no longer available
			var tmp_deck = self.full_deck_data.duplicate()
			for card in drawn_cards:
				var found_card_idx = tmp_deck.find(card)
				if found_card_idx:
					tmp_deck.remove_at(found_card_idx)
			
			if tmp_deck.size() == 0:
				print("No cards left")
				assert(false)
				
			
			self.in_play_deck_data = shuffle(tmp_deck)
		
		drawn_cards.append(self.in_play_deck_data.pop_front())
		
	if drawn_cards.size() < num:
		assert(false)
		
	return drawn_cards
