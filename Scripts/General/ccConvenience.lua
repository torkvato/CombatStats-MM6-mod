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

