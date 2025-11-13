Extension { #name : 'Month' }

{ #category : '*FilliKlima' }
Month >> monat [

	^ String streamContents: [ :aStream |
		  aStream nextPutAll: (self asDate germanMonthName); << ' '; << self year printString ]
]
