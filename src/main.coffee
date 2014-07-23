save = {}

start = ->
	storyAdd("after dropping out of high school and watching porn all day for the last 2 years, your parents finally kick you out of their basement, leaving you on the streets with no job and just a few bucks")
	save =
		clock:
			week: 1
			day: 0
			hour: 6
			minute: 0
		stats:
			energy: 100
			health: 100
			intellegence: 0
		inventory:
			dollar: 15
		places: [
			'alley'
			'gas station'
		]
		place: 'alley'


start()
renderer.renderEverything()
