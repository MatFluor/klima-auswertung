Extension { #name : 'Date' }

{ #category : '*FilliKlima' }
Date >> germanMonthName [

	^ { #Januar. #Februar. #März. #April. #Mai. #Juni. #Juli. #August.
	  #September. #Oktober. #November. #Dezember } at: self monthIndex
]
