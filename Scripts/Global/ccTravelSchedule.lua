-- Travel schedule table as a Seer Notes

if TravelScheduleAutoNote == 1 or TeachersTableAutoNote == 1 or AlchemyRecipesAutoNote == 1 then
    for i=108,116 do
    Party.AutonotesBits[i] = false  -- clear seer messages
    end
end



if TravelScheduleAutoNote == 1 then
    local msg = ""
    msg = msg .. string.format('    \t%11sMON \t%20sTUE \t%29sWED \t%38sTHU \t%47sFRI \t%56sSAT\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('Sor \t%11sIro2\t%20sMis3\t%29sIro2\t%38sMis3\t%47sIro2\t%56sMis3\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('Iro \t%11sSor2\t%20sFH4\t%29sSor2\t%38sSor2\t%47sSor2\t%56sFH4\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('    \t%11sMis2\t%20sSor2\t%29sMis2\t%38s    \t%47sMis2\t%56sSor2\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('    \t%11s   \t%20sBoo3\t%29s    \t%38s    \t%47sBoo3\t%56s\n', '|', '|', '|', '|', '|', '|')

    msg = msg .. string.format('FH \t%11sSC4\t%20sIro4\t%29sMir5\t%38sSC3\t%47sIro4\t%56sMir5\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('    \t%11sBla3\t%20sKri3\t%29sFro3\t%38sBla3\t%47sKri3\t%56sFro3\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('    \t%11sMis4\t%20sSC3\t%29sIro5\t%38sMis4\t%47s    \t%56s\n', '|', '|', '|', '|', '|', '|')

    msg = msg .. string.format('Mis \t%11sIro2\t%20sBoo2\t%29sIro2\t%38sSC3\t%47sIro2\t%56sBoo2\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('    \t%11sSC3\t%20s   \t%29s   \t%38sBoo2\t%47s    \t%56s\n', '|', '|', '|', '|', '|', '|')

    msg = msg .. string.format('SC \t%11sFH4\t%20sFH3\t%29sEel1\t%38sMis3\t%47sFH4\t%56sMis3\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('    \t%11sMis3\t%20s  \t%29s   \t%38sEel2\t%47sFH3\t%56s\n', '|', '|', '|', '|', '|', '|')

    msg = msg .. string.format('Eel \t%11sSC2\t%20s\t%29s\t%38s\t%47s\t%56s\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('Bla \t%11s \t%20sFH3\t%29s\t%38s\t%47sFH3\t%56s\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('Fro\t%11sFH3\t%20s\t%29s\t%38sFH3\t%47s\t%56s\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('Boo \t%11s\t%20sIro4\t%29s\t%38sIro4\t%47s\t%56s\n', '|', '|', '|', '|', '|', '|')
    msg = msg .. string.format('Mir \t%11sFH5\t%20s\t%29s\t%38s\t%47sFH5\t%56s', '|', '|', '|', '|', '|', '|')

    Autonote(':SeerTravelSchedule', 3, msg)
    SuppressSound(true) -- disable annoying ding
    AddAutonote(':SeerTravelSchedule')
    SuppressSound(false)
end
    -- -- s = ""
    -- -- for i=14,255 do
    -- -- s = s .. string.char(i)
    -- -- if (i%40)==0 then s = s .. "\n" end
    -- -- Message(s)

    -- local msg1 = ""
    -- msg1 = msg1 .. "\n\n\n                [Shoals]-[Avlee]"
    -- msg1 = msg1 .. "\n                                   |"
    -- msg1 = msg1 .. "\n[The Pit ]-[Deyja]-[Tularean]  [LandGiants]"
    -- msg1 = msg1 .. "\n                    |              |                  |"
    -- msg1 = msg1 .. "\n[Tatalia ]-[Erathia]-[Harmondale] [Nighon]"
    -- msg1 = msg1 .. "\n                    |              |                  |"
    -- msg1 = msg1 .. "\n[Celeste]-[Bracada]-[Burrows]-[StoneCity]\n\n\n"
    -- Autonote(':SeerWorldMap', 3, msg1)
    -- SuppressSound(true) -- disable annoying ding
    -- AddAutonote(':SeerWorldMap')
    -- SuppressSound(false)
if TeachersTableAutoNote == 1 then

    local msg2 = string.format('\t%36s\n\n','Teachers')
    msg2 = msg2 .. string.format('SWOR\t%13sAXE\t%22sSPEAR\t%32sMACE\t%41sSTAF\t%50sDAGG\t%61sBOW\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. string.format('e Iro\t%13sIro\t%22sMis\t%32sMir\t%41sSor\t%50sIro\t%61sIro\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. string.format('e FH\t%13sMir\t%22sSC\t%32sFro\t%41sMis\t%50sFH\t%61sFro\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. string.format('m Bla\t%13sMir\t%22sMir\t%32sBla\t%41sSC\t%50sFro\t%61sKri\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. '\n'
    msg2 = msg2 .. string.format('FIRE \t%13sAIR\t%22sWATR\t%32sERTH\t%41sSPIRT\t%50sMIND\t%61sBODY\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. string.format('e Sor\t%13sSor\t%22sSor\t%32sSor\t%41sSor\t%50sSor\t%61sSor\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. string.format('e FH\t%13sFH\t%22sFH\t%32sFH\t%41sFH\t%50sFH\t%61sFH\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. string.format('m Mis\t%13sMis\t%22sMis\t%32sMis\t%41sIro\t%50sSC\t%61sSC\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. '\n'
    msg2 = msg2 .. string.format('PLT\t%13sCHN\t%22sLTHR\t%32sSHLD\t%41sBLST\t%50sLIGHT\t%61sDARK\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. string.format('e Iro\t%13sIro\t%22sIro\t%32sIro\t%41sSor\t%50sKri\t%61sBla\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. string.format('e FH\t%13sBoo\t%22sMis\t%32sFH\t%41sEel\t%50sSC\t%61sFro\n', '|', '|', '|', '|', '|', '|')
    msg2 = msg2 .. string.format('m FH\t%13sMir\t%22sFro\t%32sBla\t%41sPar\t%50sEel\t%61sPar\n', '|', '|', '|', '|', '|', '|')    

    Autonote(':SeerTeachers1', 3, msg2)
    SuppressSound(true) -- disable annoying ding
    AddAutonote(':SeerTeachers1')
    SuppressSound(false)

    local msg3 = string.format('\t%36s\n\n','Teachers')
    msg3 = msg3 .. string.format('BB\t%13sMEDT\t%22sPERC\t%32sID.I.\t%41sREP\t%50sDISA\t%61sMERCH\n', '|', '|', '|', '|', '|', '|')
    msg3 = msg3 .. string.format('e Sor\t%13sSor\t%22sSor\t%32sSor\t%41sMis\t%50sIro\t%61sMir\n', '|', '|', '|', '|', '|', '|')
    msg3 = msg3 .. string.format('e Iro\t%13sSC\t%22sBoo\t%32sIro\t%41sSC\t%50sFH\t%61sFH\n', '|', '|', '|', '|', '|', '|')
    msg3 = msg3 .. string.format('m FH\t%13sMis\t%22sMir\t%32sFH\t%41sFro\t%50sFro\t%61sSC\n', '|', '|', '|', '|', '|', '|')
        msg3 = msg3 .. '\n'
    msg3 = msg3 .. string.format('DIPL\t%13sLRNG\t%22s \t%32s \t%41s \t%50s\t%61s \n', '|', '|', '|', '|', '|', '|')
    msg3 = msg3 .. string.format('e IRO\t%13sSor\t%22s\t%32s\t%41s\t%50s\t%61s\n', '|', '|', '|', '|', '|', '|')
    msg3 = msg3 .. string.format('e FH\t%13sIro\t%22s\t%32s\t%41s\t%50s\t%61s\n', '|', '|', '|', '|', '|', '|')
    msg3 = msg3 .. string.format('m Fro\t%13sSC\t%22s\t%32s\t%41s\t%50s\t%61s\n\n\n\n\n\n', '|', '|', '|', '|', '|', '|')
    

    Autonote(':SeerTeachers2', 3, msg3)
    SuppressSound(true) -- disable annoying ding
    AddAutonote(':SeerTeachers2')
    SuppressSound(false)
end
if AlchemyRecipesAutoNote == 1 then
     local msg = string.format('\t%36s\n','Alchemy Recipes')
     msg = msg .. string.format('White\n')
     msg = msg .. string.format('Restoration:GP  Sup.Resistance:GB  Exr.Energy:OY  ')
     msg = msg .. string.format('Heroism:OR  StoneSkin:OB  Sup.Protect:OG  ')
     msg = msg .. string.format('Haste:GY   Bless:PB\n')
     msg = msg .. string.format('Black\n')
     msg = msg .. string.format('Might:ROR  Intellect:BOB  Pers:GPB  Endurance:GOY  ')
     msg = msg .. string.format('Speed:GYR  Accuracy:BPY  Luck:BGP  Rejuv:OYG  ')
     msg = msg .. string.format('Div.Cure:GPO  Div.Magic:GBG  Div.Power:OYP\n\n\n')

    Autonote(':AlchRecipes', 3, msg)
    SuppressSound(true) -- disable annoying ding
    AddAutonote(':AlchRecipes')
    SuppressSound(false)
end
