// Project: myBlackJack 
// Created: Begining September 2021

// Use and Choose the OpenGL renderer

#renderer "Basic"

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

backdrop0 	= LoadImage("blackjack/Blackjack-Cards_L.png")

CoverSheet	= LoadImage("blackjack/Coversheet_L.png")
CoverSheetCard = CreateSprite (CoverSheet)
SetSpriteSize(CoverSheetCard, MAX_DRAW_CARD_X_LENGH/2, MAX_DRAW_CARD_Y_LENGH / 2 )
SetSpriteVisible(CoverSheetCard, 0)


// 52 Karten mischen und in einer Array eintragen

ShuffleCards ()

FillCardTable ()

PutCardPosXY ()

// SPR_CardsDeckFT[1] = CreateSprite (ID_CardsDeckFT[52])

FillCardToSprite ()
DeleteAnyArrays ()


Draw_Four_Card ()

// CPU - Player

SetCPUCard ()

// Player

SetPlayerCard ()

// Build Buttons

MakeButton ()

// Button "Neue Karten" deaktivieren (Das dient zu Testzwecken [Debug])

SetVirtualButtonVisible (BUTTON_NEW_CARD, 0)
SetVirtualButtonActive (BUTTON_NEW_CARD, 0)


// --> Hauptprogramm -->


do
	
	/**

	if PlayerScore > MAX_SCORE_CARD and CardGameOver = 0
		
		Message (" BUST: Over 21 Lose. Your Card: [ " + str (PlayerScore) + " ]")		
		SetVirtualButtonVisible (BUTTON_DRAW, 0)
		SetVirtualButtonActive (BUTTON_DRAW, 0)
		
		SetVirtualButtonVisible (BUTTON_HOLD, 0)
		SetVirtualButtonActive (BUTTON_HOLD, 0)
		
		CardGameOver = 1
		
		endif
	
	**/
	
	if GMaxCard < 1
		
		SetVirtualButtonActive(BUTTON_NEW_CARD,0)	
		SetVirtualButtonVisible(BUTTON_NEW_CARD,0)
		SetVirtualButtonActive(BUTTON_DRAW,0)	
		SetVirtualButtonVisible(BUTTON_DRAW,0)
		
	endif
		
	// If Pressed "exit"
		
	if GetVirtualButtonPressed(BUTTON_EXIT) then end 
	
	// If Pressed "draw"	(Wenn der Spieler eine weitere Karte zieht)
	
	if GetVirtualButtonPressed(BUTTON_DRAW) 
	
	// "New Card" Button deaktivieren	
		
		SetVirtualButtonVisible (BUTTON_NEW_CARD, 0)
		SetVirtualButtonActive (BUTTON_NEW_CARD, 0)

	// Weitere Karten ziehen	
	
		Player_Pressed_Draw_V2 ()
	
	endif
	
	// If Pressed "New Card"	(Wenn der Spieler eine neuen Karte möchte)
	
	if GetVirtualButtonPressed(BUTTON_NEW_CARD) 
		
			PlayerScore = 0
			
			NewCardDeck[0] = 1 // Schalter
					
			PutFourCards [2] = CardsDeckRandom [1]
			CardsDeckRandom.remove(1)
			
			PutFourCards [4] = CardsDeckRandom [1]
			CardsDeckRandom.remove(1)
			
			SetPlayerCard ()
 	
	endif
	
	// If Pressed "New Game"	(Wenn der Spieler ein neues Spiel beginnen möchte)
	
	if GetVirtualButtonPressed(BUTTON_NEW_GAME) 
		
		local HideDrawCard as integer = 0
		
		// Schalter		
			
		NewCardDeck[0] = 1
		
			
		// restlichen Karten entfernen / unsichtbar machen
		
		if not DrawCardNum = 0
				
			for HideDrawCard = 1 to DrawCardNum
			
				SetSpriteVisible(SavePlayerDrawCardID[(SPlayDrawCdIDCounter-HideDrawCard)+1],0)
			
			next HideDrawCard 
	
		endif
									
			// Puenkte für Spieler zurücksetzen
			
			PlayerScore = 0
			
			// Neue Karten ziehen für CPU und Player
			
			Draw_Four_Card ()
			
			// CPU - Player
			
			SetSpriteVisible(CPUFirstCardShow, 0)
			SetSpriteVisible(CPUSecondsCardShow, 0)
			
			// 2 Karten fuer CPU geben			
			
			SetCPUCard ()
			
			// 2 Karten fuer Player geben
			
			SetPlayerCard ()
			
			// Draw Card Counter to NULL
			
			DrawCardNum = 0
 	
	endif
		
	intern_debug ()
			
	Sync ()
    
loop

// <-- Hauptprogramm <--

Function Draw_Four_Card ()

 for a = 1 to 4 
 	
 	PutFourCards [a] = CardsDeckRandom [1]
 	CardsDeckRandom.remove(1)
 	 	
 	next a    

EndFunction



Function SetCardReset()

XButton = ( MAX_WINDOW_SIZE_X / 2 ) - ( MAX_DRAW_CARD_X_LENGH / 2 ) + ( MAX_DRAW_CARD_X_LENGH / 2 ) 
YButton = ( MAX_WINDOW_SIZE_Y / 2 ) - ( MAX_DRAW_CARD_Y_LENGH / 2 ) + ( MAX_DRAW_CARD_Y_LENGH / 2 ) 

EndFunction

Function AddCard_V1 (CardNumber as integer)
	
	select 1
    

    // -----------------------------------------------------///
    // Checke Card 1 to 13

	// Card As to 10
	    
    case (PutFourCards[CardNumber] >= 1 and PutFourCards[CardNumber] =< 10)
    
    PlayerScore = PlayerScore  + PutFourCards[CardNumber]
    
    endcase

	// Card J to K


    case (PutFourCards[CardNumber] >= 11 and PutFourCards[CardNumber] =< 13)
    	
    PlayerScore = PlayerScore  + CardTentASJackKing
    
    // PlayerScore = PlayerScore + PutFourCards[CardNumber]

    endcase

	// -----------------------------------------------------///
	// Checke Card 14 to 27
	// Card As to 10


	case (PutFourCards[CardNumber] >= 14 and PutFourCards[CardNumber] =< 23)
    	
    PlayerScore = PlayerScore  +  ( PutFourCards[CardNumber] - 13)

    endcase

	// Card J to K
   
    case (PutFourCards[CardNumber] >= 24 and PutFourCards[CardNumber] =< 26)
    	
    PlayerScore = PlayerScore  +  CardTentASJackKing

    endcase
    
    // -----------------------------------------------------///
	// Checke Card 27 to 40
	// Card As to 10


	case (PutFourCards[CardNumber] >= 27 and PutFourCards[CardNumber] =< 36)
    	
    PlayerScore = PlayerScore  +  ( PutFourCards[CardNumber] - 26)	

    endcase

	// Card J to K
   
    case (PutFourCards[CardNumber] >= 37 and (PutFourCards[CardNumber]) =< 39)
    	
    PlayerScore = PlayerScore  +  CardTentASJackKing

    endcase
    
    // -----------------------------------------------------///
    // Checke Card 41 to 54
	// Card As to 10


	case (PutFourCards[CardNumber] >= 40 and (PutFourCards[CardNumber]) =< 49)
    	
    
    PlayerScore = PlayerScore  +  ( PutFourCards[CardNumber] - 39)	

    endcase

	// Card J to K
   
    case (PutFourCards[CardNumber] >= 50 and (PutFourCards[CardNumber]) =< 52)
    	
    PlayerScore = PlayerScore  +  CardTentASJackKing

    endcase
    
            
endselect 

EndFunction


Function intern_debug ()
		
		
		Print ("BJ Cards - myBlackJack")
		Print ("Score: " + str ( PlayerScore ) )
		// Print ("Cards Count: " + str( CardsDeckRandom.length ))		
		Print ("Cards Count: " +str(52 - GMaxCard))
		
		// if GetSpriteExists(PlayerCardID) then Print("Card ID: " + str(PlayerCardID ))
		// if GetSpriteExists(PlayerCardID) then Print("Depth: " + str ( GetSpriteDepth( PlayerCardID ) ))

	
EndFunction
	
	
	Function Player_Pressed_Draw_V2 ()
	
		local Counter as integer = 0	
	
	if DrawCardNum > (MAX_SHOW_DRAW_CARD-1)
		
		Column_Enable = 1
		
		YButton_Move = 0
		XButton_Move = 0
		DrawCardNum = 0
		
		SetCardReset()
		
		XButton = XButton - FIRSTCARDPOSX
		
				
	for Counter = 1 to MAX_SHOW_DRAW_CARD
	
		SetSpriteVisible(SavePlayerDrawCardID[(SPlayDrawCdIDCounter-Counter)+1],0)
		
		SetSpriteVisible(NewCardDeck[1], 0)
		SetSpriteVisible(NewCardDeck[2], 0)
		
	next Counter
		
	
	endif
	
	inc DrawCardNum
	inc SPlayDrawCdIDCounter
	
	
	if DrawCardNum = 1 
		
		if Column_Enable = 0
		
			YButton_Move = (SECCARDPOSY*2)
		
		endif
			
	else
	
		YButton_Move = YButton_Move + SECCARDPOSY
		XButton_Move = XButton_Move + SECCARDPOSX
	
	endif

																																																																																																																																						
	PutFourCards [1] = CardsDeckRandom [1]
	CardsDeckRandom.remove(1)
		
	PlayerCardID = ViewAndSetCardXY ( PutFourCards[1],  (XButton + XButton_Move), (YButton - YButton_Move))	
	SavePlayerDrawCardID [SPlayDrawCdIDCounter] = PlayerCardID
			
	
	GSetDepthCard = GSetDepthCard - 1
		
	SetSpriteDepth(PlayerCardID,GSetDepthCard)
		
	
	AddCard_V1 (1)
		
	GMaxCard = GMaxCard - 1		
	
	EndFunction


Function SetCPUCard ()
	
	local XPosButton 			as integer 	=	0
	local YPosButton 			as integer 	=	0	
	local CPUCoverSheetCardShow		as integer	=	0
	
	SetCardReset()
	
	XPosButton = ( MAX_WINDOW_SIZE_X / 2 ) - (MAX_DRAW_CARD_X_LENGH / 2 ) + (MAX_DRAW_CARD_X_LENGH / 2 )
	YPosButton = ( MAX_WINDOW_SIZE_Y / 2 ) - (MAX_DRAW_CARD_Y_LENGH / 2 ) + (MAX_DRAW_CARD_Y_LENGH / 2 )
	
	CPUFirstCardShow	= 	ViewAndSetCardXY ( PutFourCards[1],  XPosButton - 85, YPosButton - 275) 
	SetSpriteDepth ( CPUFirstCardShow, GSetDepthCard )
	GSetDepthCard	=	(MAX_DEPTH_CARD  - 	2)
	
	CPUSecondsCardShow	=	ViewAndSetCardXY ( PutFourCards[3],  XPosButton, YPosButton - 275) 
	SetSpriteDepth ( CPUSecondsCardShow, GSetDepthCard )
	GSetDepthCard	=	(MAX_DEPTH_CARD  - 	1)
	
	/**
			
	SetSpritePosition(CoverSheetCard, XPosButton, YPosButton - 275 )
	SetSpriteDepth ( CoverSheetCard, MAX_DEPTH_CARD )
	SetSpriteVisible(SecondsCardShow,0)
	SetSpriteVisible(CoverSheetCard, 0)
	
	**/
	
	// Kartenzaehler zwei Abziehen
	
	GMaxCard = GMaxCard - 2 
	
EndFunction

Function SetPlayerCard ()
		
	local FirstCardShow		as integer 	= 	0
	local SecondCardShow		as integer	=	0
	
	SetCardReset()
		
		// Falls der Spieler neue Kartendeck gewählt hat,
		// die bisherigen Kartendeck verstecken.
		// Sonst werden die neuen Karten von den alten überdeckt,
		// so, daß man die neuen gewählten Karten nicht sehen kann
		
		if NewCardDeck[0] = 1  // falls neue Kartendeck Button gedrückt wurde
			
			SetSpriteVisible(NewCardDeck[1],0)
			SetSpriteVisible(NewCardDeck[2],0)
			
		endif
	
	FirstCardShow		=	ViewAndSetCardXY ( PutFourCards[2],  XButton-FIRSTCARDPOSX, YButton) 	
	GSetDepthCard		=	( MAX_DEPTH_CARD  - 	3 )
	SetSpriteDepth ( FirstCardShow, GSetDepthCard )
	
	SecondCardShow		=	ViewAndSetCardXY ( PutFourCards[4],  XButton-SECCARDPOSX, YButton - SECCARDPOSY) 
	GSetDepthCard		=	(MAX_DEPTH_CARD  - 	4 )
	SetSpriteDepth ( SecondCardShow, GSetDepthCard )
			
	// Kontrollflags für Button "neue Kartendeck"
	// als nicht gedrückt setzen
	
	NewCardDeck[0] = 0 
	
	// Die beiden Kartendeck für Spieler merken
	
	NewCardDeck[2] = SecondCardShow
	NewCardDeck[1] = FirstCardShow

	AddCard_V1 (2)
	AddCard_V1 (4)
	
	// Kartenzaehler zwei Abziehen
	
	GMaxCard = GMaxCard - 2

EndFunction

Function MakeButton ()

AddVirtualButton(BUTTON_DRAW, XButton - 50, YButton + 175, 75)
AddVirtualButton(BUTTON_HOLD, XButton + 50, YButton + 175, 75)
AddVirtualButton(BUTTON_EXIT, MAX_WINDOW_SIZE_X-80, MAX_WINDOW_SIZE_Y-80, 75)
AddVirtualButton(BUTTON_NEW_CARD, XButton, YButton + 250, 0)
SetVirtualButtonSize(BUTTON_NEW_CARD, 150,50)

AddVirtualButton(BUTTON_NEW_GAME, XButton, YButton + 325, 0)
SetVirtualButtonSize(BUTTON_NEW_GAME, 150,50)

SetVirtualButtonText(BUTTON_DRAW,"Ziehen")
SetVirtualButtonText(BUTTON_HOLD,"Halten")
SetVirtualButtonText(BUTTON_EXIT,"Exit")
SetVirtualButtonText(BUTTON_NEW_CARD,"Neue Karten")
SetVirtualButtonText(BUTTON_NEW_GAME,"Neues Spiel")

EndFunction

Function ShuffleCards ()
	
	local n 		as integer
	local element1	as integer
	local element2	as integer
	local tempNumber	as integer
	
	For n = 1 to 52
    
    	CardsDeckRandom[n] = n
    	
    Next n
 
// Shuffle the numbers.

	For n = 1 to 52

    	element1 = Random(1, 52)
    	element2 = Random(1, 52)
    
    	tempNumber = CardsDeckRandom[element1]
    
    	CardsDeckRandom[element1] = CardsDeckRandom[element2]
    	CardsDeckRandom[element2] = tempNumber

	Next n
	

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
// GetSpriteImageID()
else

	Zahltreffer = "Error Code: " + str(CardResult)
	Message(Zahltreffer + " [Program abort]")
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

for a = 1 to 52


SPR_CardsDeckFT[a] = CreateSprite (ID_CardsDeckFT[a])
SetSpriteVisible(SPR_CardsDeckFT[a],0)

next a

endfunction

Function FillCardTable ()
	
	local a, b, c as integer
	
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
	
	
	endfunction

Function PutCardPosXY ()
	
	local SetCardPosXY 	as integer	= 0
	local SLoop			as integer 	= 52
	local SLoopZaehler	as integer	= 1
			
for SLoopZaehler = 1 to SLoop
	
	SetCardPosXY = SetCardPosXY + 1	
		
	if (SLoopZaehler >= 1) and (SLoopZaehler <= 13)
		
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(backdrop0, CardsDeckFT[SetCardPosXY],CardsDeckFT[14], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
		
		// Zahltreffer = "between 1 and 13"	
	
	endif
	
	if (SLoopZaehler > 13) and (SLoopZaehler <= 26)
		
		SetCardPosXY=SLoopZaehler-13
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(backdrop0, CardsDeckFT[SetCardPosXY],CardsDeckFT[15], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
	
		// Zahltreffer = "between 14 and 26"
	
	endif

	if (SLoopZaehler > 26) and (SLoopZaehler <= 39)
		
		SetCardPosXY=SLoopZaehler-26
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(backdrop0, CardsDeckFT[SetCardPosXY],CardsDeckFT[16], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
		
		// Zahltreffer = "between 27 and 39"
	
	endif
	
	if (SLoopZaehler > 39) and (SLoopZaehler <= 52)
		
		SetCardPosXY=SLoopZaehler-39
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(backdrop0, CardsDeckFT[SetCardPosXY],CardsDeckFT[17], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
		
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

Function NULL ()
	
	

EndFunction

Function SetConstant ()

			
	#constant BUTTON_DRAW			=	1
	#constant BUTTON_HOLD			=	2
	#constant BUTTON_EXIT			=	3
	#constant BUTTON_NEW_CARD		=	4
	#constant BUTTON_NEW_GAME		=	5
	
	
	
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
	
	// Kontrollflags für Button "Neuen Kartendeck für Player"
	
	global CardGameOver 				as integer = 0
		
	global SPlayDrawCdIDCounter		as integer = 0
	global SavePlayerDrawCardID		as integer[53]
	
	global NewCardDeck				as integer[3] = [0,0,0]
	
	global PlayerScore				as integer = 0
	
	global GMaxCard					as integer = 52
	
	global CPUScore					as integer
	
	global backdrop0 				as integer = 0
	global ID_CardsDeckFT 			as integer[52]
	global SPR_CardsDeckFT 			as integer[52]
	global CardsDeckRandom 			as integer[54]
	
	global CardsDeckFT 				as integer[17]
	global CardsDeckX 				as integer[12]
	global CardsDeckY 				as integer[3]
	
	global Zahltreffer 				as string
	global a,b,c 					as integer
	global CardsErrorCode 			as integer
	
	global CoverSheet 				as integer
	global CoverSheetCard 			as integer
		
	global PutFourCards 				as integer[4]
	global CPUSecondsCardShow 		as integer 	= 0
	global CPUFirstCardShow			as integer 	= 	0
		
	global XButton 					as integer
	global YButton 					as integer
	
	global DrawCardNum				as	integer	=	0
	global Push_DrawCardNum			as 	integer	=	0
	
	global BackupNum					as	integer	=	0
	
	global XButton_Move				as	integer	=	0
	global YButton_Move 				as	integer	= 	0
	
	global PlayerCardID				as	integer	=	0
	global GSetDepthCard				as	integer	=	MAX_DEPTH_CARD
	
	global Max_DrawCardNum 			as 	integer = 0
	
	// Boolean - Werte
	
	global Column_Enable				as	integer 	= 	0
	global DeckButtonBoolean 		as 	integer 	= 	1

	
endfunction
