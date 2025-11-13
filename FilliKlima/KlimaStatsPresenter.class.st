Class {
	#name : 'KlimaStatsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'valuesTable'
	],
	#category : 'FilliKlima-Spec',
	#package : 'FilliKlima',
	#tag : 'Spec'
}

{ #category : 'initialization' }
KlimaStatsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpFrameLayout new
				   add: valuesTable;
				   label: 'Wertetabelle');
		  add: (SpBoxLayout newLeftToRight
				   add: (self newButton
						    label: 'Jahres-Temperaturplot ansehen';
						icon: (self iconNamed: #smallWindow);
						    action: [ KlimaEntries plotMinMaxTemp ]);
				   add: (self newButton
						    label: 'Jahres-Feuchtigkeitsplot ansehen';
						icon: (self iconNamed: #smallWindow);
						    action: [ KlimaEntries plotMinMaxHum ]))
		  expand: false;
		  yourself
]

{ #category : 'as yet unclassified' }
KlimaStatsPresenter >> getValues [

	^ {
		  {
			  'Tag mit höchstem Temperaturunterschied'.
			  KlimaEntries getMaxSpanTempDay date.
			  KlimaEntries getMaxSpanTempDay spanTempString }.
		  {
			  'Tag mit höchstem Feuchtigkeitsunterschied'.
			  KlimaEntries getMaxSpanHumDay date.
			  KlimaEntries getMaxSpanHumDay spanHumString }.
		  {
			  'Tag mit höchster Temperatur'.
			  KlimaEntries getMaxTempDay date.
			  KlimaEntries getMaxTempDay temperatures max printString }.
		  {
			  'Tag mit höchster Feuchtigkeit'.
			  KlimaEntries getMaxHumDay date.
			  KlimaEntries getMaxHumDay humidities max printString }.
		  {
			  'Tag mit tiefster Temperatur'.
			  KlimaEntries getMinTempDay date.
			  KlimaEntries getMinTempDay temperatures min printString }.
		  {
			  'Tag mit tiefster Feuchtigkeit'.
			  KlimaEntries getMinHumDay date.
			  KlimaEntries getMinHumDay humidities min printString } }
]

{ #category : 'as yet unclassified' }
KlimaStatsPresenter >> initializePresenters [
	valuesTable := self tableView.
]

{ #category : 'as yet unclassified' }
KlimaStatsPresenter >> rightClickActions [

	^ SpActionGroup new
		  addActionWith: [ :item |
				  item
					  name: 'Rohdaten Inspector öffnen';
					  action: [
							  (KlimaEntries entries detect: [ :e |
									   e date = valuesTable selectedItem second ]) inspect ] ];
		  addActionWith: [ :item |
				  item
					  name: 'Temperaturplot ansehen';
					  action: [
							  (KlimaEntries entries detect: [ :e |
									   e date = valuesTable selectedItem second ]) plotTemp ] ];
						addActionWith: [ :item |
				  item
					  name: 'Feuchtigkeitsplot ansehen';
					  action: [
							  (KlimaEntries entries detect: [ :e |
									   e date = valuesTable selectedItem second ]) plotHum ] ]
]

{ #category : 'as yet unclassified' }
KlimaStatsPresenter >> tableView [

	^ SpTablePresenter new
		  addColumn:
			  ((SpStringTableColumn new title: 'Statistik') evaluated: [ :e |
					   e at: 1 ]);
		  addColumn: ((SpStringTableColumn new title: 'Datum')
				   width: 120;
				   beNotExpandable;
				   evaluated: [ :e | e at: 2 ]);
		  addColumn: ((SpStringTableColumn new title: 'Wert')
				   width: 200;
				   beNotExpandable;
				   evaluated: [ :e | e at: 3 ]);
		  actions: self rightClickActions;
		  items: self getValues
]
