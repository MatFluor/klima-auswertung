Class {
	#name : 'BaselineOfFilliKlima',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFilliKlima',
	#package : 'BaselineOfFilliKlima'
}

{ #category : 'baselines' }
BaselineOfFilliKlima >> baseline: spec [
    <baseline>
    spec
    for: #common
    do: [ 
        self defineDependencies: spec.
        self definePackages: spec.
        self defineGroups: spec ]
]

{ #category : 'baselines' }
BaselineOfFilliKlima >> defineDependencies: spec [

	spec
		baseline: 'NeoCSV'
		with: [ spec repository: 'github://svenvc/NeoCSV/repository' ]
]

{ #category : 'baselines' }
BaselineOfFilliKlima >> defineGroups: spec [
    
    spec group: 'core'
        with: #( 'FilliKlima' )
]

{ #category : 'baselines' }
BaselineOfFilliKlima >> definePackages: spec [
    spec
        package: 'FilliKlima'
]
