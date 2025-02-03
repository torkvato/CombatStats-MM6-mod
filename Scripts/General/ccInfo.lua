function events.GameInitialized2()
    schedulenotealreadyadded = false
    Game.GlobalTxt[144] = StrColor(255, 0, 0, Game.GlobalTxt[144])
    Game.GlobalTxt[116] = StrColor(255, 128, 0, Game.GlobalTxt[116])
    Game.GlobalTxt[163] = StrColor(0, 127, 255, Game.GlobalTxt[163])
    Game.GlobalTxt[75] = StrColor(0, 255, 0, Game.GlobalTxt[75])
    Game.GlobalTxt[1] = StrColor(250, 250, 0, Game.GlobalTxt[1])
    Game.GlobalTxt[211] = StrColor(160, 50, 255, Game.GlobalTxt[211])
    Game.GlobalTxt[136] = StrColor(255, 255, 255, Game.GlobalTxt[136])
    Game.GlobalTxt[108] = StrColor(0, 255, 0, Game.GlobalTxt[108])
    Game.GlobalTxt[212] = StrColor(0, 100, 255, Game.GlobalTxt[212])
    Game.GlobalTxt[12] = StrColor(230, 204, 128, Game.GlobalTxt[12])
end

function events.Tick()
    if Game.CurrentCharScreen == 100 and Game.CurrentScreen == 7 then
        local pl = Party[Game.CurrentPlayer]
        local lvl = pl:GetLevel()
        local AC = pl:GetArmorClass()
        local fullHP = pl:GetFullHP()
        local HP = pl.HP

        local might = pl:GetMight()
        local intel = pl:GetIntellect()
        local pers = pl:GetPersonality()
        local endu = pl:GetEndurance()
        local acc = pl:GetAccuracy()
        local speed = pl:GetSpeed()
        local luck = pl:GetLuck()

        -- Stats modifiers
        local addind = string.find(Game.StatsDescriptions[0], '\n')

        if addind then
            Game.StatsDescriptions[0] = string.format("%s\n ToDamage modifier: %d, next limit: %s", string.sub(Game.StatsDescriptions[0], 1, string.find(Game.StatsDescriptions[0], '\n')), Stat2Modifier(might))
            Game.StatsDescriptions[1] = string.format("%s\n Intellect modifier: %d, next limit: %s", string.sub(Game.StatsDescriptions[1], 1, string.find(Game.StatsDescriptions[1], '\n')), Stat2Modifier(intel))
            Game.StatsDescriptions[2] = string.format("%s\n Personality modifier: %d, next limit: %s", string.sub(Game.StatsDescriptions[2], 1, string.find(Game.StatsDescriptions[2], '\n')), Stat2Modifier(pers))
            Game.StatsDescriptions[3] = string.format("%s\n Health modifier: %d, next limit: %s", string.sub(Game.StatsDescriptions[3], 1, string.find(Game.StatsDescriptions[3], '\n')), Stat2Modifier(endu))
            Game.StatsDescriptions[4] = string.format("%s\n ToHit modifier: %d, next limit: %s", string.sub(Game.StatsDescriptions[4], 1, string.find(Game.StatsDescriptions[4], '\n')), Stat2Modifier(acc))
            Game.StatsDescriptions[5] = string.format("%s\n AC and Recovery modifier: %d, next limit: %s", string.sub(Game.StatsDescriptions[5], 1, string.find(Game.StatsDescriptions[5], '\n')), Stat2Modifier(speed))
            Game.StatsDescriptions[6] = string.format("%s\n Resistances modifier: %d, next limit: %s", string.sub(Game.StatsDescriptions[6], 1, string.find(Game.StatsDescriptions[6], '\n')), Stat2Modifier(luck))
        else
            Game.StatsDescriptions[0] = string.format("%s\n ToDamage modifier: %d, next limit: %s", Game.StatsDescriptions[0], Stat2Modifier(might))
            Game.StatsDescriptions[1] = string.format("%s\n Intellect modifier: %d, next limit: %s", Game.StatsDescriptions[1], Stat2Modifier(intel))
            Game.StatsDescriptions[2] = string.format("%s\n Personality modifier: %d, next limit: %s", Game.StatsDescriptions[2], Stat2Modifier(pers))
            Game.StatsDescriptions[3] = string.format("%s\n Health modifier: %d, next limit: %s", Game.StatsDescriptions[3], Stat2Modifier(endu))
            Game.StatsDescriptions[4] = string.format("%s\n ToHit modifier: %d, next limit: %s", Game.StatsDescriptions[4], Stat2Modifier(acc))
            Game.StatsDescriptions[5] = string.format("%s\n AC and Recovery modifier: %s, next limit: %d", Game.StatsDescriptions[5], Stat2Modifier(speed))
            Game.StatsDescriptions[6] = string.format("%s\n Resistances modifier: %d, next limit:                  %s", Game.StatsDescriptions[6], Stat2Modifier(luck))
        end

        -- Resistances
        local Resistances = {}
        local ResistancesPerc = {}
        local R0 = {}

        Resistances[1] = pl:GetFireResistance()
        Resistances[2] = pl:GetElectricityResistance()
        Resistances[3] = pl:GetColdResistance()
        Resistances[4] = pl:GetPoisonResistance()
        Resistances[5] = pl:GetMagicResistance()

        for i = 1, 5 do
            if Resistances[i] > 0 then
                p = 1 - 30 / (30 + Resistances[i] + Stat2Modifier(luck))
            else
                p = 0;
            end
            ResistancesPerc[i] = 100 - math.round(100 * (1 - p) + 50 * (1 - p) * p + 25 * (1 - p) * p ^ 2 + 12.5 * (1 - p) * p ^ 3 + 6.25 * p ^ 4);
            R0[i] = (1 - p) + .5 * (1 - p) * p + .25 * (1 - p) * p ^ 2 + .125 * (1 - p) * p ^ 3 + .0625 * p ^ 4;
        end

        Game.GlobalTxt[87] = StrColor(255, 70, 70,   string.format("Fire\t             %s%%", ResistancesPerc[1]))
        Game.GlobalTxt[71] = StrColor(173, 216, 230, string.format("Elec\t             %s%%", ResistancesPerc[2]))
        Game.GlobalTxt[43] = StrColor(100, 180, 255, string.format("Cold\t             %s%%", ResistancesPerc[3]))
        Game.GlobalTxt[166] = StrColor(0, 250, 0,  string.format("Poison\t             %s%%", ResistancesPerc[4]))
        Game.GlobalTxt[138] = StrColor(160, 50, 255,string.format("Magic\t             %s%%", ResistancesPerc[5]))

        -- --Bad things TODO -ma
        -- --Chance that an enemy will succeed in doing some bad thing to you is 30/(30 + LuckEffect + OtherEffect), where OtherEffect depends on that particular thing:
        -- local msg = StrColor(255, 70, 70,string.format("Bad things chances: Luck+additional stat:\n"))
        -- msg = msg.. string.format("Age, Disease, Sleep (End): %d%%\n",math.round(3000/(30+Stat2Modifier(luck)+Stat2Modifier(endu))))
        -- msg = msg.. string.format("Curse (Pers): - %d%%\n",math.round(3000/(30+Stat2Modifier(luck)+Stat2Modifier(pers))))
        -- msg = msg.. string.format("DrainSP, Dispel(Pers+Int) %d%%\n",math.round( 3000/(30+Stat2Modifier(luck)+(Stat2Modifier(pers)+Stat2Modifier(intel))/2) ))
        -- msg = msg.. string.format("Paralyze,Insane (Mind Res.): %d%%\n",math.round(3000/(30+Stat2Modifier(luck)+MindRes)))
        -- msg = msg.. string.format("Death, Eradication, Poison (Body Res.): %d%%\n",math.round(3000/(30+Stat2Modifier(luck)+BodyRes)))
        -- for i=0,5 do
        -- Game.GlobalTxt2[50+i] = msg
        -- end

        -- Effective HP
        local monAC_LvL = math.min(100, 3 * lvl)
        local monster_hit_chance = (5 + monAC_LvL * 2) / (10 + monAC_LvL * 2 + AC)

        local coeff = 1
        
        local AvoidanceWeights = {Phys = 0.5, Fire=0.05, Electricity=0.05, Cold=0.05, Poison = 0.05, Magic=.30}  -- on the base of full game damage percentages (TKPS party )
 
        local avoidance = coeff * monster_hit_chance * AvoidanceWeights.Phys + R0[1]*AvoidanceWeights.Fire + R0[2]*AvoidanceWeights.Electricity + R0[3]*AvoidanceWeights.Cold + R0[4]*AvoidanceWeights.Poison + R0[5]*AvoidanceWeights.Magic

        local vitality = math.round(0.5*fullHP + 0.5*fullHP/avoidance)  --full HP added to take into account unavoidable damage like Light, Energy and Dark
        

        -- Attack and DPS calculations	
        local dmg_m = 0
        local atk_m = pl:GetMeleeAttack()
        local delay_m = pl:GetAttackDelay()
        local slot = pl.ItemMainHand
        local it0 = (slot ~= 0 and pl.Items[slot])
        if (delay_m < Game.MinMeleeRecoveryTime) and (it0.Number~=65) and (it0.Number~=64) then delay_m = Game.MinMeleeRecoveryTime end  -- MM6 recovery items can push below the min 30 to 27 for melee and even less for blasters
        local recoverycoeff = RecoveryItemsMM6(pl) --Currently items "of Recovery" with 10% recovery improvement are not taken into account in GetAttack Delay
        delay_m = delay_m/recoverycoeff
        

        local meleerange = pl:GetMeleeDamageRangeText()
        local i1 = string.find(meleerange, "-")
        if i1 then
            dmg_m = (string.sub(meleerange, 1, i1 - 1) + string.sub(meleerange, i1 + 1, -1)) / 2
        else
            dmg_m = meleerange
        end

        local hitchance_m = (15 + atk_m * 2) / (30 + atk_m * 2 + monAC_LvL) -- monster AC treated equal to Player Lvl
        -- for i = 0,200 do print(i,Game.GlobalTxt2[i]) end

        local dmg_r = 0
        local atk_r = pl:GetRangedAttack()
        local delay_r = pl:GetAttackDelay(true)
        delay_r = delay_r/recoverycoeff

        local rangedrange = pl:GetRangedDamageRangeText()        
        local i1 = string.find(rangedrange,"-")
        if i1 then dmg_r = (string.sub(rangedrange,1,i1-1) + string.sub(rangedrange,i1+1,-1) )/2 end--(pl:GetRangedDamageMin() + pl:GetRangedDamageMax()) / 2        
        
        local hitchance_r = (15 + atk_r * 2) / (30 + atk_r * 2 + monAC_LvL)

        dmg_m = dmg_m + DaggerTriple(pl)

        -- Weapons element damage
        local slot = pl.ItemMainHand
        local it0 = (slot ~= 0 and pl.Items[slot])
        local slot = pl.ItemExtraHand
        local it1 = (slot ~= 0 and pl.Items[slot])
        local slot = pl.ItemBow
        local it2 = (slot ~= 0 and pl.Items[slot])

        local elem_m = 0
        local elem_r = 0
        if it0 and (it0.Number == 415) then elem_m = 20 end --Hades
        if it0 and (it0.Number == 416) then elem_m = 30 end --Ares
        if it1 and (it1.Number == 415) then elem_m = 20 end --Hades
        if it1 and (it1.Number == 416) then elem_m = 30 end --Ares
        if it2 and (it2.Number == 420) then elem_m = 20 end --Artemis
        

        if it0 and const.bonus2damage[it0.Bonus2] then
            elem_m = elem_m + const.bonus2damage[it0.Bonus2]
        end
        if it1 and const.bonus2damage[it1.Bonus2] then
            elem_m = elem_m + const.bonus2damage[it1.Bonus2]
        end
        if it2 and const.bonus2damage[it2.Bonus2] then
            elem_r = elem_r + const.bonus2damage[it2.Bonus2]
        end

        local dps_m = (dmg_m + elem_m) * hitchance_m / (delay_m / 60)
        local dps_r = (dmg_r + elem_r) * hitchance_r / (delay_r / 60)

        Game.GlobalTxt[47] = string.format("M/R DPS: %s/%s\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", StrColor(255, 0, 0, math.round(dps_m * 10) / 10), StrColor(255, 255, 50, math.round(dps_r * 10) / 10))
        Game.GlobalTxt[172] = string.format("Vit:%s Avoid:%s%%\n\n\n\n\n\n\n\n\n\n\n\n\n\n", StrColor(0, 255, 0, vitality),  StrColor(230, 204, 128,math.round(1000*(1-monster_hit_chance))/10))

    Game.GlobalTxt2[2] = PartyRecordsTxt()
    
    if Keys.IsPressed(const.Keys.ALT) then
        Game.GlobalTxt2[3] = "Full stats since game beginning, [E] for export\n" .. DamageMeterCalculation(vars.damagemeter)
        Game.GlobalTxt2[4] = "Full stats since game beginning, [E] for export\n" .. DamageReceivedCalculation(vars.damagemeter)   
    elseif Keys.IsPressed(const.Keys.CONTROL) then
        Game.GlobalTxt2[3] = string.format("Segment: %s since [R]eset\n", GameTimePassed()) .. DamageMeterCalculation(vars.damagemeter1)
        Game.GlobalTxt2[4] = string.format("Segment: %s since [R]eset\n", GameTimePassed()) .. DamageReceivedCalculation(vars.damagemeter1)  
    else
        Game.GlobalTxt2[3] = string.format("Map: %s, [ALT]-Full, [CTRL]-Segment\n", Game.MapStats[Game.Map.MapStatsIndex].Name) .. DamageMeterCalculation(mapvars.damagemeter)
        Game.GlobalTxt2[4] = string.format("Map: %s, [ALT]-Full, [CTRL]-Segment\n", Game.MapStats[Game.Map.MapStatsIndex].Name) .. DamageReceivedCalculation(mapvars.damagemeter)  
    end
    textsupdated = true
end

    if Game.CurrentCharScreen == 101 and Game.CurrentScreen == 7 and textsupdated then
        Game.GlobalTxt[138] = 'Magic'
        textsupdated = false
    end

    if Game.CurrentCharScreen == 101 and Game.CurrentScreen == 7 and SkillTooltipsEnabled then
        local pl = Party[Game.CurrentPlayer]
        ---In MM6 the condition for successful disarming is Lock*5 < player:GetDisarmTrapTotalSkill() + math.random(0, 9). In MM7+ the condition is Lock*2 <= player:GetDisarmTrapTotalSkill(). 
        -- Skill-5*Lock:> 0 .... diff 0 - 90% diff1 - 80% diff 8-10% diff 9 - 0% success
        local ch = 9-(5*Game.MapStats[Game.Map.MapStatsIndex].Lock - pl:GetDisarmTrapTotalSkill());
        if ch>10 then ch = 10 end
        if ch<0 then ch = 0 end
        local msg = StrColor(255, 255, 0,string.format("\nEffective Skill: %d, Map Requirements: %d, Success chance: %d%%",pl:GetDisarmTrapTotalSkill(), 5*Game.MapStats[Game.Map.MapStatsIndex].Lock, ch*10))
        local sd =  Game.SkillDescriptions[const.Skills.DisarmTraps]
        local addind = string.find(sd, '\n')        
        if addind then
            Game.SkillDescriptions[const.Skills.DisarmTraps] = string.sub(sd, 1, string.find(sd, '\n')) .. msg            
        else
            Game.SkillDescriptions[const.Skills.DisarmTraps] = sd .. msg           
        end

        local msg = StrColor(255, 255, 0,string.format("\nMerchant price changes: %d%%",pl:GetMerchantTotalSkill()))
        sd =  Game.SkillDescriptions[const.Skills.Merchant]
        local addind = string.find(sd, '\n')        
        if addind then
            Game.SkillDescriptions[const.Skills.Merchant] = string.sub(sd, 1, string.find(sd, '\n')) .. msg            
        else
            Game.SkillDescriptions[const.Skills.Merchant] = sd.. msg           
        end

        local lrn
        local lm
        lrn, lm = SplitSkill(pl.Skills[const.Skills.Learning])
        lrn = 9+lrn * lm
        if Party.HasNPCProfession(const.NPCProfession.Scholar) then lrn = lrn + 5 end
        if Party.HasNPCProfession(const.NPCProfession.Teacher) then lrn = lrn + 10 end
        if Party.HasNPCProfession(const.NPCProfession.Instructor) then lrn = lrn + 15 end
        local msg = StrColor(255, 255, 0,string.format("\nTotal experience bonus: %d%%",lrn))
        sd =  Game.SkillDescriptions[const.Skills.Learning]
        local addind = string.find(sd, '\n')        
        if addind then
            Game.SkillDescriptions[const.Skills.Learning] = string.sub(sd, 1, string.find(sd, '\n')) .. msg            
        else
            Game.SkillDescriptions[const.Skills.Learning] = sd.. msg           
        end
    end
end

function Stat2Modifier(stat)
    local StatsLimitValues = {0, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 25, 30, 35, 40, 50, 75, 100, 125, 150, 175, 200, 225, 250, 275, 300, 350, 400, 500}
    local StatsEffectsValues = {-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 25, 30}
    local found
    local next
    for i1 = #StatsLimitValues, 1, -1 do
        if StatsLimitValues[i1] <= stat then
            found = StatsEffectsValues[i1]
            next = StatsLimitValues[i1+1]
            break
        end
    end
    next = next or "Max"
    return found, next
end


function DaggerTriple(pl)
    local extradamage = 0
    local sdagger,mdagger = SplitSkill(pl.Skills[const.Skills.Dagger])
    --TODO
    -- if Party.HasNPCProfession(const.NPCProfession.Scholar) then lrn = lrn + 5 end
    -- if Party.HasNPCProfession(const.NPCProfession.Teacher) then lrn = lrn + 10 end
    -- if Party.HasNPCProfession(const.NPCProfession.Instructor) then lrn = lrn + 15 end
    if mdagger>=3 then--master or GM
        if pl.ItemMainHand>0 then 
			mh = pl.Items[pl.ItemMainHand]
        -- Skill% chance for triple base damage (double extra base)
			if mh:T().Skill ==  const.Skills.Dagger then
				extradamage = sdagger / 100 * 2 * (mh:T().Mod2 + (mh:T().Mod1DiceCount + mh:T().Mod1DiceCount * mh:T().Mod1DiceSides)/2)
			end
		end
		
        if pl.ItemExtraHand > 0 then 
			eh = pl.Items[pl.ItemExtraHand]
			if eh:T().Skill ==  const.Skills.Dagger then
				extradamage = extradamage + sdagger / 100 * 2 * (eh:T().Mod2 + (eh:T().Mod1DiceCount + eh:T().Mod1DiceCount * eh:T().Mod1DiceSides)/2)
			end
        end
    end
    return extradamage
end

function RecoveryItemsMM6(pl)
    coeff = 1
    local Bonus2Rec = 17 -- SpcItems index for "Recovery"
    for slot = 0, 15 do
        if pl.EquippedItems[slot] > 0 then
            if pl.Items[pl.EquippedItems[slot]].Bonus2 == Bonus2Rec then
                coeff = 1.1
                break
            end
        end
    end
return coeff
end


function GameTimePassed()
local gameminutes = math.floor((Game.Time - vars.timestamps[0].SegmentStart)/const.Minute)
local days = math.floor(gameminutes/60/24)    
local hours = math.floor((gameminutes%(60*24))/60)
local mins = gameminutes%60
return string.format("%dd%02dh%02dm",days,hours,mins)
end


function get_key_for_value(t, value)
    for k, v in pairs(t) do
        if v == value then
            return k
        end
    end
    return nil
end

function pt(tbl)
    local msg = "{"
    for k, v in pairs(tbl) do
        msg = msg .. tostring(k) .. " = "
        if type(v) == "table" then
            pt(v)
        else
            msg = msg .. tostring(v)
        end
        msg = msg .. ", "
    end
    msg = msg .. "}"
    print(msg)
end

function ftable(vars)
	local file = io.open('debugout.txt','a')
	for k,v in pairs(vars) do
		file:write(tostring(k) .. ' ' .. tostring(v) .. '\n')
	end
	file:write('\n')
	file:close()
end

-- function events.Action(t)
-- 		Game.ShowStatusText("t.Action" .. t.Action)
-- end

-- > a:GetMeleeDamageMin() > a:GetMeleeDamageMax()

-- file = io.open("test.txt", "w")
-- for i=1,400 do
-- 	file:write(string.format("%d - %s\n",i,Game.GlobalTxt[i]))
-- end
-- file:close()
-- 587 - Attack Bonus
-- 588 - Attack Damage
-- 589 - Shoot Bonus
-- 590 - Shoot Damage
-- Game.GlobalTxt[47]="Condition"
-- Game.GlobalTxt[172]="Quick Spell"

-- for k,v in pairs(tab) do
-- print(k)
-- end
-- Party[Game.CurrentPlayer].MightBase
-- mainhand = Party[Game.CurrentPlayer].Items[Party[Game.CurrentPlayer].ItemMainHand]

-- for i=0,Game.SpcItemsTxt.High do print(i, Game.SpcItemsTxt[i].NameAdd, Game.SpcItemsTxt[i].Lvl) end

-- for i=0,Game.SpcItemsTxt.High do  Game.SpcItemsTxt[i].ChanceForSlot[2] = 0 end Game.SpcItemsTxt[57].ChanceForSlot[2] = 250

-- 0	of Protection	1
-- 1	of The Gods	3
-- 2	of Carnage	3
-- 3	of Cold	0
-- 4	of Frost	2
-- 5	of Ice	3
-- 6	of Sparks	0
-- 7	of Lightning	2
-- 8	of Thunderbolts	3
-- 9	of Fire	0
-- 10	of Flame	2
-- 11	of Infernos	3
-- 12	of Poison	0
-- 13	of Venom	2
-- 14	of Acid	3
-- 15	Vampiric	3
-- 16	of Recovery	1
-- 17	of Immunity	2
-- 18	of Sanity	2
-- 19	of Freedom	3
-- 20	of Antidotes	2
-- 21	of Alarms	1
-- 22	of The Medusa	3
-- 23	of Force	0
-- 24	of Power	3
-- 25	of Air Magic	3
-- 26	of Body Magic	3
-- 27	of Dark Magic	3
-- 28	of Earth Magic	3
-- 29	of Fire Magic	3
-- 30	of Light Magic	3
-- 31	of Mind Magic	3
-- 32	of Spirit Magic	3
-- 33	of Water Magic	3
-- 34	of Thievery	1
-- 35	of Shielding	1
-- 36	of Regeneration	1
-- 37	of Mana	1
-- 38	Demon Slayer	0
-- 39	Dragon Slayer	0
-- 40	of Darkness	3
-- 41	of Doom	1
-- 42	of Earth	3
-- 43	of Life	3
-- 44	Rogues	0
-- 45	of The Dragon	3
-- 46	of The Eclipse	3
-- 47	of The Golem	2
-- 48	of The Moon	2
-- 49	of The Phoenix	3
-- 50	of The Sky	3
-- 51	of The Stars	2
-- 52	of The Sun	2
-- 53	of The Troll	2
-- 54	of The Unicorn	2
-- 55	Warriors	0
-- 56	Wizards	0
-- 57	Antique	1
-- 58	of Swiftness	1