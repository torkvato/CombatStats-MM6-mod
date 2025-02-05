function events.Tick()
    if Game.CurrentScreen == const.Screens.SpellBook then

        local function UpdMsg(id, m, dmg)
            if m > 0 then
                local pos = string.find(Game.SpellsTxt[id].Description, '\n')
                local delay = Game.Spells[id].Delay[m] / RecoveryItemsMM6(Party[Game.CurrentPlayer]) -- in vanilla MM6 speed and Haste do not affect recovery, but Recovery Items DO(!)
                local msg = string.format("Dmg: %s DPM: %.1f DPS: %.1f", dmg, dmg / Game.Spells[id].SpellPoints[m], 60 * dmg / delay)
                if pos then
                    Game.SpellsTxt[id].Description = string.sub(Game.SpellsTxt[id].Description, 1, pos) .. '\n' .. StrColor(230, 230, 0, msg)
                else
                    Game.SpellsTxt[id].Description = Game.SpellsTxt[id].Description .. '\n' .. StrColor(230, 230, 0, msg)
                end
            end
        end

        local pl = Party[Game.CurrentPlayer]
        local dmg, dpm, id
        local s, m = GetMagicSkill(pl, const.Skills.Fire)
        UpdMsg(4, m, (1 + 4) / 2 * s) -- Fire Bolt
        UpdMsg(6, m, (1 + 6) / 2 * s) -- Fire Ball
        UpdMsg(7, m, 6 + s) -- Ring of Fire
        UpdMsg(8, m, (4 + 2 * s) * (3 + (m - 1) * 2)) -- Blast
        UpdMsg(9, m, (8 + s) * (8 + (m - 1) * 2)) -- Met Shower
        UpdMsg(10, m, 12 + s) -- Inferno
        UpdMsg(11, m, 15 + (1 + 15) / 2 * s) -- Incinerate
        local s, m = GetMagicSkill(pl, const.Skills.Air)
        UpdMsg(15, m, (2 + 1 * s) * (3 + (m - 1) * 2)) -- Sparks
        UpdMsg(18, m, (1 + 8) / 2 * s) -- Lighting Bolt
        UpdMsg(20, m, 10 + (1 + 10) / 2 * s) -- Implosion
        UpdMsg(21, m, (20 + 1 * s) * (8 + (m - 1) * 4)) -- Starburst
        local s, m = GetMagicSkill(pl, const.Skills.Water)
        UpdMsg(26, m, (2 + 1.5 * s) * (1 + (m - 1) * 2)) -- Poison Spray
        UpdMsg(28, m, 4 * s) -- Ice Bolt           
        UpdMsg(30, m, 9 + 5 * s) -- Acid burst
        local s, m = GetMagicSkill(pl, const.Skills.Dark)
        UpdMsg(90, m, 25 + (1 + 10) / 2 * s) -- Toxic
        UpdMsg(92, m, (6 + (1 + 6) / 2 * s) * (3 + (m - 1) * 2)) -- Shrapmetal          
        UpdMsg(97, m, (1 + 25) / 2 * s) -- DragonBreath
    end
end

function GetMagicSkill(pl, skill)
    local s, m = SplitSkill(pl.Skills[skill])
    if s > 0 then
        if Party.HasNPCProfession(const.NPCProfession.Apprentice) then
            s = s + 2
        end
        if Party.HasNPCProfession(const.NPCProfession.Mystic) then
            s = s + 3
        end
        if Party.HasNPCProfession(const.NPCProfession.SpellMaster) then
            s = s + 4
        end
    end
    return s, m
end

-- 1	Torch Light
-- 2	Flame Arrow
-- 3	Protection from Fire
-- 4	Fire Bolt
-- 5	Haste
-- 6	Fireball
-- 7	Ring of Fire
-- 8	Fire Blast
-- 9	Meteor Shower
-- 10	Inferno
-- 11	Incinerate
-- 12	Wizard Eye
-- 13	Static Charge
-- 14	Protection from Electricity
-- 15	Sparks
-- 16	Feather Fall
-- 17	Shield
-- 18	Lightning Bolt
-- 19	Jump
-- 20	Implosion
-- 21	Fly
-- 22	Starburst
-- 23	Awaken
-- 24	Cold Beam
-- 25	Protection from Cold
-- 26	Poison Spray
-- 27	Water Walk
-- 28	Ice Bolt
-- 29	Enchant Item
-- 30	Acid Burst
-- 31	Town Portal
-- 32	Ice Blast
-- 33	Lloyd's Beacon
-- 34	Stun
-- 35	Magic Arrow
-- 36	Protection from Magic
-- 37	Deadly Swarm
-- 38	Stone Skin
-- 39	Blades
-- 40	Stone to Flesh
-- 41	Rock Blast
-- 42	Turn to Stone
-- 43	Death Blossom
-- 44	Mass Distortion
-- 45	Spirit Arrow
-- 46	Bless
-- 47	Healing Touch
-- 48	Lucky Day
-- 49	Remove Curse
-- 50	Guardian Angel
-- 51	Heroism
-- 52	Turn Undead
-- 53	Raise Dead
-- 54	Shared Life
-- 55	Resurrection
-- 56	Meditation
-- 57	Remove Fear
-- 58	Mind Blast
-- 59	Precision
-- 60	Cure Paralysis
-- 61	Charm
-- 62	Mass Fear
-- 63	Feeblemind
-- 64	Cure Insanity
-- 65	Psychic Shock
-- 66	Telekinesis
-- 67	Cure Weakness
-- 68	First Aid
-- 69	Protection from Poison
-- 70	Harm
-- 71	Cure Wounds
-- 72	Cure Poison
-- 73	Speed
-- 74	Cure Disease
-- 75	Power
-- 76	Flying Fist
-- 77	Power Cure
-- 78	Create Food
-- 79	Golden Touch
-- 80	Dispel Magic
-- 81	Slow
-- 82	Destroy Undead
-- 83	Day of the Gods
-- 84	Prismatic Light
-- 85	Hour of Power
-- 86	Paralyze
-- 87	Sun Ray
-- 88	Divine Intervention
-- 89	Reanimate
-- 90	Toxic Cloud
-- 91	Mass Curse
-- 92	Shrapmetal
-- 93	Shrinking Ray
-- 94	Day of Protection
-- 95	Finger of Death
-- 96	Moon Ray
-- 97	Dragon Breath
-- 98	Armageddon
-- 99	Dark Containment
