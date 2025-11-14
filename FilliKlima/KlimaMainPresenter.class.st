Class {
	#name : 'KlimaMainPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'fileEntryField',
		'loadButton',
		'loadInfactoryButton',
		'chosenFile',
		'statsPresenter'
	],
	#category : 'FilliKlima-Spec',
	#package : 'FilliKlima',
	#tag : 'Spec'
}

{ #category : 'initialization' }
KlimaMainPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: loadButton expand: false;
		add: loadInfactoryButton expand: false;
		  yourself
]

{ #category : 'initialization' }
KlimaMainPresenter >> initialize [

	super initialize.
	self application: KlimaApp new.
]

{ #category : 'initialization' }
KlimaMainPresenter >> initializePresenters [

	fileEntryField := self newTextInput text: (chosenFile ifNil: [ '' ]).
	loadButton := self newButton
		              icon: (self iconNamed: #open);
		              label: 'Testo-CSV Laden';
		              action: [
				              chosenFile := StOpenFilePresenter new openModal
					                            first.
				              KlimaEntries readFromFile: chosenFile.
				              self layout add:
						              (KlimaStatsPresenter newApplication:
								               self application). ].
	loadInfactoryButton := self newButton
		              icon: (self iconNamed: #open);
		              label: 'Infactory-CSV Laden';
		              action: [
				              chosenFile := StOpenFilePresenter new openModal
					                            first.
				              KlimaEntries readFromInfactoryFile: chosenFile.
				              self layout add:
						              (KlimaStatsPresenter newApplication:
								               self application). ]
]

{ #category : 'accessing' }
KlimaMainPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Link+Filli Klimadatenauswertung';
		initialExtent: 800 @ 400;
		centered
]
