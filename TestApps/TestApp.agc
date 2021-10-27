
state = 5





do

select 1
    
    case (state >= 0 and state =< 5)
    
            print ( "state is 1 - 10" )
    
    endcase

    case (state >= 6 and state < 10)
    	
    	print ( "state is 11 - 13" )

    endcase
    
endselect


	print("Test")
	Sync ()

loop