Class {
	#name : 'KlimaStatsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'valuesTable',
		'monthDropdown',
		'chartPresenter'
	],
	#category : 'FilliKlima-Spec',
	#package : 'FilliKlima',
	#tag : 'Spec'
}

{ #category : 'layout' }
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
						    action: [ self defer: [
							    chartPresenter layout add: KlimaEntries plotMinMaxTemp open] ]);
				   add: (self newButton
						    label: 'Jahres-Feuchtigkeitsplot ansehen';
						    action: [ self defer: [ 
							    chartPresenter layout add: KlimaEntries plotMinMaxHum open ]]))
		  expand: false;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: monthDropdown;
				   add: (self newButton
						    label: 'Monats Temperaturplot ansehen';
						    action: [ self defer: [
								    chartPresenter layout add: (KlimaEntries
											     plotMinMaxTempByMonth:
												     monthDropdown selectedItem monthIndex
											     andYear: monthDropdown selectedItem year) open] ]);
				   add: (self newButton
						    label: 'Monats Feuchtigkeitsplot ansehen';
						    action: [ self defer: [
								    chartPresenter layout add: (KlimaEntries
											     plotMinMaxHumByMonth:
												     monthDropdown selectedItem monthIndex
											     andYear: monthDropdown selectedItem year) open] ]))
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
KlimaStatsPresenter >> initialize [

	super initialize.
]

{ #category : 'initialization' }
KlimaStatsPresenter >> initializePresenters [

	valuesTable := self tableView.
	monthDropdown := self newDropList
		                 items:
			                 (KlimaEntries entries collect: [ :e |
					                  e date month ]) removeDuplicates;
		                 display: [ :e | e monat ].
	chartPresenter := KlimaChartPresenter newApplication:
		                  self application.
]

{ #category : 'api' }
KlimaStatsPresenter >> rightClickActions [

	^ SpActionGroup new
		  addActionWith: [ :item |
				  item
					  name: 'Rohdaten Inspector öffnen';
					  action: [ self defer: [valuesTable selectedItem second inspect] ] ];
		  addActionWith: [ :item |
				  item
					  name: 'Temperaturplot ansehen';
					  action: [ self defer: [
							  chartPresenter layout add:
									  valuesTable selectedItem second plotTemp open] ] ];
		  addActionWith: [ :item |
				  item
					  name: 'Feuchtigkeitsplot ansehen';
					  action: [ self defer: [chartPresenter layout add:
	valuesTable selectedItem second plotHum open] ] ]
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
