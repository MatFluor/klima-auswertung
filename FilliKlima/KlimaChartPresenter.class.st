Class {
	#name : 'KlimaChartPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'chart'
	],
	#category : 'FilliKlima-Spec',
	#package : 'FilliKlima',
	#tag : 'Spec'
}

{ #category : 'layout' }
KlimaChartPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
]

{ #category : 'initialization' }
KlimaChartPresenter >> initialize [

	super initialize.
]

{ #category : 'initialization' }
KlimaChartPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Link+Filli Klimadatenauswertung - Chart';
		initialExtent: 800 @ 400;
		centered
]
