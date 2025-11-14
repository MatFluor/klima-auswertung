Class {
	#name : 'KlimaApp',
	#superclass : 'SpApplication',
	#category : 'FilliKlima-Spec',
	#package : 'FilliKlima',
	#tag : 'Spec'
}

{ #category : 'running' }
KlimaApp >> start [
	self currentWorld worldState worldRenderer windowTitle: 'Link+Filli Klimalogger Auswertung'.
	(self new: KlimaMainPresenter) open window maximize
]
