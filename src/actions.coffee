# defaultAction:
# 	transaction: -> new Transaction()
# 	run: -> # Do nothing
# 	visible: -> true


places =
	alley:
		description: "behind a warehouse downtown"
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'alley'
		actions:
			sleep:
				transaction: -> new Transaction(energy: 50, hour: 6)
			beg:
				transaction: -> new Transaction(minute: 30)
				run: ->
					dollars = Math.floor(Math.random()*5 + 1)
					new Transaction(dollar: dollars).commit()
					say "A man throws you $#{dollars}."
	'gas station':
		description: "at the corner of a busy intersection"
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'gas station'
		actions:
			'apply for a job':
				visible: -> 'gas station' not in save.jobs
				transaction: -> new Transaction(minute: 30)
				run: ->
					if save.stats.intellegence >= 10
						say "the manager looks you over and gives you a job as a cashier."
						save.jobs.push('gas station')
					else
						say "you can't figure out how to make change for a $5 bill during your interview."
			work:
				visible: -> 'gas station' in save.jobs
				transaction: ->
					new Transaction(dollar: 7, hour: 1, energy: -10)
				run: ->
					say("work sucks, but someone has to do it.")
		store:
			cigs: 5
			'chocolate bar': 2
	'high school':
		description: "aren't you a bit too old for this?"
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'high school'
		actions:
			'attend class':
				transaction: ->
					new Transaction(intellegence: 2, hour: 6, energy: -20)
				run: ->
					say choose [
						"the lunches are horrible"
						"you study hard"
					]


# Items that have actions go here
items =
	'chocolate bar':
		transaction: ->
			new Transaction('chocolate bar': -1, energy: 10, health: -1)
