function events.KeyDown(t)
    if Game.CurrentScreen == 0 and t.Key == ID_MonsterButton then
           local z = Mouse:GetTarget()
     if z.Kind == 3 then
        local msg=""
          local mon = Game.MonstersTxt[z:Get().Id]
          local monName = mon.Name
          msg = msg..string.format("%s(%s)\n",monName,mon.Level)
          msg = msg..string.format("Health:%s, AC: %s, Exp: %s, Recovery: %s\n",mon.FullHP, mon.ArmorClass, mon.Exp,mon.AttackRecovery)

          local function res2perc(res)
            p = 1 - 30 / (30 + res)
            return 100 - math.round(100 * (1 - p) + 50 * (1 - p) * p + 25 * (1 - p) * p ^ 2 + 12.5 * (1 - p) * p ^ 3 + 6.25 * p ^ 4);
          end

          
          msg = msg .. StrColor(const.DamageColor.Fire[1],const.DamageColor.Fire[2],const.DamageColor.Fire[3],"Fire:") .. string.format("\t%16s%%\n", res2perc(mon.Resistances[const.Damage.Fire]))
          msg = msg .. StrColor(const.DamageColor.Elec[1],const.DamageColor.Elec[2],const.DamageColor.Phys[3],"Elec:") .. string.format("\t%16s%%\n", res2perc(mon.Resistances[const.Damage.Elec]))      
          msg = msg .. StrColor(const.DamageColor.Cold[1],const.DamageColor.Cold[2],const.DamageColor.Cold[3],"Cold:") .. string.format("\t%16s%%\n", res2perc(mon.Resistances[const.Damage.Cold]))
          msg = msg .. StrColor(const.DamageColor.Poison[1],const.DamageColor.Poison[2],const.DamageColor.Poison[3],"Poison:") .. string.format("\t%16s%%\n", res2perc(mon.Resistances[const.Damage.Poison]))
          msg = msg .. StrColor(const.DamageColor.Magic[1],const.DamageColor.Magic[2],const.DamageColor.Magic[3],"Magic:") .. string.format("\t%16s%%\n", res2perc(mon.Resistances[const.Damage.Magic]))
          msg = msg .. StrColor(const.DamageColor.Phys[1],const.DamageColor.Phys[2],const.DamageColor.Phys[3],"Phys:") .. string.format("\t%16s%%", res2perc(mon.Resistances[const.Damage.Phys]))
        Message(msg)
     end

    end
end

function events.Tick()

    -- Shared ID item
    if Game.CurrentScreen == 7 and Game.CurrentCharScreen == 103 and not (id_item_party) and Keys.IsPressed(const.Keys.RBUTTON) and SharedIdentifyItem == 1 then
        id_item_party = true
        local s = const.Skills.IdentifyItem
        local maxskill = 0
        for _, pl in Party do
            if (pl.Eradicated + pl.Dead + pl.Stoned + pl.Paralyzed + pl.Unconscious + pl.Asleep) == 0 then
                local sk = pl.Skills[s]
                if maxskill < sk then
                    maxskill = sk
                end
            end
        end
        id_item_skill_saved = {
            [0] = Party[0].Skills[s],
            [1] = Party[1].Skills[s],
            [2] = Party[2].Skills[s],
            [3] = Party[3].Skills[s]
        }
        Party[Game.CurrentPlayer].Skills[s] = maxskill -- in mm6 there are no repair and id skill bonuses
    elseif not (Keys.IsPressed(const.Keys.RBUTTON)) and id_item_party then
        id_item_party = false
        Party[0].Skills[const.Skills.IdentifyItem] = id_item_skill_saved[0]
        Party[1].Skills[const.Skills.IdentifyItem] = id_item_skill_saved[1]
        Party[2].Skills[const.Skills.IdentifyItem] = id_item_skill_saved[2]
        Party[3].Skills[const.Skills.IdentifyItem] = id_item_skill_saved[3]
    end

    -- Shared Repair
    if Game.CurrentScreen == 7 and Game.CurrentCharScreen == 103 and not (repair_party) and Keys.IsPressed(const.Keys.RBUTTON) and SharedRepair == 1 then
        repair_party = true
        local s = const.Skills.Repair
        local maxskill = 0
        for _, pl in Party do
            if (pl.Eradicated + pl.Dead + pl.Stoned + pl.Paralyzed + pl.Unconscious + pl.Asleep) == 0 then
                local sk = pl.Skills[s]
                if maxskill < sk then
                    maxskill = sk
                end
            end
        end
        repair_skill_saved = {
            [0] = Party[0].Skills[s],
            [1] = Party[1].Skills[s],
            [2] = Party[2].Skills[s],
            [3] = Party[3].Skills[s]
        }
        Party[Game.CurrentPlayer].Skills[s] = maxskill -- in mm6 there are no repair and id skill bonuses
    elseif not (Keys.IsPressed(const.Keys.RBUTTON)) and repair_party then
        repair_party = false
        Party[0].Skills[const.Skills.Repair] = repair_skill_saved[0]
        Party[1].Skills[const.Skills.Repair] = repair_skill_saved[1]
        Party[2].Skills[const.Skills.Repair] = repair_skill_saved[2]
        Party[3].Skills[const.Skills.Repair] = repair_skill_saved[3]
    end

end

