class Transaction
	# example usage:
	# new Transaction(minute: 30, energy: -10, dollar: 10)
	constructor: (args) ->
		@clock = 0
		@stats = {}
		@inventory = {}
		for name, quantity of args
			switch name
				when 'minute'
					@clock += quantity
				when 'hour'
					@clock += 60*quantity
				when 'day'
					@clock += 24*60*quantity
				else
					if save.stats.hasOwnProperty(name)
						@stats[name] = quantity
					else
						@inventory[name] = quantity
	
	error: ->
		for name, quantity of @stats
			if save.stats[name] + quantity < 0
				return name
		for name, quantity of @inventory
			if (save.inventory[name] || 0) + quantity < 0
				return name
		null
	
	commit: ->
		if @clock
			save.clock += @clock
		for name, quantity of @stats
			save.stats[name] += quantity
		fixStats()
		for name, quantity of @inventory
			save.inventory[name] = (save.inventory[name] || 0) + quantity
		fixInventory()
	
	flatten: ->
		obj = {}
		if @clock
			obj['clock'] = @clock
		for name, quantity of @stats
			obj[name] = quantity
		for name, quantity of @inventory
			obj[name] = quantity
		obj


fixStats = ->
	save.stats.energy = 100 if save.stats.energy > 100
	save.stats.health = 100 if save.stats.health > 100

fixInventory = ->
	for item, quantity of save.inventory
		# Clear out unused items
		if quantity == 0
			delete save.inventory[item]

clockToString = ->
	minute = save.clock
	hour = minute // 60
	day = hour // 24
	week = day // 7 + 1
	minute %= 60
	hour %= 24
	day %= 7
	minuteString = ('0' + Math.floor(minute)).substr(-2, 2)
	"week #{week} #{days[day]} #{hour}:#{minuteString}"

say = (msg) ->
	gui.say(msg)

travel = (place) ->
	return if place == save.place
	new Transaction(minute: 15).commit()
	save.place = place
	gui.render()

doAction = (action) ->
	if action.transaction
		transaction = action.transaction()
		error = transaction.error()
		if error
			say("not enough #{error}")
			return
		else
			transaction.commit()
	if action.run
		action.run()
	gui.render()

setTransaction = (action) ->
	if action.transaction
		transaction = action.transaction()
		gui.openTooltip(transaction)

clearTransaction = ->
	gui.closeTooltip()

choose = (arr) ->
	arr[Math.floor(Math.random() * arr.length)]
