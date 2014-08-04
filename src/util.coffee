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
			n = save.stats[name] + quantity
			switch name
				when 'energy', 'health', 'happiness'
					n = 100 if n > 100
			save.stats[name] = n
			
		for name, quantity of @inventory
			n = (save.inventory[name] || 0) + quantity
			if n > 0
				save.inventory[name] = n
			else
				delete save.inventory[name]
	
	flatten: ->
		obj = {}
		if @clock
			obj['clock'] = @clock
		for name, quantity of @stats
			obj[name] = quantity
		for name, quantity of @inventory
			obj[name] = quantity
		obj


clock =
	days: [
		'monday'
		'tuesday'
		'wednesday'
		'thursday'
		'friday'
		'saturday'
		'sunday'
	]
	minute: ->
		Math.floor(save.clock % 60)
	hour: ->
		save.clock // 60 % 24
	day: ->
		save.clock // (60*24) % 7
	week: ->
		save.clock // (60*24*7) + 1
	toString: ->
		minuteString = ('0' + clock.minute()).substr(-2, 2)
		"week #{clock.week()} #{clock.days[clock.day()]} #{clock.hour()}:#{minuteString}"

say = (msg) ->
	gui.say(msg)

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

has = (itemName) ->
	save.inventory[itemName]?
