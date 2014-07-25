class Transaction
	constructor: (@delta) ->
	valid: ->
		for name, quantity of @delta
			switch
				when save.clock.hasOwnProperty(name)
					# Nothing can fail here
					continue
				when save.stats.hasOwnProperty(name)
					if save.stats[name] + quantity < 0
						return false
				else
					if (save.inventory[name] || 0) + quantity < 0
						return false
		true
	commit: ->
		for name, quantity of @delta
			switch
				when save.clock.hasOwnProperty(name)
					save.clock[name] += quantity
				when save.stats.hasOwnProperty(name)
					save.stats[name] += quantity
				else
					newQuantity = (save.inventory[name] || 0) + quantity
					save.inventory[name] = newQuantity
		fixClock()
		fixStats()
		fixInventory()


fixClock = ->
	save.clock.hour += save.clock.minute // 60
	save.clock.minute %= 60
	save.clock.day += save.clock.hour // 24
	save.clock.hour %= 24
	save.clock.week += save.clock.day // 7
	save.clock.day %= 7

fixStats = ->
	save.stats.energy = 100 if save.stats.energy > 100
	save.stats.health = 100 if save.stats.health > 100

fixInventory = ->
	for item, quantity of save.inventory
		if quantity == 0
			delete save.inventory[item]

say = (msg) ->
	$('#story').prepend($('<p>').text(msg))
	$('#story').children().slice(8).remove()

travel = (place) ->
	return if place == save.place
	new Transaction(minute: 15).commit()
	save.place = place
	renderer.renderEverything()

doAction = (name) ->
	place = places[save.place]
	action = place.actions[name]
	
	if action.transaction
		transaction = action.transaction()
		if !transaction.valid()
			console.log('transaction invalid')
			return
		transaction.commit()
	if action.run
		action.run()
	renderer.renderEverything()
