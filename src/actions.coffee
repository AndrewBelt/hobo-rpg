# defaultAction:
# 	transaction: -> new Transaction()
# 	run: -> # Do nothing
# 	visible: -> true


places =
	alley:
		description: -> "behind a warehouse downtown"
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'alley'
		actions:
			sleep:
				transaction: -> new Transaction(hour: 8, energy: 100)
			beg:
				transaction: -> new Transaction(minute: 30)
				run: ->
					if Math.random() > 0.5
						dollars = Math.floor(Math.random()*5 + 1)
						new Transaction(dollar: dollars).commit()
						say "a man throws you $#{dollars}."
					else
						say choose [
							"a group of teenagers walk past you but you fail to get their attention."
							"the street is empty."
						]
	'gas station':
		description: -> "at the corner of a busy intersection. open 7-11"
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'gas station'
		actions:
			'apply for a job':
				visible: -> 7 <= clock.hour() <= 22 and 'gas station' not in save.jobs
				transaction: -> new Transaction(minute: 30)
				run: ->
					if save.skills.intellegence >= 10
						say "the manager looks you over and gives you a job as a cashier."
						save.jobs.push('gas station')
					else
						say "you can't figure out how to make change for a $5 bill during your interview."
			work:
				visible: -> 7 <= clock.hour() <= 22 and 'gas station' in save.jobs
				transaction: -> new Transaction(dollar: 7, hour: 1)
				run: ->
					say("work sucks, but someone has to do it.")
		store:
			visible: -> 7 <= clock.hour() <= 22
			buy:
				smokes: 5
				'chocolate bar': 2
	'high school':
		description: ->
			if 6 <= clock.hour() <= 14 and clock.day() < 5
				"aren't you a bit too old for this?"
			else
				"nobody's here."
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'high school'
		actions:
			'attend class':
				visible: -> 6 <= clock.hour() <= 14 and clock.day() < 5
				transaction: -> new Transaction(intellegence: 1, hour: 1)
				run: ->
					say choose [
						"the lunches are horrible"
						"you study hard"
					]
	'library':
		description: -> "a great place to read books"
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'library'
		actions:
			'read book':
				transaction: -> new Transaction(intellegence: 1, hour: 3)
			'browse internet':
				transaction: -> new Transaction(happiness: 10, hour: 1)
	church:
		description: -> "get saved here."
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'church'
		actions:
			beg:
				transaction: -> new Transaction(minute: 30)
				run: ->
					if Math.random() > 0.5
						dollars = Math.floor(Math.random()*20 + 1)
						new Transaction(dollar: dollars).commit()
						say choose [
							"a pastor gives you $#{dollars} after attempting to save you."
							"a woman searches her purse and gives you $#{dollars}."
						]
					else
						say choose [
							"nobody is around."
							"a man scolds you for trespassing."
							"a young man invites you to a bible study, but you decline."
						]
			'attend service':
				visible: -> clock.day() == 6 and 8 <= clock.hour() <= 11
				transaction: -> new Transaction(happiness: 10, intellegence: -1, hour: 2)
	mall:
		description: -> "where teens and parents go to spend their hard-earned money."
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'mall'
		actions: {}
		store:
			buy:
				'chinese takeout': 4
				'slice of pizza': 6
				skateboard: 100
				suit: 200
	'parking garage':
		description: -> "it's peaceful here during the nights."
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'parking garage'
		actions:
			sleep:
				transaction: -> new Transaction(hour: 7, energy: 100)
	college:
		description: -> "where you go to learn about debt."
		travel:
			visible: -> save.skills.intellegence >= 10
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'college'
		actions:
			'attend class':
				transaction: -> new Transaction(intellegence: 5, dollar: 20, hour: 1)
			'study':
				transaction: -> new Transaction(intellegence: 2, hour: 1)
	hospital:
		description: -> ""
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'hospital'
		actions:
			'visit nurse':
				transaction: -> new Transaction(hour: 1, health: 20, dollar: -40)
			'visit doctor':
				transaction: -> new Transaction(hour: 3, health: 50, dollar: -100)
	bank:
		description: -> "we strive to have your money\u2122. lobby open 8-5. atm open 24/7."
		travel:
			transaction: -> new Transaction(minute: 15)
			run: -> save.place = 'bank'
		actions:
			'apply for job':
				visible: -> 8 <= clock.hour() <= 16 and 'bank' not in save.jobs
				transaction: -> new Transaction(minute: 30)
				run: ->
					if save.skills.intellegence < 1000
						say "the interviewer was disappointed. come back when you're smarter."
					else if !has 'suit'
						say "you pass the interview, but the boss doesn't want someone without a suit."
					else
						say "you got the job."
						save.jobs.push('bank')
			work:
				visible: -> 8 <= clock.hour() <= 16 and 'bank' in save.jobs
				transaction: -> new Transaction(hour: 1, dollar: 30)
			'check balance':
				run: ->
					balance = save.balance || 0
					say "your balance is $#{balance}."
			deposit:
				run: ->
					amount = parseInt(window.prompt('amount to deposit', save.inventory.dollar || 0))
					if amount and amount > 0
						transaction = new Transaction(dollar: -amount)
						if transaction.error()
							say "you don't have enough dollars"
						else
							transaction.commit()
							save.balance = (save.balance || 0) + amount
							say "deposited $#{amount}"
			withdraw:
				run: ->
					amount = parseInt(window.prompt('amount to withdraw', save.balance || 0))
					if amount and amount > 0
						balance = (save.balance || 0) - amount
						if balance >= 0
							save.balance = balance
							new Transaction(dollar: amount).commit()
							say "withdrew $#{amount}"
						else
							say "you don't have that much in the bank."

# Items that have actions go here
items =
	'chocolate bar':
		transaction: ->
			new Transaction('chocolate bar': -1, fullness: 10, health: -1, happiness: 10)
	'chinese takeout':
		transaction: ->
			new Transaction('chinese takeout': -1, fullness: 30)
	'slice of pizza':
		transaction: ->
			new Transaction('slice of pizza': -1, fullness: 20, health: -1)
	coffee:
		transaction: ->
			new Transaction('coffee': -1, energy: 10)
	'energy drink':
		transaction: ->
			new Transaction('energy drink': -1, energy: 20, health: -1)
	smokes:
		transaction: ->
			new Transaction(smokes: -1, health: -3, happiness: 10)
