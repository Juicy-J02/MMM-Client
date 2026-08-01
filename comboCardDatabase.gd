extends Node

const CARDS = {
	"Skele-Ton" : {
		"type": "combo",
		"action_type": "column_select",
		"card_number": 1,
		"card_type": "Monster Match",
		"combo_cards": {
			"card1": "Skeleton",
			"card2": "BuffUp",
		}
	},
	
	"Chilly": {
		"type": "combo",
		"action_type": "board_select",
		"card_number": 2,
		"card_type": "Spirits",
		"combo_cards": {
			"card1": "FireSpirit",
			"card2": "IceSpirit",
		}
	},
}
