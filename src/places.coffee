
defaultAction =
	run: ->
	transaction: ->
		new Transaction()
	visible: ->
		true

places =
	alley:
		description: "behind a warehouse downtown"
		actions:
			sleep:
				transaction: ->
					new Transaction(energy: 100, hour: 6)
			beg:
				transaction: ->
					new Transaction(dollar: 1, minute: 30)
	'gas station':
		description: null
		actions: null


for _, place of places
	for _, action of place.actions
		# TODO
		# Don't use __proto__
		# Maybe jQuery extend?
		action.__proto__ = defaultAction


travel = (place) ->
	console.log(place)
	return if place == save.place
	new Transaction(minute: 15).commit()
	save.place = place
	renderer.renderMap()
