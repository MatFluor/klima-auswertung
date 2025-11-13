Class {
	#name : 'KlimaStatsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'valuesTable',
		'monthDropdown'
	],
	#category : 'FilliKlima-Spec',
	#package : 'FilliKlima',
	#tag : 'Spec'
}

{ #category : 'initialization' }
KlimaStatsPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 10;
		  add: (SpFrameLayout new
				   add: valuesTable;
				   label: 'Wertetabelle');
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: (self newButton
						    label: 'Jahres-Temperaturplot ansehen';
						    action: [ KlimaEntries plotMinMaxTemp ]);
				   add: (self newButton
						    label: 'Jahres-Feuchtigkeitsplot ansehen';
						    action: [ KlimaEntries plotMinMaxHum ]))
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: monthDropdown;
				   add: (self newButton
						    label: 'Monats Temperaturplot ansehen';
						    action: [
								    KlimaEntries
									    plotMinMaxTempByMonth:
										    monthDropdown selectedItem monthIndex
									    andYear: monthDropdown selectedItem year ]);
				   add: (self newButton
						    label: 'Monats Feuchtigkeitsplot ansehen';
						    action: [
								    KlimaEntries
									    plotMinMaxHumByMonth:
										    monthDropdown selectedItem monthIndex
									    andYear: monthDropdown selectedItem year ]))
		  expand: false;
		  yourself
]

{ #category : 'api' }
KlimaStatsPresenter >> getValues [

	^ {
		  {
			  'Tag mit höchstem Temperaturunterschied'.
			  KlimaEntries getMaxSpanTempDay.
			  KlimaEntries getMaxSpanTempDay spanTempString }.
		  {
			  'Tag mit höchstem Feuchtigkeitsunterschied'.
			  KlimaEntries getMaxSpanHumDay.
			  KlimaEntries getMaxSpanHumDay spanHumString }.
		  {
			  'Tag mit höchster Temperatur'.
			  KlimaEntries getMaxTempDay.
			  KlimaEntries getMaxTempDay temperatures max printString }.
		  {
			  'Tag mit höchster Feuchtigkeit'.
			  KlimaEntries getMaxHumDay.
			  KlimaEntries getMaxHumDay humidities max printString }.
		  {
			  'Tag mit tiefster Temperatur'.
			  KlimaEntries getMinTempDay.
			  KlimaEntries getMinTempDay temperatures min printString }.
		  {
			  'Tag mit tiefster Feuchtigkeit'.
			  KlimaEntries getMinHumDay.
			  KlimaEntries getMinHumDay humidities min printString } }
]

{ #category : 'initialization' }
KlimaStatsPresenter >> initializePresenters [

	valuesTable := self tableView.
	monthDropdown := self newDropList items:
		                 (KlimaEntries entries collect: [ :e | e date month ])
			                 removeDuplicates; display: [ :e | e monat ]
]

{ #category : 'api' }
KlimaStatsPresenter >> rightClickActions [

	^ SpActionGroup new
		  addActionWith: [ :item |
				  item
					  name: 'Rohdaten Inspector öffnen';
					  action: [ valuesTable selectedItem second inspect ] ];
		  addActionWith: [ :item |
				  item
					  name: 'Temperaturplot ansehen';
					  action: [valuesTable selectedItem second plotTemp ] ];
		  addActionWith: [ :item |
				  item
					  name: 'Feuchtigkeitsplot ansehen';
					  action: [ valuesTable selectedItem second  plotHum ] ]
]

{ #category : 'api' }
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
