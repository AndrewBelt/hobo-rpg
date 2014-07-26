class Transaction
	# example usage:
	# new Transaction(minute: 30, energy: -10, dollar: 10)
	constructor: (args) ->
		@clock = {}
		@stats = {}
		@inventory = {}
		for name, quantity of args
			switch
				when save.clock.hasOwnProperty(name)
					@clock[name] = quantity
				when save.stats.hasOwnProperty(name)
					@stats[name] = quantity
				else
					@inventory[name] = quantity
	
	valid: ->
		for name, quantity of @stats
			if save.stats[name] + quantity < 0
				return false
		for name, quantity of @inventory
			if save.inventory[name] + quantity < 0
				return false
		true
	
	commit: ->
		for name, quantity of @clock
			save.clock[name] += quantity
		fixClock()
		for name, quantity of @stats
			save.stats[name] += quantity
		fixStats()
		for name, quantity of @inventory
			save.inventory[name] = (save.inventory[name] || 0) + quantity
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

clockToString = ->
	day = days[save.clock.day]
	minute = ('0' + Math.floor(save.clock.minute)).substr(-2, 2)
	"week #{save.clock.week} #{day} #{save.clock.hour}:#{minute}"

say = (msg) ->
	gui.story.unshift(msg)
	gui.story.splice(8, Number.MAX_VALUE)

travel = (place) ->
	return if place == save.place
	new Transaction(minute: 15).commit()
	save.place = place
	gui.render()

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
	gui.render()
