Class {
	#name : 'KlimaApp',
	#superclass : 'SpApplication',
	#category : 'FilliKlima-Spec',
	#package : 'FilliKlima',
	#tag : 'Spec'
}

{ #category : 'running' }
KlimaApp >> start [

	((self new: KlimaMainPresenter) open) window maximize
]
