"
I am a Day in the dataset.

I carry the date as ISO, all temperatures and all humidity value in OrderedCollections.

I have a plethora of helper methods to access various statistics of a day:

**Averages**
- avgHum
- avgTemp

**Dew Point**
- getTaupunkt

**Maximum and Minimum**
- maxTemp
- maxHum
- minTemp
- minHum
- spanTemp (max - min)
- spanHum (max - min)
- spanTempString (nicer representation)
- spanHumString (nicer representation)
"
Class {
	#name : 'Day',
	#superclass : 'Object',
	#instVars : [
		'date',
		'times',
		'temperatures',
		'humidities'
	],
	#category : 'FilliKlima-Core',
	#package : 'FilliKlima',
	#tag : 'Core'
}

{ #category : 'statistics' }
Day >> avgHum [

	^ humidities average
]

{ #category : 'statistics' }
Day >> avgTemp [
	^ temperatures average
]

{ #category : 'accessing' }
Day >> date [

	^ date
]

{ #category : 'accessing' }
Day >> date: anObject [

	date := anObject
]

{ #category : 'statistics' }
Day >> getAverageTaupunkt [
	"Temperatur über 0 ° C: k2=17.62, k3=243.12
Temperatur 0 ° C oder darunter: k2=22.46, k3=272.62
Temperatur t, Luftfeuchtigkeit l
Taupunkt = k3*((k2*t)/(k3+t)+ln(l/100))/((k2*k3)/(k3+t)-ln(l/100))"

	| k2 k3 tp l t |
	k2 := 17.62.
	k3 := 243.12.
	l := humidities average.
	t := temperatures average.
			tp := k3 * (k2 * t / (k3 + t) + (l / 100) ln)
			      / (k2 * k3 / (k3 + t) - (l / 100) ln).
			
	^ tp
]

{ #category : 'statistics' }
Day >> getTaupunkte [
"Temperatur über 0 ° C: k2=17.62, k3=243.12
Temperatur 0 ° C oder darunter: k2=22.46, k3=272.62
Temperatur t, Luftfeuchtigkeit l
Taupunkt = k3*((k2*t)/(k3+t)+ln(l/100))/((k2*k3)/(k3+t)-ln(l/100))"
| k2 k3 totaltp |
	k2 := 17.62.
	k3 := 243.12.
	totaltp := OrderedCollection new.
	temperatures doWithIndex: [ :t :index | | tp l |
	l := humidities at: index.
	tp := k3*((k2*t)/(k3+t)+(l/100) ln)/((k2*k3)/(k3+t)-(l/100) ln).
	totaltp add: tp].
^ totaltp
]

{ #category : 'accessing' }
Day >> humidities [

	^ humidities
]

{ #category : 'accessing' }
Day >> humidities: anObject [

	humidities := anObject
]

{ #category : 'initialization' }
Day >> initialize [
	temperatures := OrderedCollection new.
	humidities := OrderedCollection new.
	times := OrderedCollection new.
]

{ #category : 'statistics' }
Day >> maxHum [

	^ humidities max
]

{ #category : 'statistics' }
Day >> maxTemp [

	^ temperatures max
]

{ #category : 'statistics' }
Day >> minHum [

	^ humidities min
]

{ #category : 'statistics' }
Day >> minTemp [

	^ temperatures min
]

{ #category : 'plots' }
Day >> plotHum [

	| b c lineplot |
	c := RSCompositeChart new.
	c extent: 800 @ 400.
	lineplot := RSLinePlot new.
	lineplot y: self humidities.
	lineplot color: Color blue.
	c horizontalTick numberOfTicks: 24.
	c horizontalTick labelConversion: [ :l |
		self times at: l + 1 ifAbsent: [ self times last ] ].
	c horizontalTick useDiagonalLabel.
	c xlabel: 'Uhrzeit'.
	c ylabel: 'Rel. Feuchtigkeit'.
	c title:(self date printFormat: #(1 2 3 $. 1 1 2)).
	c add: lineplot.
	b := RSLegend new.
	b container: c canvas.
	b legendDo: [ :shape |
			shape
				withBorder;
				padding: 10;
				scaleBy: 0.75 ].
	b text: 'Feuchtigkeit' withBoxColor: Color blue.
	b location
		right;
		middle;
		offset: 810 @ -368.
	b build.
	^ c asPresenter
]

{ #category : 'plots' }
Day >> plotTemp [

	| b c lineplot b |
	c := RSCompositeChart new.
	c extent: 800 @ 400.
	lineplot := RSLinePlot new.
	lineplot y: self temperatures.
	lineplot color: Color red.
	c horizontalTick numberOfTicks: 24.
	c horizontalTick labelConversion: [ :l |
		self times at: l + 1 ifAbsent: [ self times last ] ].
	c horizontalTick useDiagonalLabel.
	c xlabel: 'Uhrzeit'.
	c ylabel: 'Temperatur'.
	c title: (self date printFormat: #(1 2 3 $. 1 1 2)).
	c add: lineplot.

	c add: ((RSLinePlot y: self getTaupunkte) color: Color darkGray).

	b := RSLegend new.
	b container: c canvas.
	b legendDo: [ :shape |
			shape
				withBorder;
				padding: 10;
				scaleBy: 0.75 ].
	b text: 'Temperatur' withBoxColor: Color red.
	b text: 'Taupunkt' withBoxColor: Color darkGray.
	b location
		right;
		middle;
		offset: 810 @ -368.
	b build.
	^ c asPresenter
]

{ #category : 'printing' }
Day >> printOn: aStream [

	aStream nextPutAll: (date printFormat: #(1 2 3 $. 1 1 2))
]

{ #category : 'statistics' }
Day >> spanHum [

	^ humidities max - humidities min
]

{ #category : 'statistics' }
Day >> spanHumString [

	^ 'Min: ' , humidities min printString , '/Max: '
	  , humidities max printString
]

{ #category : 'statistics' }
Day >> spanTemp [

	^ temperatures max - temperatures min
]

{ #category : 'statistics' }
Day >> spanTempString [

	^ 'Min: ' , temperatures min printString , '/Max: '
	  , temperatures max printString
]

{ #category : 'accessing' }
Day >> temperatures [

	^ temperatures
]

{ #category : 'accessing' }
Day >> temperatures: anObject [

	temperatures := anObject
]

{ #category : 'plots' }
Day >> times [

	^ times
]
