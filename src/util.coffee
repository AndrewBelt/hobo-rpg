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
		needsUpdate = []
		for name, quantity of @delta
			switch
				when save.clock.hasOwnProperty(name)
					save.clock[name] += quantity
					needsUpdate.push('clock')
				when save.stats.hasOwnProperty(name)
					save.stats[name] += quantity
					needsUpdate.push('stats')
				else
					newQuantity = (save.inventory[name] || 0) + quantity
					save.inventory[name] = newQuantity
					needsUpdate.push('inventory')
		for update in needsUpdate
			switch update
				when 'clock' then renderer.renderClock()
				when 'stats' then renderer.renderStats()
				when 'inventory' then renderer.renderInventory()


fixTime = ->
	save.clock.hour += save.clock.minute // 60
	save.clock.minute %= 60
	save.clock.day += save.clock.hour // 24
	save.clock.hour %= 24
	save.clock.week += save.clock.day // 7
	save.clock.day %= 7

pushStory = (msg) ->
	$('#story').prepend($('<p>').text(msg))
