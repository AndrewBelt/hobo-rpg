class Transaction
	# example usage:
	# new Transaction(minute: 30, energy: -10, dollar: 10)
	constructor: (args) ->
		@clock = 0
		@stats = {}
		@skills = {}
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
					else if save.skills.hasOwnProperty(name)
						@skills[name] = quantity
					else
						@inventory[name] = quantity
	
	# Returns the name of the thing you don't have enough of to commit this transaction
	error: ->
		for name, quantity of @inventory
			if (save.inventory[name] || 0) + quantity < 0
				return name
		null
	
	commit: ->
		if @clock > 0
			save.clock += @clock
			# Automatically increment energy once every 10 minutes
			# TODO
			# Increment when the clock crosses a 10-minute mark,
			# not simply divide the number of minutes by 10.
			if !@stats.energy?
				save.stats.energy -= @clock // 10
			if !@stats.fullness?
				save.stats.fullness -= @clock // 30
		
		for name, quantity of @stats
			save.stats[name] += quantity
		for name, quantity of @skills
			save.skills[name] += quantity
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
		for name, quantity of @skills
			obj[name] = quantity
		for name, quantity of @inventory
			obj[name] = quantity
		obj


checkStats = ->
	if save.stats.fullness <= 0
		say "you feel starved, so you run into a nearby alley. you find a family of rats, and while it isn't the most appetizing meal, you manage to choke it down."
		new Transaction(fullness: 100, health: -20, happiness: -20).commit()
	if save.stats.energy <= 0
		say "you become so tired, you pass out awaken in an alley. you have an throbbing headache and suspect you may have hit your head in the process."
		save.place = 'alley'
		new Transaction(hour: 12, energy: 100, health: -20).commit()
	if save.stats.happiness <= 0
		say "you drive yourself into depression, but the developer hasn't decided what should happen in this case. so here's 100 happiness."
		new Transaction(happiness: 100).commit()
	if save.stats.health <= 0
		say "after running out of health, you awaken in a hospital. you're healed now, but only after a hefty bill."
		save.place = 'hospital'
		new Transaction(day: 2, dollar: -200, health: 100, energy: 100, fullness: 100).commit()
	
	# Clip stats to 100 max
	for name in ['health', 'energy', 'happiness', 'fullness']
		save.stats[name] = 100 if save.stats[name] > 100

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
		hourString = clock.hour() % 12
		hourString = 12 if hourString == 0
		minuteString = ('0' + clock.minute()).substr(-2, 2)
		ampm = if clock.hour() < 12 then 'am' else 'pm'
		"week #{clock.week()} #{clock.days[clock.day()]} #{hourString}:#{minuteString} #{ampm}"

say = (msg) ->
	gui.say(msg)

choose = (arr) ->
	arr[Math.floor(Math.random() * arr.length)]

has = (itemName) ->
	save.inventory[itemName]?

clip = (val, min, max) ->
	val = min if val < min
	val = max if val > max
	val

display = (text) ->
	gui.openPanel(text)