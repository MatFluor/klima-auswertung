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

	| c lineplot |
	c := RSCompositeChart new.
	c extent: 800 @ 400.
	lineplot := RSLinePlot new.
	lineplot y: self humidities.
	lineplot color: Color blue.
	c horizontalTick numberOfTicks: 24.
	c horizontalTick labelConversion: [ :l | self times at: l + 1 ].
	c horizontalTick useDiagonalLabel.
	c xlabel: 'Uhrzeit'.
	c ylabel: 'Rel. Feuchtigkeit'.
	c title: self date.
	c add: lineplot.
	c open
]

{ #category : 'plots' }
Day >> plotTemp [

	| c lineplot lineplot2 b layout |
	c := RSCompositeChart new.
	c extent: 800 @ 400.
	lineplot := RSLinePlot new.
	lineplot y: self temperatures.
	lineplot color: Color red.
	c horizontalTick numberOfTicks: 24.
	c horizontalTick labelConversion: [ :l | self times at: l + 1 ].
	c horizontalTick useDiagonalLabel.
	c xlabel: 'Uhrzeit'.
	c ylabel: 'Temperatur'.
	c title: self date.
	c add: lineplot.
	lineplot2 := RSLinePlot new.
	lineplot2 y: self humidities.
	lineplot2 color: Color blue.
	c add: lineplot2.

	c add: ((RSLinePlot y: self getTaupunkte) color: Color darkGray).

	b := RSLegend new.
	b container: c canvas.
	b text: 'Temperatur' withBoxColor: Color red.
	b text: 'Taupunkt' withBoxColor: Color darkGray.
	b layout horizontal gapSize: 30.
	b build.
	c open
]

{ #category : 'printing' }
Day >> printOn: aStream [
	aStream nextPutAll: date
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

	^ { '00:03'. '00:03'. '00:13'. '00:23'. '00:33'. '00:43'. '00:53'.
	  '01:03'. '01:13'. '01:23'. '01:33'. '01:43'. '01:53'. '02:03'.
	  '02:13'. '02:23'. '02:33'. '02:43'. '02:53'. '03:03'. '03:13'.
	  '03:23'. '03:33'. '03:43'. '03:53'. '04:03'. '04:13'. '04:23'.
	  '04:33'. '04:43'. '04:53'. '05:03'. '05:13'. '05:23'. '05:33'.
	  '05:43'. '05:53'. '06:03'. '06:13'. '06:23'. '06:33'. '06:43'.
	  '06:53'. '07:03'. '07:13'. '07:23'. '07:33'. '07:43'. '07:53'.
	  '08:03'. '08:13'. '08:23'. '08:33'. '08:43'. '08:53'. '09:03'.
	  '09:13'. '09:23'. '09:33'. '09:43'. '09:53'. '10:03'. '10:13'.
	  '10:23'. '10:33'. '10:43'. '10:53'. '11:03'. '11:13'. '11:23'.
	  '11:33'. '11:43'. '11:53'. '12:03'. '12:13'. '12:23'. '12:33'.
	  '12:43'. '12:53'. '13:03'. '13:13'. '13:23'. '13:33'. '13:43'.
	  '13:53'. '14:03'. '14:13'. '14:23'. '14:33'. '14:43'. '14:53'.
	  '15:03'. '15:13'. '15:23'. '15:33'. '15:43'. '15:53'. '16:03'.
	  '16:13'. '16:23'. '16:33'. '16:43'. '16:53'. '17:03'. '17:13'.
	  '17:23'. '17:33'. '17:43'. '17:53'. '18:03'. '18:13'. '18:23'.
	  '18:33'. '18:43'. '18:53'. '19:03'. '19:13'. '19:23'. '19:33'.
	  '19:43'. '19:53'. '20:03'. '20:13'. '20:23'. '20:33'. '20:43'.
	  '20:53'. '21:03'. '21:13'. '21:23'. '21:33'. '21:43'. '21:53'.
	  '22:03'. '22:13'. '22:23'. '22:33'. '22:43'. '22:53'. '23:03'.
	  '23:13'. '23:23'. '23:33'. '23:43'. '23:53'. '23:35'}
]
