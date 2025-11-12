"
I am the main class, holding all entries of the logger.

I carry some convenience method to get statistics for the whole dataset.
**Only use my `class`, without creating an instance**

**Misc**
- reset (empty the dataset)
- readFrom: aCSVFile (String of the CSV file to read in)

**Maximum and Minimum**
- getMaxHumDay (returns the day with the highest Humidity)
- getMaxTempDay (returns the day with the highest Temperature)
- getMinHumDay
- getMinTempDay
- getMaxSpanHumDay (returns the day with the highest humidity difference)
- getMaxSpanTempDay (returns the day with the highest temperature difference)

**Plotting**
- plotMinMaxHum (using daily average)
- plotMinMaxTemp (using daily average)
"
Class {
	#name : 'KlimaEntries',
	#superclass : 'Object',
	#classInstVars : [
		'entries'
	],
	#category : 'FilliKlima-Core',
	#package : 'FilliKlima',
	#tag : 'Core'
}

{ #category : 'accessing' }
KlimaEntries class >> entries [
	^ entries
]

{ #category : 'as yet unclassified' }
KlimaEntries class >> getDay: aDate [ 
	^ entries detect: [ :e | e date = aDate ]
]

{ #category : 'as yet unclassified' }
KlimaEntries class >> getMaxHumDay [

	^ entries inject: entries first into: [ :result :each |
			  result maxHum > each maxHum
				  ifTrue: [ result ]
				  ifFalse: [ each ] ]
]

{ #category : 'as yet unclassified' }
KlimaEntries class >> getMaxSpanHumDay [

	^ entries inject: entries first into: [ :result :each |
			  result spanHum > each spanHum
				  ifTrue: [ result ]
				  ifFalse: [ each ] ]
]

{ #category : 'as yet unclassified' }
KlimaEntries class >> getMaxSpanTempDay [

	^ entries inject: entries first into: [ :result :each |
			  result spanTemp > each spanTemp
				  ifTrue: [ result ]
				  ifFalse: [ each ] ]
]

{ #category : 'as yet unclassified' }
KlimaEntries class >> getMaxTempDay [

	^  entries
		  inject: entries first
		  into: [ :result :each |
				  result maxTemp > each maxTemp
					  ifTrue: [ result ]
					  ifFalse: [ each ] ]
]

{ #category : 'as yet unclassified' }
KlimaEntries class >> getMinHumDay [

	^ entries inject: entries first into: [ :result :each |
			  result minHum < each minHum
				  ifTrue: [ result ]
				  ifFalse: [ each ] ]
]

{ #category : 'as yet unclassified' }
KlimaEntries class >> getMinTempDay [

	^ entries inject: entries first into: [ :result :each |
			  result minTemp < each minTemp
				  ifTrue: [ result ]
				  ifFalse: [ each ] ]
]

{ #category : 'as yet unclassified' }
KlimaEntries class >> plotMinMaxHum [

	| c lineplot lineplot2 |
	c := RSCompositeChart new.
	c extent: 800 @ 400.
	lineplot2 := (RSLinePlot new y: (entries collect: [ :e | e maxHum ]))
		             color: Color blue.
	lineplot := (RSLinePlot new y: (entries collect: [ :e | e minHum ]))
		            color: Color darkGray.
	c add: lineplot.
	c add: lineplot2.
	c horizontalTick numberOfTicks: 15.
	c verticalTick numberOfTicks: 6.
	c horizontalTick useDiagonalLabel.
	c horizontalTick labelConversion: [ :l |
		entries at: l + 1 ifAbsent: [ entries last ] ].
	c xlabel: 'Datum'.
	c ylabel: 'Rel. Feuchtigkeit'.
	c title: 'Minimum / Maximum täglicher Durchschnitt'.
	c open
]

{ #category : 'as yet unclassified' }
KlimaEntries class >> plotMinMaxTemp [

	| c lineplot lineplot2 |
	c := RSCompositeChart new.
	c extent: 800 @ 400.
	lineplot2 := (RSLinePlot new y: (entries collect: [ :e | e maxTemp ]))
		             color: Color red.
	lineplot := (RSLinePlot new y: (entries collect: [ :e | e minTemp ]))
		            color: Color darkGray.
	c add: lineplot.
	c add: lineplot2.
	c horizontalTick numberOfTicks: 15.
	c verticalTick numberOfTicks: 6.
	c horizontalTick useDiagonalLabel.
	c horizontalTick labelConversion: [ :l |
		entries at: l + 1 ifAbsent: [ entries last ] ].
	c xlabel: 'Datum'.
	c ylabel: 'Temperatur'.
	c title: 'Minimum / Maximum täglicher Durchschnitt'.
	c open
]

{ #category : 'instance creation' }
KlimaEntries class >> readFrom: aCsv [

	| values newDay |
	values := (NeoCSVReader on:
			           'Bericht_Tabelle_111125.csv' asFileReference readStream)
		          separator: $;;
		          skipHeader;
		          addIntegerField;
		          addField;
		          addFloatField;
		          addFloatField;
		          upToEnd.

	values do: [ :v |
			           entries
				           detect: [ :e | e date = (((v at: 2) splitOn: ' ') first) ]
				           ifFound: [ :d |
						           d temperatures add: (v at: 4).
						           d humidities add: (v at: 3) ]
				           ifNone: [
						           newDay := Day new date: (((v at: 2) splitOn: ' ') first).
						           newDay temperatures add: (v at: 4).
						           newDay humidities add: (v at: 3).
						           entries add: newDay ] ] displayingProgress: [ 'Doing it' ]
]

{ #category : 'instance creation' }
KlimaEntries class >> reset [
	entries := OrderedCollection new.
]
