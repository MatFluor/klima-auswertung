Class {
	#name : 'KlimaMainPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'chosenFile',
		'statsPresenter',
		'toolBar'
	],
	#category : 'FilliKlima-Spec',
	#package : 'FilliKlima',
	#tag : 'Spec'
}

{ #category : 'initialization' }
KlimaMainPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
]

{ #category : 'initialization' }
KlimaMainPresenter >> initialize [

	super initialize.
	self application: KlimaApp new.
]

{ #category : 'initialization' }
KlimaMainPresenter >> initializePresenters [

	self initializeToolBar.
]

{ #category : 'accessing' }
KlimaMainPresenter >> initializeToolBar [

	toolBar := self newToolbar
		           addItemRight: (self newToolbarButton
				            icon: (self iconNamed: #smallQuit);
				            label: 'Quit';
				            action: [
					            self defer: [ self application closeAllWindows. Smalltalk snapshot: false andQuit: true ] ]);
		           addItemLeft: (self newToolbarButton
				            icon: (self iconNamed: #open);
				            label: 'Testo CSV';
				            action: [
						            self defer: [
									            chosenFile := StOpenFilePresenter new openModal
										                          first.
									            KlimaEntries readFromFile: chosenFile.
									            self layout add:
											            (KlimaStatsPresenter newApplication:
													             self application) ] ]);
		           addItemLeft: (self newToolbarButton
				            icon: (self iconNamed: #open);
				            label: 'Infactory CSV';
				            action: [
						            self defer: [
									            chosenFile := StOpenFilePresenter new openModal
										                          first.
									            KlimaEntries readFromInfactoryFile: chosenFile.
									            self layout add:
											            (KlimaStatsPresenter newApplication:
													             self application) ] ])
]

{ #category : 'accessing' }
KlimaMainPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Link+Filli Klimadatenauswertung';
		toolbar: toolBar;
		withoutDecorations 
]
