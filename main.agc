// Project: myBlackJack 
// Created: Begining September 2021

#renderer "Basic" // Use and Choose the OpenGL renderer

// Declare Type

// * * * * * * * * * * * * * *
// * * * H I N W E  I S : "GoSub"
// * * *
// * * *
// Sprungmarke GoSub habe ich nur Ausnahmweise benutzt,
// da innherhalb der Funktion "Function" zur Zeit keine
// Type Deklarartion aktzeptiert werden. Ansonsten bleibt die
// Gosub Anweisung eine Ausnahmeweise. Gosub sollte Aufgrund eines
// Gefahr, des Spaghetti-Code verzichtet werden, anstelle mit der Funktion,
// zu arbeiten.
// * * *
// * * *

GoSub SetTypes // "Gosub" Verwendung -> AUSNAHME!

// * * * * * * * * * * * * * *

// declare and set Constants

SetConstant ()

// declare Varibale

SetVariable () 

// show all errors

SetErrorMode(2)

SetWindowsDeviceProperty ()

// Variablen mit Werten zuweisen

SetCardReset() 

// Grafik-Daten laden

Int_CardImage 	= LoadImage("blackjack/Blackjack-Cards_L.png")

CoverSheet	= LoadImage("blackjack/Coversheet_L.png")
CoverSheetCard = CreateSprite (CoverSheet)
SetSpriteSize ( CoverSheetCard, MAX_DRAW_CARD_X_LENGH/2, MAX_DRAW_CARD_Y_LENGH / 2 )
SetSpriteVisible ( CoverSheetCard, 0 )


// 52 Karten mischen und in einer Array (=> IntArray_Mixed_Card) eintragen

ShuffleCards ()

FillCardTable ()



PutCardPosXY ()


FillCardToSprite ()
DeleteAnyArrays ()
Draw_Four_Card ()

// CPU - Player

SetDealerCard (1)

// Player

SetPlayerCard ()

// Build Buttons

MakeButton ()

// Button "Neue Karten" deaktivieren (Das dient nur zu Testzwecken [Debug])

SetVirtualButtonVisible (BUTTON_NEW_CARD, 0)
SetVirtualButtonActive (BUTTON_NEW_CARD, 0)

// Button "Dealer" deaktivieren (Das dient nur zu Testzwecken [Debug])

SetVirtualButtonVisible (BUTTON_DEALER, 0)
SetVirtualButtonActive (BUTTON_DEALER, 0)

// --> Hauptprogramm -->

do	

	if GetVirtualButtonReleased (BUTTON_DEALER) then SetDrawDealerCard ()
	
	
	if PlayerScore > MAX_SCORE_CARD and Bol_CardGameOver = 0
		
		Message (" BUST: Over 21 Lose. Your Card: [ " + str (PlayerScore) + " ]")		
		
		SetVirtualButtonVisible (BUTTON_DRAW, 0)
		SetVirtualButtonActive (BUTTON_DRAW, 0)
		
		SetVirtualButtonVisible (BUTTON_HOLD, 0)
		SetVirtualButtonActive (BUTTON_HOLD, 0)
		
		Bol_CardGameOver 	=	1
		
		// DealerScore   = 	0
		// PlayerScore	=	0
		
		endif
		
	
	if Int_MaxCard < 1
		
		SetVirtualButtonActive(BUTTON_NEW_CARD,0)	
		SetVirtualButtonVisible(BUTTON_NEW_CARD,0)
		SetVirtualButtonActive(BUTTON_DRAW,0)	
		SetVirtualButtonVisible(BUTTON_DRAW,0)
		
		SetVirtualButtonActive(BUTTON_NEW_GAME,0)	
		SetVirtualButtonVisible(BUTTON_NEW_GAME,0)
		
	endif
		
	// If Pressed "EXIT / QUIT"
		
	if GetVirtualButtonReleased(BUTTON_EXIT) then end 
	
	// If Pressed "DRAW / HIT"	(Wenn der Spieler eine weitere Karte zieht)
	
	if GetVirtualButtonReleased(BUTTON_DRAW) 
	
	// "New Card" Button deaktivieren	
		
		SetVirtualButtonVisible (BUTTON_NEW_CARD, 0)
		SetVirtualButtonActive (BUTTON_NEW_CARD, 0)

	// Weitere Karten ziehen	
		
		SetDrawPlayerCard ()
	
	endif
	
	// If Pressed "New Card"	(Wenn der Spieler eine neuen Karte möchte)
	
	if GetVirtualButtonReleased(BUTTON_NEW_CARD) 
		
			PlayerScore = 0
			
			IntArray_NewCardDeck[0] = 1 // Schalter
					
			IntArray_GetFourCards [2] = IntArray_Mixed_Card [1]
			IntArray_Mixed_Card.remove(1)
			
			IntArray_GetFourCards [4] = IntArray_Mixed_Card [1]
			IntArray_Mixed_Card.remove(1)
					
			SetPlayerCard ()
					 	
	endif
	
	// If Pressed "New Game"	(Wenn der Spieler ein neues Spiel beginnen möchte)	
	
	if GetVirtualButtonReleased(BUTTON_NEW_GAME) then NewCardGame()
	

	// If Pressed "Hold"	(Wenn der Spieler kein weiteren Karten ziehen möchte)
		
	if GetVirtualButtonReleased(BUTTON_HOLD)
	
	SetHoldPlayerCard()
	
	// Karten auswerten
	
	GetCards_Evaluation()
	
	endif

		
	Intern_Debug ()
						
	Sync ()
    
loop

// <-- Hauptprogramm <--


Function GetCards_Evaluation()
		
	if DealerPlayer.Score < PlayerScore or DealerPlayer.Score > MAX_SCORE_CARD
		
		Message ("You've has won")
	
	elseif PlayerScore < DealerPlayer.Score  or PlayerScore > MAX_SCORE_CARD
		
		Message ("Dealer has won")
	
	
	endif
	
	if DealerPlayer.Score = PlayerScore then	Message ("draw")
	

EndFunction

Function Intern_Debug ()
				
		Print ("BJ Cards - myBlackJack")
		Print ("Player Score: " + str ( PlayerScore ) )
		Print ("Dealer Score: " + str( DealerPlayer.Score ) )
		Print ("Cards Count: " + str(52 - Int_MaxCard))
				
		// Print ("Cards Count: " + str( CardsDeckRandom.length ))		
		// Print ("Int_XPosSetImage: " + str(Int_XPosSetImage + Int_XPosSetImage_Move) + " Int_YPosSetImage: " + str(Int_YPosSetImage - Int_YPosSetImage_Move))
		// Print ("Int_XPosSetImage_Move: " + str(Int_XPosSetImage_Move))
		// Print ("Int_YPosSetImage_Move: " + str(Int_YPosSetImage_Move))
		// if GetSpriteExists(PlayerCardID) then Print("Card ID: " + str(PlayerCardID ))
		// if GetSpriteExists(PlayerCardID) then Print("Depth: " + str ( GetSpriteDepth( PlayerCardID ) ))
	
EndFunction

Function CoverDeckCards (Enable as integer)
	
	local DealerSecondShowEnable as integer = 1
	
	if Enable then DealerSecondShowEnable = 0
	  
		SetSpritePosition( CoverSheetCard, Int_DealerCardDeckPosX, Int_DealerCardDeckPosY	)
		SetSpriteDepth ( CoverSheetCard, MAX_DEPTH_CARD )
		SetSpriteVisible ( DealerSecondsCardShow,DealerSecondShowEnable)
		SetSpriteVisible ( CoverSheetCard, Enable)
			
	EndFunction (Enable)
	
Function SetHoldPlayerCard ()
		
	// Die zweite verdeckte Karte von Dealer zeigen
			
	CoverDeckCards (0)
	
	// "Hit" Button deaktivieren	
		
	SetVirtualButtonVisible (BUTTON_DRAW, 0)
	SetVirtualButtonActive (BUTTON_DRAW, 0)	
	
	// "Hold" Button deaktivieren	
	
	SetVirtualButtonVisible (BUTTON_HOLD, 0)
	SetVirtualButtonActive (BUTTON_HOLD, 0)
		
	// Die zweite Karte (vorher gedeckte) mit der ersten Karte zusammenzaehlen
		
	DealerPlayer.Score =  DealerPlayer.Score + AddCard_V1 (3)	
	
	while DealerPlayer.Score < 17		
				
		SetDrawDealerCard ()
			
	endwhile
		
	EndFunction

Function SetDrawDealerCard ()
	
	local LDealerCardDeckPosX	as integer = 0
	local LDealerCardDeckPosY	as integer = 0
	local LDealerCardID			as integer = 0
	
		
	if DealerPlayer.Enable = 0 
	
		LDealerCardDeckPosX = Int_DealerCardDeckPosX + ( MAX_DRAW_CARD_X_LENGH / 2 ) + 5
		LDealerCardDeckPosY = Int_DealerCardDeckPosY 
	
		DealerPlayer.CardPosX = DealerPlayer.CardPosX + ( MAX_DRAW_CARD_X_LENGH / 2 ) - 45
		DealerPlayer.CardPosY = LDealerCardDeckPosY
	
		// 1.
	
		DealerPlayer.CardPosX = DealerPlayer.CardPosX + LDealerCardDeckPosX
	
		// 2.
	
		DealerPlayer.CardPosX = DealerPlayer.CardPosX - 85		
			
	endif
		
		if DealerPlayer.Enable = 1
		
				DealerPlayer.CardPosX = DealerPlayer.CardPosX + 45
																		
		endif
	
	// Dealer ist an der Reihe
	
	DealerPlayer.Enable = 1
	
	// Zweite Karte von Dealer aufdecken
	
	CoverDeckCards(0)
	
	// Hole eine zufällige Karte vom Kartendeck
	// lege es in Cache-Array ab
	
	IntArray_GetFourCards [1] = IntArray_Mixed_Card [1]

	// geholte Karte aus dem Karten Arrays löschen
		
	IntArray_Mixed_Card.remove(1)
	
	// Hole ID von der geholten Karte und Karte auf dem Bildschirm zeichnen
	
	LDealerCardID = ViewAndSetCardXY ( IntArray_GetFourCards[1],  DealerPlayer.CardPosX, DealerPlayer.CardPosY)	
	
		
	inc DrawCardNum	
	inc SPlayDrawCdIDCounter
	
	SavePlayerDrawCardID [SPlayDrawCdIDCounter] = LDealerCardID
		
	Int_DepthCard = Int_DepthCard - 1
	SetSpriteDepth(LDealerCardID,Int_DepthCard)
	
	DealerPlayer.Score =  DealerPlayer.Score + AddCard_V1 (1)
				
	Int_MaxCard = Int_MaxCard - 1
		
	EndFunction

Function NewCardGame()
	
	local HideDrawCard as integer = 0
	
		// Schalter für Spielende ausschalten
	
		Bol_CardGameOver	 =	0	
	
		// Schalter		
			
		IntArray_NewCardDeck [0] = 1
		
			
		// alle restlichen Karten entfernen / unsichtbar machen
		
			if not DrawCardNum = 0
				
				for HideDrawCard = 1 to DrawCardNum
			
					SetSpriteVisible(SavePlayerDrawCardID[(SPlayDrawCdIDCounter-HideDrawCard)+1],0)
			
				next HideDrawCard 
	
			endif
		
			// Dealer Karten und Boolean zurücksetzen
					
			DealerPlayer.Enable = 0
			DealerPlayer.CardPosX = 0
			DealerPlayer.CardPosY = 0
									
		
			// Puenkte für Spieler und Dealer zurücksetzen
			
			PlayerScore = 0			
			DealerPlayer.Score = 0
			
			// Neue Karten ziehen für Dealer und Player
			
			Draw_Four_Card ()
			
			// Dealer - Player
			
			SetSpriteVisible(DealerFirstCardShow, 0)
			SetSpriteVisible(DealerSecondsCardShow, 0)			
			
			// Zieh - Kartenpostition X und Y zuruecksetzen
			
			Int_XPosSetImage_Move = 0
			Int_YPosSetImage_Move = 0	
		
			// Draw Card Counter to NULL
			
			DrawCardNum = 0			
			
			// 2 Karten fuer Dealer geben	und 
			// zweite Karte umdrehen
			
			SetDealerCard (1)
			
			// 2 Karten fuer Player geben
						
			SetPlayerCard ()			
			
			// "Hit" Button aktivieren	
		
			SetVirtualButtonActive (BUTTON_DRAW, 1)
			SetVirtualButtonVisible (BUTTON_DRAW, 1)
						
			// "Hold" Button aktivieren	
			
			SetVirtualButtonActive (BUTTON_HOLD, 1)	
			SetVirtualButtonVisible (BUTTON_HOLD, 1)
			
	EndFunction

Function Draw_Four_Card ()

local a as integer
 
   for a = 1 to 4 
 	
 	IntArray_GetFourCards [a] = IntArray_Mixed_Card [1]
 	IntArray_Mixed_Card.remove(1)
 	 	
 	next a    

EndFunction

Function SetCardReset()

Int_XPosSetImage = ( MAX_WINDOW_SIZE_X / 2 ) - ( MAX_DRAW_CARD_X_LENGH / 2 ) + ( MAX_DRAW_CARD_X_LENGH / 2 ) 
Int_YPosSetImage = ( MAX_WINDOW_SIZE_Y / 2 ) - ( MAX_DRAW_CARD_Y_LENGH / 2 ) + ( MAX_DRAW_CARD_Y_LENGH / 2 ) 

EndFunction

Function AddCard_V1 (CardNumber as integer)
	
	local CardCounterSave as integer = 0	
	
	select 1    

    // -----------------------------------------------------///
    // Checke Card 1 to 13

	// Card As to 10
	    
    case (IntArray_GetFourCards[CardNumber] >= 1 and IntArray_GetFourCards[CardNumber] =< 10)
    
    CardCounterSave = CardCounterSave  + IntArray_GetFourCards[CardNumber]
    
    endcase

	// Card J to K


    case (IntArray_GetFourCards[CardNumber] >= 11 and IntArray_GetFourCards[CardNumber] =< 13)
    	
    CardCounterSave = CardCounterSave  + CardTentASJackKing
    
    // CardCounterSave = CardCounterSave + PutFourCards[CardNumber]

    endcase

	// -----------------------------------------------------///
	// Checke Card 14 to 27
	// Card As to 10

	case (IntArray_GetFourCards[CardNumber] >= 14 and IntArray_GetFourCards[CardNumber] =< 23)
    	
    CardCounterSave = CardCounterSave  +  ( IntArray_GetFourCards[CardNumber] - 13)

    endcase

	// Card J to K
   
    case (IntArray_GetFourCards[CardNumber] >= 24 and IntArray_GetFourCards[CardNumber] =< 26)
    	
    CardCounterSave = CardCounterSave  +  CardTentASJackKing

    endcase
    
    // -----------------------------------------------------///
	// Checke Card 27 to 40
	// Card As to 10

	case (IntArray_GetFourCards[CardNumber] >= 27 and IntArray_GetFourCards[CardNumber] =< 36)
    	
    CardCounterSave = CardCounterSave  +  ( IntArray_GetFourCards[CardNumber] - 26)	

    endcase

	// Card J to K
   
    case (IntArray_GetFourCards[CardNumber] >= 37 and (IntArray_GetFourCards[CardNumber]) =< 39)
    	
    CardCounterSave = CardCounterSave  +  CardTentASJackKing

    endcase
    
    // -----------------------------------------------------///
    // Checke Card 41 to 54
	// Card As to 10


	case (IntArray_GetFourCards[CardNumber] >= 40 and (IntArray_GetFourCards[CardNumber]) =< 49)
    	
    
    CardCounterSave = CardCounterSave  +  ( IntArray_GetFourCards[CardNumber] - 39)	

    endcase

	// Card J to K
   
    case (IntArray_GetFourCards[CardNumber] >= 50 and (IntArray_GetFourCards[CardNumber]) =< 52)
    	
    CardCounterSave = CardCounterSave  +  CardTentASJackKing

    endcase
                
endselect 

EndFunction CardCounterSave
	
	Function SetDrawPlayerCard ()
	
		local Counter as integer = 0	
	
	if DrawCardNum > (MAX_SHOW_DRAW_CARD-1)
		
		Bol_ColumnEnable = 1
		
		Int_YPosSetImage_Move = 0
		Int_XPosSetImage_Move = 0
		DrawCardNum = 0
		
		SetCardReset()
		
		Int_XPosSetImage = Int_XPosSetImage - FIRSTCARDPOSX
		
				
	for Counter = 1 to MAX_SHOW_DRAW_CARD
	
		SetSpriteVisible(SavePlayerDrawCardID[(SPlayDrawCdIDCounter-Counter)+1],0)
		
		SetSpriteVisible(IntArray_NewCardDeck[1], 0)
		SetSpriteVisible(IntArray_NewCardDeck[2], 0)
		
	next Counter
		
	
	endif
	
	inc DrawCardNum
	inc SPlayDrawCdIDCounter
	
	
	if DrawCardNum = 1 
		
		if Bol_ColumnEnable = 0
		
			Int_YPosSetImage_Move = (SECCARDPOSY*2)			
		
		endif
			
	else
	
		Int_YPosSetImage_Move = Int_YPosSetImage_Move + SECCARDPOSY
		Int_XPosSetImage_Move = Int_XPosSetImage_Move + SECCARDPOSX
	
	endif

																																																																																																																																						
	IntArray_GetFourCards [1] = IntArray_Mixed_Card [1]
	IntArray_Mixed_Card.remove(1)
		
	Int_PlayerCardID = ViewAndSetCardXY ( IntArray_GetFourCards[1],  (Int_XPosSetImage + Int_XPosSetImage_Move), (Int_YPosSetImage - Int_YPosSetImage_Move))	
	SavePlayerDrawCardID [SPlayDrawCdIDCounter] = Int_PlayerCardID
			
	
	Int_DepthCard = Int_DepthCard - 1
		
	SetSpriteDepth(Int_PlayerCardID,Int_DepthCard)
		
	
	PlayerScore =  PlayerScore + AddCard_V1 (1)
		
	Int_MaxCard = Int_MaxCard - 1		
		
	EndFunction


Function SetDealerCard (CardEnable as integer )
	
	local XPosButton 			as integer 	=	0
	local YPosButton 			as integer 	=	0		
	
	local XPosxExtra				as integer	= 	85
	local YPosxExtra				as integer	= 	275
		
	SetCardReset()
	
	XPosButton = ( MAX_WINDOW_SIZE_X / 2 ) - (MAX_DRAW_CARD_X_LENGH / 2 ) + (MAX_DRAW_CARD_X_LENGH / 2 )
	YPosButton = ( MAX_WINDOW_SIZE_Y / 2 ) - (MAX_DRAW_CARD_Y_LENGH / 2 ) + (MAX_DRAW_CARD_Y_LENGH / 2 )
	
	DealerFirstCardShow	= 	ViewAndSetCardXY ( IntArray_GetFourCards[1],  XPosButton - XPosxExtra, YPosButton - YPosxExtra) 
	SetSpriteDepth ( DealerFirstCardShow, Int_DepthCard )
	Int_DepthCard	=	( MAX_DEPTH_CARD  - 	2 )
	
	DealerPlayer.Score = DealerPlayer.Score + AddCard_V1(1) 
	
	DealerSecondsCardShow	=	ViewAndSetCardXY ( IntArray_GetFourCards[3],  XPosButton, YPosButton - YPosxExtra) 
	SetSpriteDepth ( DealerSecondsCardShow, Int_DepthCard )
	Int_DepthCard	=	(MAX_DEPTH_CARD  - 	1)
	
	// Variablen für Funktionausgabe
	
	Int_DealerCardDeckPosX = XPosButton
	Int_DealerCardDeckPosY = YPosButton - YPosxExtra
			
	// Kartenzaehler zwei Abziehen
	
	Int_MaxCard = Int_MaxCard - 2 
	
	// Zweite Karte von Dealer decken
	
	CoverDeckCards (CardEnable)
	
EndFunction 

Function SetPlayerCard ()
		
	local FirstCardShow		as integer 	= 	0
	local SecondCardShow		as integer	=	0
	
	SetCardReset()
		
		// Falls der Spieler neue Kartendeck gewählt hat,
		// die bisherigen Kartendeck verstecken.
		// Sonst werden die neuen Karten von den alten überdeckt,
		// so, daß man die neuen gewählten Karten nicht sehen kann
		
		if IntArray_NewCardDeck[0] = 1  // falls neue Kartendeck Button gedrückt wurde
			
			SetSpriteVisible(IntArray_NewCardDeck[1],0)
			SetSpriteVisible(IntArray_NewCardDeck[2],0)
			
		endif
	
	FirstCardShow		=	ViewAndSetCardXY ( IntArray_GetFourCards[2],  Int_XPosSetImage-FIRSTCARDPOSX, Int_YPosSetImage) 	
	Int_DepthCard		=	( MAX_DEPTH_CARD  - 	3 )
	SetSpriteDepth ( FirstCardShow, Int_DepthCard )
	
	SecondCardShow		=	ViewAndSetCardXY ( IntArray_GetFourCards[4],  Int_XPosSetImage-SECCARDPOSX, Int_YPosSetImage - SECCARDPOSY) 
	Int_DepthCard		=	(MAX_DEPTH_CARD  - 	4 )
	SetSpriteDepth ( SecondCardShow, Int_DepthCard )
			
	// Kontrollflags für Button "neue Kartendeck"
	// als nicht gedrückt setzen
	
	IntArray_NewCardDeck[0] = 0 
	
	// Die beiden Kartendeck für Spieler merken
	
	IntArray_NewCardDeck[2] = SecondCardShow
	IntArray_NewCardDeck[1] = FirstCardShow

	PlayerScore =  PlayerScore + AddCard_V1 (2)
	PlayerScore =  PlayerScore + AddCard_V1 (4)
	
	// Kartenzaehler zwei Abziehen
	
	Int_MaxCard = Int_MaxCard - 2

EndFunction

Function MakeButton ()

AddVirtualButton(BUTTON_DRAW, Int_XPosSetImage - 50, Int_YPosSetImage + 175, 75)
AddVirtualButton(BUTTON_HOLD, Int_XPosSetImage + 50, Int_YPosSetImage + 175, 75)
AddVirtualButton(BUTTON_EXIT, MAX_WINDOW_SIZE_X-80, MAX_WINDOW_SIZE_Y-80, 75)

AddVirtualButton(BUTTON_NEW_CARD, Int_XPosSetImage, Int_YPosSetImage + 250, 0)
SetVirtualButtonSize(BUTTON_NEW_CARD, 150,50)

AddVirtualButton(BUTTON_NEW_GAME, Int_XPosSetImage, Int_YPosSetImage + 325, 0)
SetVirtualButtonSize(BUTTON_NEW_GAME, 150,50)

AddVirtualButton(BUTTON_DEALER, MAX_WINDOW_SIZE_X-160, MAX_WINDOW_SIZE_Y-80, 75)


SetVirtualButtonText(BUTTON_DRAW,"Ziehen")
SetVirtualButtonText(BUTTON_HOLD,"Halten")
SetVirtualButtonText(BUTTON_EXIT,"Exit")
SetVirtualButtonText(BUTTON_NEW_CARD,"Neue Karten")
SetVirtualButtonText(BUTTON_NEW_GAME,"Neues Spiel")
SetVirtualButtonText(BUTTON_DEALER,"Dealer")

EndFunction

Function ShuffleCards ()
	
// Global Array - Variabale: 
	
	local L_a 			as integer
	local L_element1		as integer
	local L_element2		as integer
	local L_tempNumber	as integer
	
	For L_a = 1 to 52
    
    	IntArray_Mixed_Card[L_a] = L_a
    	
    Next L_a
 
// Shuffle the numbers.

	For L_a = 1 to 52

    	L_element1 = Random(1, 52)
    	L_element2 = Random(1, 52)
    
    	L_tempNumber = IntArray_Mixed_Card[L_element1]
    
    	IntArray_Mixed_Card[L_element1] = IntArray_Mixed_Card[L_element2]
    	IntArray_Mixed_Card[L_element2] = L_tempNumber

	Next L_a
	

endfunction

Function ViewAndSetCardXY (CardNum, XPOS, YPOS as integer)

CardResult as integer = 0

if CardNum < 1 
	
	CardResult = 1
	
	endif

if CardNum > 52 
	
	CardResult = 2
	
	endif

if CardResult = 0 	

SetSpritePosition(SPR_CardsDeckFT[CardNum], XPOS,YPOS)
SetSpriteSize(SPR_CardsDeckFT[CardNum], MAX_DRAW_CARD_X_LENGH/2, MAX_DRAW_CARD_Y_LENGH/2)
SetSpriteVisible(SPR_CardsDeckFT[CardNum],1)

else

	Str_Messages = "Error Code: " + str(CardResult)
	Message(Str_Messages + " [Program abort]")
	end  // Program abort

endif



endfunction SPR_CardsDeckFT[CardNum]

Function DeleteAnyArrays ()

undim CardsDeckX[]
undim CardsDeckY[]
undim CardsDeckFT[]
undim ID_CardsDeckFT[]

EndFunction

Function FillCardToSprite ()

local a as integer


for a = 1 to 52

SPR_CardsDeckFT[a] = CreateSprite (ID_CardsDeckFT[a])
SetSpriteVisible(SPR_CardsDeckFT[a],0)

next a

endfunction

Function FillCardTable ()
	
	local a as integer
	local b as integer
	local c as integer
	
	b = 12
	c = 220 + 20

for a = 0 to 3
	
	CardsDeckY[ a ] = b
	
	b = b + c
		
	next a


b = 8
c = 180


for a = 0 to 12
	
	CardsDeckX[a] = b
	
	b = b + c
		
	next a
	
	
	c=1
	
	for a = 0 to 12 
		
		CardsDeckFT[c] = CardsDeckX[a]
		c=c+1
		
		next a
	
	b=14
			
	for a = 0 to 3 
		
		CardsDeckFT[b] = CardsDeckY[a]
		b=b+1
		
		next a	
	
	
EndFunction

Function PutCardPosXY ()
	
	local SetCardPosXY 	as integer	= 0
	local SLoop			as integer 	= 52
	local SLoopZaehler	as integer	= 1
			
for SLoopZaehler = 1 to SLoop
	
	SetCardPosXY = SetCardPosXY + 1	
		
	if (SLoopZaehler >= 1) and (SLoopZaehler <= 13)
		
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(Int_CardImage, CardsDeckFT[SetCardPosXY],CardsDeckFT[14], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
		
		// Zahltreffer = "between 1 and 13"	
	
	endif
	
	if (SLoopZaehler > 13) and (SLoopZaehler <= 26)
		
		SetCardPosXY=SLoopZaehler-13
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(Int_CardImage, CardsDeckFT[SetCardPosXY],CardsDeckFT[15], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
	
		// Zahltreffer = "between 14 and 26"
	
	endif

	if (SLoopZaehler > 26) and (SLoopZaehler <= 39)
		
		SetCardPosXY=SLoopZaehler-26
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(Int_CardImage, CardsDeckFT[SetCardPosXY],CardsDeckFT[16], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
		
		// Zahltreffer = "between 27 and 39"
	
	endif
	
	if (SLoopZaehler > 39) and (SLoopZaehler <= 52)
		
		SetCardPosXY=SLoopZaehler-39
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(Int_CardImage, CardsDeckFT[SetCardPosXY],CardsDeckFT[17], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
		
		// Zahltreffer = "between 40 and 52"
	
	endif
				
	next SLoopZaehler
	
endfunction

Function SetWindowsDeviceProperty ()
	
	// set window properties and display properties

	SetWindowTitle( "myBlackJack" )
	SetWindowSize( MAX_WINDOW_SIZE_X, MAX_WINDOW_SIZE_Y, 0 )
	SetWindowAllowResize( 1 ) // allow the user to resize the window

	// set  display properties

	SetVirtualResolution( MAX_WINDOW_SIZE_X, MAX_WINDOW_SIZE_Y ) // doesn't have to match the window
	SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
	SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
	SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
	UseNewDefaultFonts( 1 )

	
	EndFunction

Function SetConstant ()
			
	#constant BUTTON_DRAW			=	1
	#constant BUTTON_HOLD			=	2
	#constant BUTTON_EXIT			=	3
	#constant BUTTON_NEW_CARD		=	4
	#constant BUTTON_NEW_GAME		=	5	
	#constant BUTTON_DEALER			=	6		
	
	#constant MAX_SHOW_DRAW_CARD		=	4
	
	#constant CardTentASJackKing		= 	10
	
	#constant MAX_SCORE_CARD			=	21
	
	#constant MAX_WINDOW_SIZE_X		= 	1024
	#constant MAX_WINDOW_SIZE_Y		= 	768

	#constant MAX_DRAW_CARD_X_LENGH	= 	160
	#constant MAX_DRAW_CARD_Y_LENGH	= 	220

	#constant MAX_DEPTH_CARD			= 	52	
	
	#constant FIRSTCARDPOSX			=   50
	#constant SECCARDPOSX			=   25
	#constant SECCARDPOSY			=   20
			
	EndFunction

Function SetVariable ()
	
	#option_explicit
		
	// * * * Type * * *
	
	global DealerPlayer			as	_Gamer	
		
	// * * * Integer Variablen
	
	global Int_CardImage			as 	integer	= 	0	// Index für Bilddatei einer Karten
	global Int_MaxCard			as 	integer = 	52 	// Maxmimaler Karten von Deck genommen?
	
	// Jede Karte erählt eine Ebene (Hintergrund) - Index
	
	global Int_DepthCard			as	integer	=	MAX_DEPTH_CARD 
	
	global Int_XPosSetImage		as 	integer
	global Int_YPosSetImage 		as 	integer
	
	global Int_XPosSetImage_Move	as	integer	=	0
	global Int_YPosSetImage_Move	as	integer	= 	0
	
	// Jede Karte einer Player hat eine eigene ID (Index)
	
	global Int_PlayerCardID		as	integer	=	0
	
	// Zeichne / Positioniere Kartenfür Dealer auf dem Bildschirm
	
	global Int_DealerCardDeckPosX as 	integer	=	0
	global Int_DealerCardDeckPosY as 	integer	=	0
	
	// * * * Arrays - Variablen * * *
	
	global IntArray_NewCardDeck	as 	integer [3]	= [0] // Flags und Index für Karten ziehen für Player
	global IntArray_GetFourCards	as 	integer [4] 	// Felder für 4 gezogene Karten vom Kartendeck
	global IntArray_Mixed_Card	as 	integer [54]	// Felder für gemischte Karten
	
	// * * * String Variablen * * *
	
	global Str_Messages 				as 	string 		// Allgemeine Meldungen
	
	// * * *  Boolean - Variablen / Kontrollflags * * *
	
	// Karten werden etwas Nebeneinander auf dem Schirm gezeigt
	
	global Bol_ColumnEnable			as	integer 	= 	0	
	
	// Flagcontroll für SpielEnde (1 =  Spielende)
	
	global Bol_CardGameOver			as 	integer 	= 	0
	
		// * * * //
		
	global DealerFirstCardShow		as 	integer 	= 	0		
	global DealerSecondsCardShow		as 	integer		=	0		
		
	global SPlayDrawCdIDCounter		as 	integer 	= 	0
	global SavePlayerDrawCardID		as 	integer [53]
		
	// Punkte für Player
		
	global PlayerScore				as 	integer 	= 	0
		
	global ID_CardsDeckFT 			as 	integer [52]
	global SPR_CardsDeckFT 			as 	integer [52]
	
	global CardsDeckFT 				as 	integer [17]
	
	global CardsDeckX 				as 	integer [12]
	global CardsDeckY 				as 	integer [3]
	
			
	global CoverSheet 				as 	integer
	global CoverSheetCard 			as 	integer
		
	global DrawCardNum				as	integer	=	0
	global Push_DrawCardNum			as 	integer	=	0
	
	global BackupNum					as	integer	=	0
			
	global Max_DrawCardNum 			as 	integer = 	0	
	
EndFunction


SetTypes:
	
	Type _Gamer		
		
		Enable		 		as integer
		Score				as integer
		
		CardPosX				as integer
		CardPosY				as integer
		
		CardID				as integer
		
		EndType
	
Return