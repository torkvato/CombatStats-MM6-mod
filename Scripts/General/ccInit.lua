-- MM7 convenience and combatlog mod settings

-- Combat log options
CombatLogEnabled = 2; -- Combatlog output to file 0: disabled, 1 - Player damage only, 2 - Player and Monster damage
CombatLogFile = "CombatLog.csv"
CombatLogSeparator = "\t"  -- combat log fields separator
StatsOutputFile = "DamageStats.csv"
MinilogEntriesNumber = 15  -- number of entries for in-game combat log (L)


-- Convenience and Harmless cheats options
SharedIdentifyItem = 1 -- Max. Id Item skill shared among party
SharedRepair = 2 -- 0-off, 1-Max. Repair skill shared among party, 2 - Automatic repair with Max Skill

--Buff monitor
BuffExpirationAlert=1 -- Notification about buffs expiration
BuffListAlert = {'Haste', 'Invisibility', 'FeatherFall', 'Bless', 'Heroism', 'Fly'}

--Alarmclock
AlarmClockTime = "17:30" --set to empty strint to disable

--Useful information 
TravelScheduleAutoNote = 1 -- Add Travel schedule to Seer Autonotes
--MapAutoNote = 1 -- Add World Map to Seer Autonotes
TeachersTableAutoNote = 1 -- Add Teachers Table to Seer Autonotes
AlchemyRecipesAutoNote = 1 -- Add recipes schedule to Seer Autonotes

TrainingDummy = 1 -- ALT-L to call the Training Dummy


--Stats and tooltips
SkillTooltipsEnabled = 1 -- Enhanced skill tooltips. Disarm vs Map Disarm, Merchant discount, etc


--Keybinds
MiniLogButton = const.Keys.H -- MM9-style mini combat log 
-- CharacterInfo Screen
DamageMeterResetButton  = const.Keys.R -- 'R' button on the Char info screen to Reset segment statistics data
DamageMeterExportButton = const.Keys.E -- 'E' button on the Char info screen to Export statistics data
-- Inventory Screen
PlayerInventorySortButton  = const.Keys.R -- 'R' - Sort only current inventory
PartyInventorySortButton   = const.Keys.T -- 'T' - Sort all inventories
AlchemyPlayerSetButton     = const.Keys.Y -- 'Y' - Select/Unselect player for alchemy stuff
IdentifyPlayerSetButton    = const.Keys.U -- 'U'  - Select/Unselect player for unidentified stuff


F = {}

-- Table of average additional elem damage on weapons vs Bonus2 property value
const.bonus2damage={}
const.bonus2damage[0] = 0
const.bonus2damage[4] = 3.5
const.bonus2damage[5] = 7
const.bonus2damage[6] = 10.5
const.bonus2damage[7] = 3.5
const.bonus2damage[8] = 7
const.bonus2damage[9] = 10.5
const.bonus2damage[10] = 3.5
const.bonus2damage[11] = 7
const.bonus2damage[12] = 10.5
const.bonus2damage[13] = 5
const.bonus2damage[14] = 8
const.bonus2damage[15] = 12
const.bonus2damage[46] = 15
const.bonus2damage[67] = 5
const.bonus2damage[68] = 7

-- +10 to all Resistances.	of Protection	0	0	0	10	10	10	0	10	0	0	10	10	1000	B	(+10) on all four resistances
-- +10 to all Seven Statistics.	of The Gods	5	5	5	10	10	10	10	10	10	10	10	10	3000	D	(+10) on all 7 stats
-- Explosive Impact!	of Carnage	0	0	10	0	0	0	0	0	0	0	0	0	5000	D	"projectile explodes (fireball radius,dmg=weapdmg)"
-- 4 Adds 3-4 points of Cold damage.	of Cold	20	20	20	0	0	0	0	0	0	0	0	0	500	A	(3-4) cold damage
-- 5 Adds 6-8 points of Cold damage.	of Frost	20	20	20	0	0	0	0	0	0	0	0	0	1000	C	(6-8) cold damage
-- 6 Adds 9-12 points of Cold damage.	of Ice	20	20	20	0	0	0	0	0	0	0	0	0	2000	D	(9-12) cold damage
-- 7 Adds 2-5 points of Electrical damage.	of Sparks	20	20	20	0	0	0	0	0	0	0	0	0	500	A	(2-5) elec damage
-- 8 Adds 4-10 points of Electrical damage.	of Lightning	20	20	20	0	0	0	0	0	0	0	0	0	1000	C	(4-10) elec damage
-- 9 Adds 6-15 points of Electrical damage.	of Thunderbolts	20	20	20	0	0	0	0	0	0	0	0	0	2000	D	(6-15) elec damage
-- 10 Adds 1-6 points of Fire damage.	of Fire	20	20	20	0	0	0	0	0	0	0	0	0	500	A	(1-6) fire damage
-- 11 Adds 2-12 points of Fire damage.	of Flame	20	20	20	0	0	0	0	0	0	0	0	0	1000	C	(2-12) fire damage
-- 12 Adds 3-18 points of Fire damage.	of Infernos	20	20	20	0	0	0	0	0	0	0	0	0	2000	D	(3-18) fire damage
-- 13 Adds 5 points of Poison damage.	of Poison	20	20	20	0	0	0	0	0	0	0	0	0	500	A	(5) pois damage
-- 14 Adds 8 points of Poison damage.	of Venom	20	20	20	0	0	0	0	0	0	0	0	0	1000	C	(8) pois damage
-- 15 Adds 12 points of Poison damage.	of Acid	20	20	20	0	0	0	0	0	0	0	0	0	2000	D	(12) pois damage





const.Mastery = {[0] = "x",[1] = "N", [2] = "E", [3] = "M", [4] = "G"}

const.DamageColor = {
Fire = {255, 70, 70}, 
Elec = {173, 216, 230}, 
Cold = {100, 180, 255},
Poison = {0, 255, 0},
Phys = {255, 255,255},
Magic = {160, 50, 255},
Energy = {255, 0, 0}, 
 }


if CombatLogEnabled>0 then
local file = io.open(CombatLogFile,"r")
    if not(file) then
        file = io.open(CombatLogFile,"w")
        file:write(string.format("Time    %s#%sClass(Lvl)%sPlayer%sDir%sMonster%sDamage%sKind%sSource\n",CombatLogSeparator,CombatLogSeparator,CombatLogSeparator,CombatLogSeparator,CombatLogSeparator,CombatLogSeparator,CombatLogSeparator,CombatLogSeparator))
        file:close()
    else 
        file:close()
    end
end
nextbuffdurationcheck = 0
nextalarmclockcheck = 0

-- need to add after GlobalTxt to structs lua
--[mmv(0x56B7E8, 0x5C88F0, 0x5E4CB0)].array(55).EditPChar  'GlobalTxt2' 


-- KEYBIND VALUES--
--[[
LBUTTON= 1	
RBUTTON= 2	
CANCEL= 3	
MBUTTON = 4
XBUTTON1= 5	
XBUTTON2= 6	
BACK= 8	
BACKSPACE= 8	
TAB= 9	
CLEAR= 12	
ENTER= 13	
RETURN= 13	
SHIFT= 16	
CONTROL= 17	
CTRL= 17	
ALT= 18	
MENU= 18	
PAUSE= 19	
CAPITAL= 20	
CAPSLOCK= 20	
HANGUL= 21	
KANA= 21	
JUNJA= 23	
FINAL= 24	
HANJA= 25	
KANJI= 25	
ESCAPE= 27	
CONVERT= 28	
NONCONVERT= 29	
ACCEPT= 30	
MODECHANGE= 31	
SPACE= 32	
PGUP= 33	
PRIOR= 33	
NEXT= 34	
PGDN= 34	
END= 35	
HOME= 36	
LEFT= 37	
UP= 38	
RIGHT= 39	
DOWN= 40	
SELECT= 41	
PRINT= 42	
EXECUTE= 43	
SNAPSHOT= 44	
INSERT= 45	
DELETE= 46	
HELP= 47	
0= 48	
1= 49	
2= 50	
3= 51	
4= 52	
5= 53	
6= 54	
7= 55	
8= 56	
9= 57	
A= 65	
B= 66	
C= 67	
D= 68	
E= 69	
F= 70	
G= 71	
H= 72	
I= 73	
J= 74	
K= 75	
L= 76	
M= 77	
N= 78	
O= 79	
P= 80	
Q= 81	
R= 82	
S= 83	
T= 84	
U= 85	
V= 86	
W= 87	
X= 88	
Y= 89	
Z= 90	
LWIN= 91	
RWIN= 92	
APPS= 93	
SLEEP= 95	
NUMPAD0= 96	
NUMPAD1= 97	
NUMPAD2= 98	
NUMPAD3= 99	
NUMPAD4= 100	
NUMPAD5= 101	
NUMPAD6= 102	
NUMPAD7= 103	
NUMPAD8= 104	
NUMPAD9= 105	
MULTIPLY= 106	
ADD= 107	
SEPARATOR= 108	
SUBTRACT= 109	
DECIMAL= 110	
DIVIDE= 111	
F1= 112	
F2= 113	
F3= 114	
F4= 115	
F5= 116	
F6= 117	
F7= 118	
F8= 119	
F9= 120	
F10= 121	
F11= 122	
F12= 123	
F13= 124	
F14= 125	
F15= 126	
F16= 127	
F17= 128	
F18= 129	
F19= 130	
F20= 131	
F21= 132	
F22= 133	
F23= 134	
F24= 135	
NUMLOCK= 144	
SCROLL= 145	
SCROLLLOCK= 145	
LSHIFT= 160	
RSHIFT= 161	
LCONTROL= 162	
RCONTROL= 163	
LMENU= 164	
RMENU= 165	
BROWSER_BACK= 166	
BROWSER_FORWARD= 167	
BROWSER_REFRESH= 168	
BROWSER_STOP= 169	
BROWSER_SEARCH= 170	
BROWSER_FAVORITES= 171	
BROWSER_HOME= 172	
VOLUME_MUTE= 173	
VOLUME_DOWN= 174	
VOLUME_UP= 175	
MEDIA_NEXT_TRACK= 176	
MEDIA_PREV_TRACK= 177	
MEDIA_STOP= 178	
MEDIA_PLAY_PAUSE= 179	
LAUNCH_MAIL= 180	
LAUNCH_MEDIA_SELECT= 181	
LAUNCH_APP1= 182	
LAUNCH_APP2= 183	
OEM_1= 186	
OEM_PLUS= 187	
OEM_COMMA= 188	
OEM_MINUS= 189	
OEM_PERIOD= 190	
OEM_2= 191	
OEM_3= 192	
OEM_4= 219	
OEM_5= 220	
OEM_6= 221	
OEM_7= 222	
OEM_8= 223	
OEM_102= 226	
PROCESSKEY= 229	
PACKET= 231	
ATTN= 246	
CRSEL= 247	
EXSEL= 248	
EREOF= 249	
PLAY= 250	
ZOOM= 251	
NONAME= 252	
PA1= 253	
OEM_CLEAR= 254
]]
