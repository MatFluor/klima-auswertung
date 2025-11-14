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
		'entries',
		'default'
	],
	#category : 'FilliKlima-Core',
	#package : 'FilliKlima',
	#tag : 'Core'
}

{ #category : 'accessing' }
KlimaEntries class >> default [
	^ default ifNil: [ default := self basicNew ].
]

{ #category : 'accessing' }
KlimaEntries class >> entries [
	^ entries
]

{ #category : 'api' }
KlimaEntries class >> getDay: aDate [ 
	^ entries detect: [ :e | e date = aDate ]
]

{ #category : 'api' }
KlimaEntries class >> getMaxHumDay [

	^ entries inject: entries first into: [ :result :each |
			  result maxHum > each maxHum
				  ifTrue: [ result ]
				  ifFalse: [ each ] ]
]

{ #category : 'api' }
KlimaEntries class >> getMaxSpanHumDay [

	^ entries inject: entries first into: [ :result :each |
			  result spanHum > each spanHum
				  ifTrue: [ result ]
				  ifFalse: [ each ] ]
]

{ #category : 'api' }
KlimaEntries class >> getMaxSpanTempDay [

	^ entries inject: entries first into: [ :result :each |
			  result spanTemp > each spanTemp
				  ifTrue: [ result ]
				  ifFalse: [ each ] ]
]

{ #category : 'api' }
KlimaEntries class >> getMaxTempDay [

	^  entries
		  inject: entries first
		  into: [ :result :each |
				  result maxTemp > each maxTemp
					  ifTrue: [ result ]
					  ifFalse: [ each ] ]
]

{ #category : 'api' }
KlimaEntries class >> getMinHumDay [

	^ entries inject: entries first into: [ :result :each |
			  result minHum < each minHum
				  ifTrue: [ result ]
				  ifFalse: [ each ] ]
]

{ #category : 'api' }
KlimaEntries class >> getMinTempDay [

	^ entries inject: entries first into: [ :result :each |
			  result minTemp < each minTemp
				  ifTrue: [ result ]
				  ifFalse: [ each ] ]
]

{ #category : 'plots' }
KlimaEntries class >> plotMinMaxHum [

	| b c lineplot lineplot2 data dates |
	data := entries.
	dates := data collect: [ :e | e date julianDayNumber ].
	c := RSCompositeChart new.
	c extent: 800 @ 400.
	lineplot2 := (RSLinePlot new
		              x: dates
		              y: (data collect: [ :e | e maxHum ])) color:
		             Color blue.
	lineplot := (RSLinePlot new
		             x: dates
		             y: (data collect: [ :e | e minHum ])) color:
		            Color darkGray.
	c add: lineplot.
	c add: lineplot2.
	c horizontalTick numberOfTicks: 15.
	c verticalTick numberOfTicks: 6.
	c horizontalTick useDiagonalLabel.
	c horizontalTick labelConversion: [ :l |
		(Date julianDayNumber: l) printFormat: #( 1 2 3 $. 1 1 2 ) ].
	c xlabel: 'Datum'.
	c ylabel: 'Feuchtigkeit (%)'.
	c title: 'Minimum / Maximum täglicher Durchschnitt'.

	b := RSLegend new.
	b container: c canvas.
	b legendDo: [ :shape |
			shape
				withBorder;
				padding: 10;
				scaleBy: 0.75 ].
	b text: 'Maximum' withBoxColor: Color blue.
	b text: 'Minimum' withBoxColor: Color darkGray.
	b location
		right;
		middle;
		offset: 810 @ -368.
	b build.
	^ c asPresenter
]

{ #category : 'plots' }
KlimaEntries class >> plotMinMaxHumByMonth: aMonthIndex andYear: aYear [

	| b c lineplot lineplot2 data dates |
	data := entries select: [ :e |
		        e date monthIndex = aMonthIndex and: e date year = aYear ].
	dates := data collect: [ :e | e date julianDayNumber ].
	c := RSCompositeChart new.
	c extent: 800 @ 400.
	lineplot := (RSLinePlot new
		             x: dates
		             y: (data collect: [ :e | e maxHum ])) color: Color blue.
	lineplot2 := (RSLinePlot new
		              x: dates
		              y: (data collect: [ :e | e minHum ])) color:
		             Color purple.
	c add: lineplot.
	c add: lineplot2.
	c horizontalTick numberOfTicks: 15.
	c verticalTick numberOfTicks: 6.
	c horizontalTick useDiagonalLabel.
	c horizontalTick labelConversion: [ :l |
		(Date julianDayNumber: l) printFormat: #( 1 2 3 $. 1 1 2 ) ].
	c xlabel: 'Datum'.
	c ylabel: 'Feuchtigkeit (%)'.
	c title: 'Minimum / Maximum täglicher Durchschnitt, '
		, data first date germanMonthName , ' '
		, data first date year printString.

	b := RSLegend new.
	b container: c canvas.
	b legendDo: [ :shape |
			shape
				withBorder;
				padding: 10;
				scaleBy: 0.75 ].
	b text: 'Maximum' withBoxColor: Color blue.
	b text: 'Minimum' withBoxColor: Color purple.
	b location
		right;
		middle;
		offset: 810 @ -368.
	b build.
	^ c asPresenter
]

{ #category : 'plots' }
KlimaEntries class >> plotMinMaxTemp [

	| b c lineplot lineplot2 lineplot3 data dates |
	data := entries.
	dates := data collect: [ :e | e date julianDayNumber ].
	c := RSCompositeChart new.
	c extent: 800 @ 400.
	lineplot := (RSLinePlot new
		             x: dates
		             y: (data collect: [ :e | e maxTemp ])) color: Color red.
	lineplot2 := (RSLinePlot new
		              x: dates
		              y: (data collect: [ :e | e minTemp ])) color:
		             Color purple.
	lineplot3 := (RSLinePlot new
		              x: dates
		              y: (data collect: [ :e | e getAverageTaupunkt ]))
		             color: Color blue.
	c add: lineplot.
	c add: lineplot2.
	c add: lineplot3.
	c horizontalTick numberOfTicks: 15.
	c verticalTick numberOfTicks: 6.
	c horizontalTick useDiagonalLabel.
	c horizontalTick labelConversion: [ :l |
		(Date julianDayNumber: l) printFormat: #( 1 2 3 $. 1 1 2 ) ].
	c xlabel: 'Datum'.
	c ylabel: 'Temperatur (°C)'.
	c title: 'Minimum / Maximum täglicher Durchschnitt'.

	b := RSLegend new.
	b container: c canvas.
	b legendDo: [ :shape |
			shape
				withBorder;
				padding: 10;
				scaleBy: 0.75 ].
	b text: 'Maximum' withBoxColor: Color red.
	b text: 'Minimum' withBoxColor: Color purple.
	b text: 'Taupunkt' withBoxColor: Color blue.
	b location
		right;
		middle;
		offset: 810 @ -368.
	b build.
	^ c asPresenter
]

{ #category : 'plots' }
KlimaEntries class >> plotMinMaxTempByMonth: aMonthIndex andYear: aYear [

	| b c lineplot lineplot2 lineplot3 data dates |
	data := entries select: [ :e |
		        e date monthIndex = aMonthIndex and: e date year = aYear ].
	dates := data collect: [ :e | e date julianDayNumber ].
	c := RSCompositeChart new.
	c extent: 800 @ 400.
	lineplot := (RSLinePlot new
		             x: dates
		             y: (data collect: [ :e | e maxTemp ])) color: Color red.
	lineplot2 := (RSLinePlot new
		              x: dates
		              y: (data collect: [ :e | e minTemp ])) color:
		             Color purple.
	lineplot3 := (RSLinePlot new
		              x: dates
		              y: (data collect: [ :e | e getAverageTaupunkt ]))
		             color: Color blue.
	c add: lineplot.
	c add: lineplot2.
	c add: lineplot3.
	c horizontalTick numberOfTicks: 15.
	c verticalTick numberOfTicks: 6.
	c horizontalTick useDiagonalLabel.
	c horizontalTick labelConversion: [ :l |
		(Date julianDayNumber: l) printFormat: #( 1 2 3 $. 1 1 2 ) ].
	c xlabel: 'Datum'.
	c ylabel: 'Temperatur (°C)'.
	c title: 'Minimum / Maximum täglicher Durchschnitt, '
		, data first date germanMonthName , ' '
		, data first date year printString.

	b := RSLegend new.
	b container: c canvas.
	b legendDo: [ :shape |
			shape
				withBorder;
				padding: 10;
				scaleBy: 0.75 ].
	b text: 'Maximum' withBoxColor: Color red.
	b text: 'Minimum' withBoxColor: Color purple.
	b text: 'Taupunkt' withBoxColor: Color blue.
	b location
		right;
		middle;
		offset: 810 @ -368.
	b build.
	^ c asPresenter
]

{ #category : 'instance creation' }
KlimaEntries class >> readFrom: aCsv [

	self readFromFile: aCsv asFileReference.
]

{ #category : 'instance creation' }
KlimaEntries class >> readFromFile: aCsvFile [

	| values newDay |
	self reset.
	values := (NeoCSVReader on: aCsvFile readStream)
		          separator: $;;
		          skipHeader;
		          addIntegerField;
		          addField;
		          addFloatField;
		          addFloatField;
		          upToEnd.

	values
		do: [ :v |
			| vDate |
				vDate := Date
					         readFrom: ((v at: 2) splitOn: ' ') first
					         pattern: 'dd.mm.yyyy'.
				entries
					detect: [ :e | e date = vDate ]
					ifFound: [ :d |
						  d times add: ((v at: 2) splitOn: ' ') second.
							d temperatures add: (v at: 4).
							d humidities add: (v at: 3) ]
					ifNone: [
							newDay := Day new date: vDate.
							newDay temperatures add: (v at: 4).
							newDay humidities add: (v at: 3).
							entries add: newDay ] ]
		displayingProgress: [ 'Lese CSV ein, bitte warten...' ]
]

{ #category : 'instance creation' }
KlimaEntries class >> readFromInfactoryFile: aCsvFile [

	| values newDay |
	self reset.
	values := (NeoCSVReader on: aCsvFile readStream)
		          separator: Character tab;
		          skipHeader;
		          addIntegerField;
		          addField;
		          addFloatField;
		          addFloatField;
		          upToEnd.

	values
		do: [ :v |
			| vDate |
				vDate := Date
					         readFrom: ((v at: 2) splitOn: ' ') first
					         pattern: 'yyyy-mm-dd'.
				entries
					detect: [ :e | e date = vDate ]
					ifFound: [ :d |
							d times add: ((v at: 2) splitOn: ' ') second.
							d temperatures add: (v at: 3).
							d humidities add: (v at: 4) ]
					ifNone: [
							newDay := Day new date: vDate.
							newDay temperatures add: (v at: 3).
							newDay humidities add: (v at: 4).
							entries add: newDay ] ]
		displayingProgress: [ 'Lese CSV ein, bitte warten...' ]
]

{ #category : 'instance creation' }
KlimaEntries class >> reset [
	entries := OrderedCollection new.
]

{ #category : 'accessing' }
KlimaEntries >> default [
	^ self class default
]
