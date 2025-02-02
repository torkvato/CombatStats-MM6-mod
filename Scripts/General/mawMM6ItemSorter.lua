-- Borrowed from MAW with minor changes
function events.KeyDown(t)
    if Game.CurrentScreen == const.Screens.Inventory and Game.CurrentCharScreen == const.CharScreens.Inventory then
        if t.Key == PlayerInventorySortButton then
            sortInventory(false)
            Game.ShowStatusText("Inventory sorted")
        elseif t.Key == PartyInventorySortButton then
            sortInventory(true)
            Game.ShowStatusText("All inventories have been sorted")
        elseif t.Key == AlchemyPlayerSetButton then
            vars.alchemyPlayer = vars.alchemyPlayer or -1
            if vars.alchemyPlayer == Game.CurrentPlayer then
                vars.alchemyPlayer = -1
                Game.ShowStatusText("No alchemy preference when sorting")
            else
                vars.alchemyPlayer = Game.CurrentPlayer
                Game.ShowStatusText(Party[Game.CurrentPlayer].Name .. " will now take alchemy items when sorting")
            end
        elseif t.Key == IdentifyPlayerSetButton then
            vars.identifyPlayer = vars.identifyPlayer or -1
            if vars.identifyPlayer == Game.CurrentPlayer then
                vars.identifyPlayer = -1
                Game.ShowStatusText("No unidentified items preference when sorting")
            else
                vars.identifyPlayer = Game.CurrentPlayer
                Game.ShowStatusText(Party[Game.CurrentPlayer].Name .. " will now take unidentified items when sorting")
            end

        end
    end
end

function sortInventory(all)
	local lastPlayer = Game.CurrentPlayer
    local itemList = {}
    local j = 0
    local low, high
    if all then
        low = 0
        high = Party.High
    else
        low = Game.CurrentPlayer
        high = Game.CurrentPlayer
    end

    for i = low, high do
        local pl = Party[i]

        removeList = {}
        for i = 0, 125 do
            if pl.Inventory[i] > 0 then
                if pl.Items[pl.Inventory[i]].BodyLocation == 0 then
                    removeList[-i - 1] = true
                end
                local it = pl.Items[pl.Inventory[i]]
                if it.Number > 0 then
                    j = j + 1
                    itemList[j] = {}
                    itemList[j]["Bonus"] = it.Bonus
                    itemList[j]["Bonus2"] = it.Bonus2
                    itemList[j]["BonusExpireTime"] = it.BonusExpireTime
                    itemList[j]["BonusStrength"] = it.BonusStrength
                    itemList[j]["Broken"] = it.Broken
                    itemList[j]["Charges"] = it.Charges
                    itemList[j]["Condition"] = it.Condition
                    itemList[j]["Hardened"] = it.Hardened
                    itemList[j]["Identified"] = it.Identified
                    itemList[j]["MaxCharges"] = it.MaxCharges
                    itemList[j]["Number"] = it.Number
                    itemList[j]["Owner"] = it.Owner
                    itemList[j]["Refundable"] = it.Refundable
                    itemList[j]["Stolen"] = it.Stolen
                    itemList[j]["TemporaryBonus"] = it.TemporaryBonus
                    itemList[j]["size"] = itemSizeMap[it.Number][2]
                    if itemList[j]["size"] == 1 and itemSizeMap[it.Number][1] > 1 then
                        itemList[j]["size"] = 1.5
                    end
                    pl.Inventory[i] = 0
                    it.Number = 0
                end
            end
        end

        for i = 0, 125 do
            if removeList[pl.Inventory[i]] then
                pl.Inventory[i] = 0
            end
        end

        vars.alchemyPlayer = vars.alchemyPlayer or -1
        vars.identifyPlayer = vars.identifyPlayer or -1
        table.sort(itemList, function(a, b)

            if vars.identifyPlayer >= 0 and (not (a["Identified"]) or not (b["Identified"])) then -- Ensure that Unidentified items go first, even before alchemy
                local aa = not (a["Identified"]) == true and 1 or not (a["Identified"]) == false and 0
                local bb = not (b["Identified"]) == true and 1 or not (b["Identified"]) == false and 0
                return aa * a["size"] > bb * b["size"]
            end

            if vars.alchemyPlayer >= 0 then
				
                -- Sorting according to alchemyItemsOrder
                local indexA = table.find(alchemyItemsOrder, a["Number"])
                local indexB = table.find(alchemyItemsOrder, b["Number"])
                if indexA and indexB then -- If both items are in the list
                    return indexA < indexB
                elseif indexA or indexB then -- If only one item is in the list, it goes first
                    return indexA ~= nil
                end

                -- Special sorting for alchemy items
                local a0 = a["Number"] >= 160 and a["Number"] < 196
                local b0 = b["Number"] >= 160 and b["Number"] < 196
                if a0 or b0 then
                    -- Ensure that items in the specified range are sorted first and from biggest to smallest
                    if a0 and b0 then
                        return a["Number"] < b["Number"] -- Both in range, sort descending
                    else
                        return a0 -- Only one in range, it goes first
                    end
                end
            end

            -- Original sorting logic
            if a["size"] == b["size"] then
                -- When sizes are equal, compare by skill
                local skillA = Game.ItemsTxt[a["Number"]].Skill
                local skillB = Game.ItemsTxt[b["Number"]].Skill

                if skillA == skillB then
                    -- If skills are also equal, then sort by item number
                    return a["Number"] < b["Number"]
                else
                    -- Otherwise, sort by skill
                    return skillA < skillB
                end
            else
                -- Primary sort by size
                return a["size"] > b["size"]
            end
        end)

    end

    if itemList[1] then

        alchemy_item_counter = 0
		alchemy_space_counter = 0
        local partynext = {[0] = 1,[1] = 2,[2] = 3,[3] = 2}
        temp_alchemy_player = vars.alchemyPlayer or -1

        for i = 1, #itemList do            
                if (vars.alchemyPlayer >= 0) and (itemList[i].Number >= 160 and itemList[i].Number < 196) then --table.find(alchemyItemsOrder, itemList[i].Number) or
					alchemy_space_counter = alchemy_space_counter + itemList[i].size	
                    alchemy_item_counter = alchemy_item_counter + 1
                    if alchemy_item_counter > (111-1) or alchemy_space_counter>(9*14-2) then
						alchemy_item_counter = 0
						alchemy_space_counter = 0
						temp_alchemy_player = partynext[temp_alchemy_player]   
                        --debug.Message(alchemy_item_counter, alchemy_space_counter)                      
					end
					Game.CurrentPlayer = temp_alchemy_player
                end
            -- if vars.identifyPlayer >= 0 and not (itemList[i].Identified) then
            --     Game.CurrentPlayer = vars.identifyPlayer
            -- end
			
            evt.Add("Items", itemList[i].Number)
            it = Mouse.Item
            it.Bonus = itemList[i].Bonus
            it.Bonus2 = itemList[i].Bonus2
            it.BonusExpireTime = itemList[i].BonusExpireTime
            it.BonusStrength = itemList[i].BonusStrength
            it.Broken = itemList[i].Broken
            it.Charges = itemList[i].Charges
            it.Condition = itemList[i].Condition
            it.Hardened = itemList[i].Hardened
            it.Identified = itemList[i].Identified
            it.MaxCharges = itemList[i].MaxCharges
            it.Owner = itemList[i].Owner
            it.Refundable = itemList[i].Refundable
            it.Stolen = itemList[i].Stolen
            it.TemporaryBonus = itemList[i].TemporaryBonus
            Mouse:ReleaseItem()
			Game.CurrentPlayer = lastPlayer            
        end
        Mouse:ReleaseItem()
    end
    table.clear(itemList)
end

-- Define the alchemyItemsOrder list for reference in sorting

-- Empty, cat, rby RBY RBY
  alchemyItemsOrder = {163, 164, 165, 166, 160, 161, 162, 163}

-- for i=1,Game.ItemsTxt.High do print(i,Game.ItemsTxt[i].Name) end

-- 160	Poppysnaps
-- 161	Phirna Root
-- 162	Widoweeps Berries
-- 163	Potion Bottle
-- 164	Cure Wounds
-- 165	Magic Potion
-- 166	Energy
-- 167	Protection
-- 168	Resistance
-- 169	Cure Poison
-- 170	Supreme Protection
-- 171	Restoration
-- 172	Extreme Energy
-- 173	Super Resistance
-- 174	Heroism
-- 175	Haste
-- 176	Stone Skin
-- 177	Bless
-- 178	Divine Power
-- 179	Divine Cure
-- 180	Divine Magic
-- 181	Essence of Might
-- 182	Essence of Intellect
-- 183	Essence of Personality
-- 184	Essence of Endurance
-- 185	Essence of Accuracy
-- 186	Essence of Speed
-- 187	Essence of Luck
-- 188	Rejuvenation
-- 189	Potion Bottle
-- 190	Potion Bottle
-- 191	Potion Bottle
-- 192	Potion Bottle
-- 193	Potion Bottle
-- 194	Potion Bottle
-- 195	Potion Bottle
-- 196	Potion Bottle

itemEquipStat = {
    [1] = 0,
    [2] = 1,
    [3] = 2,
    [4] = 3,
    [5] = 4,
    [6] = 5,
    [7] = 6,
    [8] = 7,
    [9] = 8,
    [10] = 9,
    [11] = 10,
    [12] = 11,
    [13] = 12,
    [14] = 13,
    [15] = 14,
    [16] = 15
}
itemSizeMap = {
    [1]={1,6},
    [2]={1,6},
    [3]={1,6},
    [4]={1,6},
    [5]={1,6},
    [6]={2,7},
    [7]={2,7},
    [8]={1,7},
    [9]={1,6},
    [10]={1,6},
    [11]={1,6},
    [12]={1,6},
    [13]={1,6},
    [14]={1,6},
    [15]={1,3},
    [16]={1,4},
    [17]={1,4},
    [18]={1,3},
    [19]={1,4},
    [20]={1,5},
    [21]={1,5},
    [22]={1,4},
    [23]={1,3},
    [24]={2,5},
    [25]={1,4},
    [26]={1,4},
    [27]={2,5},
    [28]={2,6},
    [29]={1,8},
    [30]={2,8},
    [31]={1,9},
    [32]={1,9},
    [33]={1,9},
    [34]={1,9},
    [35]={1,9},
    [36]={2,9},
    [37]={2,9},
    [38]={2,9},
    [39]={2,9},
    [40]={2,9},
    [41]={2,9},
    [42]={1,8},
    [43]={1,7},
    [44]={1,7},
    [45]={1,6},
    [46]={2,7},
    [47]={2,5},
    [48]={3,5},
    [49]={2,5},
    [50]={1,4},
    [51]={1,5},
    [52]={2,5},
    [53]={1,4},
    [54]={2,4},
    [55]={2,5},
    [56]={2,5},
    [57]={1,4},
    [58]={1,5},
    [59]={1,6},
    [60]={1,5},
    [61]={1,7},
    [62]={1,9},
    [63]={2,9},
    [64]={1,3},
    [65]={2,7},
    [66]={2,4},
    [67]={3,3},
    [68]={3,5},
    [69]={4,4},
    [70]={3,5},
    [71]={3,5},
    [72]={3,5},
    [73]={4,5},
    [74]={4,5},
    [75]={4,5},
    [76]={4,6},
    [77]={4,6},
    [78]={4,6},
    [79]={3,5},
    [80]={3,4},
    [81]={3,4},
    [82]={3,3},
    [83]={3,3},
    [84]={2,2},
    [85]={2,2},
    [86]={2,3},
    [87]={3,3},
    [88]={2,3},
    [89]={1,1},
    [90]={2,2},
    [91]={2,2},
    [92]={2,2},
    [93]={2,2},
    [94]={2,1},
    [95]={2,1},
    [96]={2,2},
    [97]={2,1},
    [98]={1,1},
    [99]={1,1},
    [100]={2,1},
    [101]={2,1},
    [102]={2,1},
    [103]={2,1},
    [104]={2,1},
    [105]={2,1},
    [106]={2,1},
    [107]={2,1},
    [108]={2,1},
    [109]={3,1},
    [110]={1,3},
    [111]={1,3},
    [112]={1,3},
    [113]={1,3},
    [114]={1,3},
    [115]={2,2},
    [116]={2,2},
    [117]={2,2},
    [118]={2,2},
    [119]={2,2},
    [120]={1,1},
    [121]={1,1},
    [122]={1,1},
    [123]={1,1},
    [124]={1,1},
    [125]={1,1},
    [126]={1,1},
    [127]={1,1},
    [128]={1,1},
    [129]={1,1},
    [130]={1,2},
    [131]={1,3},
    [132]={1,2},
    [133]={1,2},
    [134]={1,2},
    [135]={1,5},
    [136]={1,5},
    [137]={1,5},
    [138]={1,5},
    [139]={1,5},
    [140]={1,6},
    [141]={1,6},
    [142]={1,6},
    [143]={1,6},
    [144]={1,6},
    [145]={1,5},
    [146]={1,5},
    [147]={1,5},
    [148]={1,5},
    [149]={1,5},
    [150]={1,6},
    [151]={1,6},
    [152]={1,6},
    [153]={1,6},
    [154]={1,6},
    [155]={1,5},
    [156]={1,5},
    [157]={1,5},
    [158]={1,5},
    [159]={1,5},
    [160]={1,1},
    [161]={1,1},
    [162]={1,1},
    [163]={1,2},
    [164]={1,2},
    [165]={1,2},
    [166]={1,2},
    [167]={1,2},
    [168]={1,2},
    [169]={1,2},
    [170]={1,2},
    [171]={1,2},
    [172]={1,2},
    [173]={1,2},
    [174]={1,2},
    [175]={1,2},
    [176]={1,2},
    [177]={1,2},
    [178]={1,2},
    [179]={1,2},
    [180]={1,2},
    [181]={1,2},
    [182]={1,2},
    [183]={1,2},
    [184]={1,2},
    [185]={1,2},
    [186]={1,2},
    [187]={1,2},
    [188]={1,2},
    [189]={1,2},
    [190]={1,2},
    [191]={1,2},
    [192]={1,2},
    [193]={1,2},
    [194]={1,2},
    [195]={1,2},
    [196]={1,2},
    [197]={2,1},
    [198]={3,1},
    [199]={3,2},
    [200]={2,1},
    [201]={2,1},
    [202]={2,1},
    [203]={2,1},
    [204]={2,1},
    [205]={2,1},
    [206]={2,1},
    [207]={2,1},
    [208]={2,1},
    [209]={2,1},
    [210]={2,1},
    [211]={2,1},
    [212]={2,1},
    [213]={2,1},
    [214]={2,1},
    [215]={2,1},
    [216]={2,1},
    [217]={2,1},
    [218]={2,1},
    [219]={2,1},
    [220]={2,1},
    [221]={2,1},
    [222]={2,1},
    [223]={2,1},
    [224]={2,1},
    [225]={2,1},
    [226]={2,1},
    [227]={2,1},
    [228]={2,1},
    [229]={2,1},
    [230]={2,1},
    [231]={2,1},
    [232]={2,1},
    [233]={2,1},
    [234]={2,1},
    [235]={2,1},
    [236]={2,1},
    [237]={2,1},
    [238]={2,1},
    [239]={2,1},
    [240]={2,1},
    [241]={2,1},
    [242]={2,1},
    [243]={2,1},
    [244]={2,1},
    [245]={2,1},
    [246]={2,1},
    [247]={2,1},
    [248]={2,1},
    [249]={2,1},
    [250]={2,1},
    [251]={2,1},
    [252]={2,1},
    [253]={2,1},
    [254]={2,1},
    [255]={2,1},
    [256]={2,1},
    [257]={2,1},
    [258]={2,1},
    [259]={2,1},
    [260]={2,1},
    [261]={2,1},
    [262]={2,1},
    [263]={2,1},
    [264]={2,1},
    [265]={2,1},
    [266]={2,1},
    [267]={2,1},
    [268]={2,1},
    [269]={2,1},
    [270]={2,1},
    [271]={2,1},
    [272]={2,1},
    [273]={2,1},
    [274]={2,1},
    [275]={2,1},
    [276]={2,1},
    [277]={2,1},
    [278]={2,1},
    [279]={2,1},
    [280]={2,1},
    [281]={2,1},
    [282]={2,1},
    [283]={2,1},
    [284]={2,1},
    [285]={2,1},
    [286]={2,1},
    [287]={2,1},
    [288]={2,1},
    [289]={2,1},
    [290]={2,1},
    [291]={2,1},
    [292]={2,1},
    [293]={2,1},
    [294]={2,1},
    [295]={2,1},
    [296]={2,1},
    [297]={2,1},
    [299]={2,1},
    [300]={2,2},
    [301]={2,2},
    [302]={2,2},
    [303]={2,2},
    [304]={2,2},
    [305]={2,2},
    [306]={2,2},
    [307]={2,2},
    [308]={2,2},
    [309]={2,2},
    [310]={2,2},
    [311]={2,2},
    [312]={2,2},
    [313]={2,2},
    [314]={2,2},
    [315]={2,2},
    [316]={2,2},
    [317]={2,2},
    [318]={2,2},
    [319]={2,2},
    [320]={2,2},
    [321]={2,2},
    [322]={2,2},
    [323]={2,2},
    [324]={2,2},
    [325]={2,2},
    [326]={2,2},
    [327]={2,2},
    [328]={2,2},
    [329]={2,2},
    [330]={2,2},
    [331]={2,2},
    [332]={2,2},
    [333]={2,2},
    [334]={2,2},
    [335]={2,2},
    [336]={2,2},
    [337]={2,2},
    [338]={2,2},
    [339]={2,2},
    [340]={2,2},
    [341]={2,2},
    [342]={2,2},
    [343]={2,2},
    [344]={2,2},
    [345]={2,2},
    [346]={2,2},
    [347]={2,2},
    [348]={2,2},
    [349]={2,2},
    [350]={2,2},
    [351]={2,2},
    [352]={2,2},
    [353]={2,2},
    [354]={2,2},
    [355]={2,2},
    [356]={2,2},
    [357]={2,2},
    [358]={2,2},
    [359]={2,2},
    [360]={2,2},
    [361]={2,2},
    [362]={2,2},
    [363]={2,2},
    [364]={2,2},
    [365]={2,2},
    [366]={2,2},
    [367]={2,2},
    [368]={2,2},
    [369]={2,2},
    [370]={2,2},
    [371]={2,2},
    [372]={2,2},
    [373]={2,2},
    [374]={2,2},
    [375]={2,2},
    [376]={2,2},
    [377]={2,2},
    [378]={2,2},
    [379]={2,2},
    [380]={2,2},
    [381]={2,2},
    [382]={2,2},
    [383]={2,2},
    [384]={2,2},
    [385]={2,2},
    [386]={2,2},
    [387]={2,2},
    [388]={2,2},
    [389]={2,2},
    [390]={2,2},
    [391]={2,2},
    [392]={2,2},
    [393]={2,2},
    [394]={2,2},
    [395]={2,2},
    [396]={2,2},
    [397]={2,2},
    [399]={2,2},
    [400]={1,4},
    [401]={1,4},
    [402]={2,8},
    [403]={1,6},
    [404]={2,9},
    [405]={2,7},
    [406]={4,5},
    [407]={4,6},
    [408]={2,3},
    [409]={1,1},
    [410]={3,1},
    [411]={2,2},
    [412]={1,1},
    [413]={1,1},
    [414]={1,2},
    [415]={1,6},
    [416]={2,4},
    [417]={2,9},
    [418]={2,5},
    [419]={1,7},
    [420]={2,7},
    [421]={4,5},
    [422]={4,6},
    [423]={3,3},
    [424]={1,1},
    [425]={3,1},
    [426]={2,2},
    [427]={1,1},
    [428]={1,1},
    [429]={1,2},
    [430]={1,2},
    [431]={1,2},
    [432]={2,2},
    [433]={1,3},
    [434]={1,1},
    [435]={2,1},
    [436]={1,1},
    [437]={1,1},
    [438]={1,1},
    [439]={1,1},
    [440]={1,1},
    [441]={1,1},
    [442]={1,1},
    [443]={1,1},
    [444]={1,1},
    [445]={1,1},
    [446]={1,2},
    [447]={2,1},
    [448]={1,2},
    [449]={2,2},
    [450]={3,2},
    [451]={2,2},
    [452]={2,2},
    [453]={2,2},
    [454]={2,2},
    [455]={1,1},
    [456]={1,1},
    [457]={1,1},
    [458]={1,1},
    [459]={1,1},
    [460]={1,1},
    [461]={1,2},
    [462]={3,2},
    [463]={1,1},
    [464]={2,2},
    [465]={1,2},
    [466]={1,2},
    [467]={1,3},
    [468]={2,3},
    [469]={2,2},
    [470]={2,1},
    [471]={1,2},
    [472]={2,1},
    [473]={3,2},
    [474]={2,1},
    [475]={1,2},
    [476]={1,1},
    [477]={1,1},
    [478]={2,1},
    [479]={2,2},
    [480]={2,1},
    [481]={1,1},
    [482]={1,2},
    [483]={2,1},
    [484]={1,1},
    [485]={2,1},
    [486]={2,2},
    [487]={1,1},
    [488]={1,1},
    [489]={1,1},
    [490]={1,2},
    [491]={1,1},
    [492]={1,1},
    [493]={2,2},
    [494]={2,2},
    [495]={2,2},
    [496]={2,2},
    [497]={2,2},
    [498]={1,4},
    [499]={3,4},
    [500]={2,1},
    [501]={2,1},
    [502]={2,1},
    [503]={2,1},
    [504]={2,1},
    [505]={2,1},
    [506]={2,1},
    [507]={2,1},
    [508]={2,1},
    [509]={2,1},
    [510]={2,1},
    [511]={2,1},
    [512]={2,1},
    [513]={2,1},
    [514]={2,1},
    [515]={2,1},
    [516]={2,1},
    [517]={2,1},
    [518]={2,1},
    [519]={2,1},
    [520]={2,1},
    [521]={2,1},
    [522]={2,1},
    [523]={2,1},
    [524]={2,1},
    [525]={2,1},
    [526]={2,1},
    [527]={2,1},
    [528]={2,1},
    [529]={2,1},
    [530]={2,1},
    [531]={2,1},
    [532]={2,1},
    [533]={2,1},
    [534]={2,1},
    [535]={2,1},
    [536]={2,1},
    [537]={2,1},
    [538]={2,1},
    [539]={2,1},
    [540]={2,1},
    [541]={2,1},
    [542]={2,1},
    [543]={2,1},
    [544]={2,1},
    [545]={2,1},
    [546]={2,1},
    [547]={2,1},
    [548]={2,1},
    [549]={2,1},
    [550]={2,2},
    [551]={2,2},
    [552]={2,2},
    [553]={2,2},
    [554]={1,2},
    [555]={1,1},
    [556]={1,1},
    [557]={1,1},
    [558]={1,2},
    [559]={1,1},
    [560]={1,1},
    [561]={1,1},
    [562]={1,1},
    [563]={1,1},
    [564]={1,2},
    [565]={1,1},
    [566]={1,1},
    [567]={1,1},
    [568]={1,1},
    [569]={1,1},
    [570]={1,2},
    [571]={1,1},
    [572]={1,1},
    [573]={1,1},
    [574]={1,1},
    [575]={1,1},
    [576]={1,2},
    [577]={1,1},
    [578]={1,1},
    [579]={1,2},
    [580]={2,1}
}

-- -- -- Malekith's code for itemsize code creation adapted for mm6
-- a = ""
-- evt.Add("Items", 1)
-- for i = 1, Game.ItemsTxt.High do
--     if Game.ItemsTxt[i + 1].Name ~= "" then
--         for i1 = 0, 125 do
--             Party[0].Inventory[i1] = 0
--         end
--         evt.Add("Items", i + 1)
--         x = 0
--         y = 0
--         while x < 14 and Party[0].Inventory[x] ~= 0 do
--             x = x + 1
--         end
--         while y < 9 and Party[0].Inventory[y * 14] ~= 0 do
--             y = y + 1
--         end
--         a = string.format(a .. "    [" .. i .. "]" .. "={" .. x .. "," .. y .. "},\n")
--         -- print("    [" .. i .. "]" .. "={" .. x .. "," .. y .. "},\n")
--         for i = 0, 125 do
--             Party[0].Inventory[i] = 0
--         end
--         for i = 1, 138 do
--             Party[0].Items[i].Number = 0
--         end

--     end

-- end
-- debug.Message(a)
