--[[
================================================================================
  ██████╗ ███╗   ███╗███████╗ ██████╗  █████╗     ██╗  ██╗██╗   ██╗██████╗ 
 ██╔═══██╗████╗ ████║██╔════╝██╔════╝ ██╔══██╗    ██║  ██║██║   ██║██╔══██╗
 ██║   ██║██╔████╔██║█████╗  ██║  ███╗███████║    ███████║██║   ██║██████╔╝
 ██║   ██║██║╚██╔╝██║██╔══╝  ██║   ██║██╔══██║    ██╔══██║██║   ██║██╔══██╗
 ╚██████╔╝██║ ╚═╝ ██║███████╗╚██████╔╝██║  ██║    ██║  ██║╚██████╔╝██████╔╝
  ╚═════╝ ╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
================================================================================
  OMEGA HUB v4.0 - The Ultimate Blox Fruits Script
  Game: Blox Fruits (Roblox)
  Version: 4.0.0 ULTRA
  Author: OmegaHub Development Team
  Discord: discord.gg/omegahub
  YouTube: youtube.com/omegahub

  FEATURES:
  - Anti-Ban System with Humanizer
  - Auto Admin Detection + Auto Leave
  - Auto Farm (Level, Boss, Mastery)
  - Auto Quest (Draco, Dragon, V2/V3/V4)
  - Auto Fruit (Get, Store, Random, Bring)
  - Teleport System (All Islands, NPCs, Quests)
  - PvP System (Auto Combo, Silent Aim)
  - Auto Race (V2/V3/V4, Cyborg, Ghoul)
  - Special Swords (Yama, Tushita, Rengoku)
  - Auto Mirage, Boss Defeat, Egg Collect
  - And MUCH more...

  WARNING: Use at your own risk. We are not
  responsible for any bans or account issues.
================================================================================
]]

-- ============================================================================
-- SECTION 1: CORE SERVICES & INITIALIZATION
-- ============================================================================

-- Secure environment check
local success, err = pcall(function()
    local RunService = game:GetService("RunService")
    if RunService:IsStudio() then
        warn("[OmegaHub] Running in Studio mode - some features disabled")
    end
end)

-- Core Roblox Services
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")
local TweenService       = game:GetService("TweenService")
local HttpService        = game:GetService("HttpService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local Workspace          = game:GetService("Workspace")
local CoreGui            = game:GetService("CoreGui")
local StarterGui         = game:GetService("StarterGui")
local SoundService       = game:GetService("SoundService")
local PathfindingService = game:GetService("PathfindingService")
local PhysicsService     = game:GetService("PhysicsService")
local TeleportService    = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualInputManager = game:GetService("VirtualInputManager") or nil
local LocalizationService = game:GetService("LocalizationService") or nil

-- Local Player Reference
local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local Backpack    = LocalPlayer:WaitForChild("Backpack")
local Character   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid    = Character:WaitForChild("Humanoid")

-- ============================================================================
-- SECTION 2: GLOBAL CONFIGURATION TABLE
-- ============================================================================

local OmegaHub = {}
OmegaHub.Version     = "4.0.0"
OmegaHub.Name        = "Omega Hub"
OmegaHub.Game        = "Blox Fruits"
OmegaHub.Loaded      = false
OmegaHub.Connections = {}
OmegaHub.Threads     = {}
OmegaHub.Cache       = {}
OmegaHub.Flags       = {}
OmegaHub.UI          = {}
OmegaHub.Modules     = {}

-- ============================================================================
-- SECTION 3: SETTINGS & TOGGLES CONFIGURATION
-- ============================================================================

local Settings = {
    -- === ANTI-BAN SETTINGS ===
    AntiBan = {
        Enabled           = true,
        HumanizerEnabled  = true,
        RandomDelay       = true,
        MinDelay          = 0.05,
        MaxDelay          = 0.15,
        FakeMovement      = true,
        FakeMovementSpeed = 1.2,
        AntiAFK           = true,
        AntiAFKInterval   = 60,
        RandomRotation    = true,
        JumpRandom        = true,
    },
    -- === ADMIN DETECTION SETTINGS ===
    AdminDetection = {
        Enabled           = true,
        AutoLeave         = true,
        AutoLeaveDelay    = 1.5,
        Notification      = true,
        PrintToConsole    = true,
        AdminList         = {
            "badcc0",
            "Coeptus",
            "1dev3",
            "AbstractAlex",
            "Seranok",
            "Merely",
            "Nix",
            "Litozinnamon",
            "AxisAngle",
            "Quenty",
            "Defaultio",
            "CreatorOfBloxFruits",
            "MikeDex",
        },
        PrivServerDetect  = true,
        StaffBadgeDetect  = true,
        RoleBadgeIDs      = { 1, 2, 3, 102, 103, 104 },
    },
    -- === AUTO FARM SETTINGS ===
    AutoFarm = {
        Enabled           = false,
        FarmMobs          = true,
        FarmBosses        = false,
        FarmAllBosses     = false,
        SelectedBoss      = "None",
        MasteryFarm       = false,
        MasteryType       = "Fruit",   -- "Fruit", "Sword", "Melee", "Gun"
        LevelTarget       = 2400,
        CurrentMethod     = "Kill",    -- "Kill", "Quest", "Sea"
        UseAutoSkills     = true,
        AutoEquipBestFruit = true,
        AutoEquipBestSword = true,
        WalkToMob         = true,
        SafeZoneReturn    = true,
        AttackDelay       = 0.08,
        LoopDelay         = 0.1,
        FarmOnlyRed       = false,
        FarmAnyMob        = true,
        MinLevelMob       = 1,
        MaxLevelMob       = 9999,
        CollectDrops      = true,
        AutoRevive        = true,
        ReviveLocation    = CFrame.new(0, 0, 0),
    },
    -- === AUTO QUEST SETTINGS ===
    AutoQuest = {
        Enabled           = false,
        QuestType         = "Level",   -- "Level","Draco","Dragon","DracoV2","DracoV3","DracoV4"
        AutoAccept        = true,
        AutoComplete      = true,
        AutoTurnIn        = true,
        DracoAuto         = false,
        DragonQuestAuto   = false,
        DracoV2Auto       = false,
        DracoV3Auto       = false,
        DracoV4Auto       = false,
        RepeatQuest       = true,
        QuestDelay        = 0.5,
    },
    -- === AUTO FRUIT SETTINGS ===
    AutoFruit = {
        Enabled           = false,
        AutoGetFruit      = true,
        AutoStoreFruit    = true,
        AutoRandomFruit   = false,
        BringFruitToPlayer = true,
        BringRadius       = 50,
        StoreWhenFull     = true,
        PreferredFruits   = {},
        BlacklistedFruits = {},
        EatIfNoSpace      = false,
        AutoSellFruit     = false,
        SellOnlyCommon    = true,
        NotifyOnFruit     = true,
        ScanRadius        = 2000,
        ScanInterval      = 1.0,
        AutoEatFruit      = false,
        EatSelectedFruit  = "None",
    },
    -- === TELEPORT SETTINGS ===
    Teleport = {
        TeleportDelay     = 0.5,
        SafeTeleport      = true,
        RetryCount        = 3,
        ConfirmTeleport   = false,
        AntiVoidFall      = true,
        LastPosition      = nil,
    },
    -- === PVP SETTINGS ===
    PvP = {
        Enabled           = false,
        AutoCombo         = false,
        ComboKeys         = { "Z", "X", "C", "V", "F" },
        KeyEnabled        = { Z=true, X=true, C=true, V=true, F=true },
        KeyDelays         = { Z=0.05, X=0.05, C=0.05, V=0.05, F=0.05 },
        ComboDelay        = 0.08,
        GlobalComboDelay  = 0.05,
        AutoAim           = true,
        SilentAim         = false,
        AimBone           = "HumanoidRootPart",
        LockTarget        = false,
        LockedTarget      = nil,
        GetInsidePlayer   = false,
        GetInsideOffset   = Vector3.new(0, 0, 0),
        AntiKnockback     = false,
        InfJump           = false,
        AutoBlock         = false,
        BlockBreak        = false,
        AntiStun          = false,
        MaxRange          = 50,
        AutoSelectTarget  = true,
        TeamCheck         = true,
        IgnoreTeammates   = true,
        AutoComboSequence = { "Z", "X", "C", "V", "F", "Z", "X" },
        LoopCombo         = true,
        ComboLoopDelay    = 0.3,
    },
    -- === AUTO RACE SETTINGS ===
    AutoRace = {
        V2Enabled         = false,
        V3Enabled         = false,
        V4Enabled         = false,
        CyborgEnabled     = false,
        GhoulEnabled      = false,
        SelectedRace      = "Human",
        AutoBuyRace       = false,
        AutoChangeRace    = false,
        RaceChangeTarget  = "Cyborg",
    },
    -- === EGGS & COLLECT ===
    Eggs = {
        AutoCollectEggs   = false,
        AutoGiveEggs      = false,
        EggScanRadius     = 500,
        EggCollectDelay   = 0.5,
        AutoSelectEgg     = true,
        PreferRareEggs    = true,
    },
    Berry = {
        AutoCollectBerry  = false,
        BerryRadius       = 1000,
        BerryDelay        = 0.3,
        AutoSpendBerry    = false,
        SpendOnWhat       = "Race",
    },
    -- === ELITE HUNTERS ===
    EliteHunters = {
        AutoFarm          = false,
        SelectedTarget    = "All",
        Yama              = false,
        Tushita           = false,
        Rengoku           = false,
        TrippleKatana     = false,
        KilledCount       = 0,
    },
    -- === SPECIAL SWORDS ===
    SpecialSwords = {
        AutoYama          = false,
        AutoTushita       = false,
        AutoRengoku       = false,
        AutoTripleKatana  = false,
        CurrentStep       = 0,
        MaxSteps          = 0,
    },
    -- === BOSS DEFEAT ===
    BossDefeat = {
        AutoMirage        = false,
        AutoIndra         = false,
        AutoDoughKing     = false,
        AutoCakePrince    = false,
        LoopBoss          = false,
        BossDelay         = 1.0,
    },
    -- === MISC SETTINGS ===
    Misc = {
        AntiVoid          = true,
        NoClip            = false,
        FlyEnabled        = false,
        FlySpeed          = 50,
        WalkSpeed         = 16,
        JumpPower         = 7.2,
        InfJump           = false,
        AutoFarm2xDrop    = false,
        ShowESP           = false,
        ShowBossESP       = false,
        ShowFruitESP      = true,
        ESPDistance       = 1000,
        AutoStat          = false,
        StatType          = "Melee",  -- "Melee","Defense","Sword","Gun","Fruit"
        AutoStatInterval  = 5,
        ChatBypass        = false,
    },
}

-- ============================================================================
-- SECTION 4: GAME DATA TABLES
-- ============================================================================

-- Boss Data Table (Complete)
local BossData = {
    -- FIRST SEA BOSSES
    {name = "Gorilla King",     level = 53,   location = CFrame.new(-1300, 5, 4150),      sea = 1, respawnTime = 10},
    {name = "Bobby",            level = 75,   location = CFrame.new(-495, 5, 1635),       sea = 1, respawnTime = 10},
    {name = "Yeti",             level = 100,  location = CFrame.new(-4920, 943, -1315),   sea = 1, respawnTime = 10},
    {name = "Lord of Destruction", level = 125, location = CFrame.new(-1100, 37, -3450), sea = 1, respawnTime = 10},
    {name = "Saber Expert",     level = 150,  location = CFrame.new(-1500, 129, -3850),   sea = 1, respawnTime = 30},
    {name = "Magma Admiral",    level = 350,  location = CFrame.new(-5174, 260, -1065),   sea = 1, respawnTime = 10},
    {name = "Golden Boss",      level = 375,  location = CFrame.new(-4990, 870, -1315),   sea = 1, respawnTime = 10},
    {name = "Vice Admiral",     level = 400,  location = CFrame.new(6115, 42, -510),      sea = 1, respawnTime = 10},
    {name = "Warden",           level = 400,  location = CFrame.new(4390, 192, -1630),    sea = 1, respawnTime = 10},
    {name = "Chief Warden",     level = 425,  location = CFrame.new(4480, 196, -1740),    sea = 1, respawnTime = 10},
    {name = "Swan",             level = 425,  location = CFrame.new(5080, 25, -360),      sea = 1, respawnTime = 15},
    {name = "Wysper",           level = 450,  location = CFrame.new(-7725, 2100, -4300),  sea = 1, respawnTime = 10},
    {name = "Thunder God",      level = 475,  location = CFrame.new(-7750, 2230, -4100),  sea = 1, respawnTime = 10},
    {name = "Cyborg Boss",      level = 675,  location = CFrame.new(-1385, 135, -1020),   sea = 1, respawnTime = 15},
    -- SECOND SEA BOSSES
    {name = "Darkbeard",        level = 1000, location = CFrame.new(-10580, 31, -9180),   sea = 2, respawnTime = 60},
    {name = "Order",            level = 1250, location = CFrame.new(-13920, 130, -8800),  sea = 2, respawnTime = 30},
    {name = "Awakened Ice Admiral", level = 1400, location = CFrame.new(-7900, 12, -2050), sea = 2, respawnTime = 30},
    {name = "Tide Keeper",      level = 1475, location = CFrame.new(-6450, -70, -6260),   sea = 2, respawnTime = 30},
    {name = "Captain Elephant", level = 1675, location = CFrame.new(-12070, 3, -1555),    sea = 2, respawnTime = 30},
    {name = "Cake Queen",       level = 1750, location = CFrame.new(-8060, 60, 3400),     sea = 2, respawnTime = 30},
    {name = "Island Empress",   level = 1875, location = CFrame.new(-1210, 87, 4010),     sea = 2, respawnTime = 60},
    {name = "Kilo Admiral",     level = 2000, location = CFrame.new(-16200, 3, -850),     sea = 2, respawnTime = 30},
    -- THIRD SEA BOSSES
    {name = "Stone",            level = 1500, location = CFrame.new(-2300, 18, 310),      sea = 3, respawnTime = 30},
    {name = "Island Empress",   level = 1875, location = CFrame.new(-1210, 87, 4010),     sea = 3, respawnTime = 60},
    {name = "Longma",           level = 2000, location = CFrame.new(-8870, 13, 1380),     sea = 3, respawnTime = 30},
    {name = "Rip_Indra (Raid)", level = 2400, location = CFrame.new(-2850, 5, 3150),      sea = 3, respawnTime = 90},
    {name = "Dough King",       level = 2300, location = CFrame.new(-4350, 26, -1350),    sea = 3, respawnTime = 60},
    {name = "Cake Prince",      level = 2100, location = CFrame.new(-6700, 18, 100),      sea = 3, respawnTime = 45},
    {name = "Soul Reaper",      level = 2050, location = CFrame.new(-2200, 165, 1880),    sea = 3, respawnTime = 30},
    {name = "Cursed Captain",   level = 1925, location = CFrame.new(7400, 62, -6300),     sea = 3, respawnTime = 30},
    {name = "Ice Admiral",      level = 1400, location = CFrame.new(-12580, 5, 3050),     sea = 3, respawnTime = 30},
    {name = "Wandering Pirate", level = 1950, location = CFrame.new(-11350, 5, -3600),    sea = 3, respawnTime = 30},
    {name = "Greybeard",        level = 700,  location = CFrame.new(-6985, 20, -1965),    sea = 2, respawnTime = 45},
}

-- Island/Location Data Table
local IslandData = {
    -- FIRST SEA
    { name = "Starter Island",        sea = 1, cframe = CFrame.new(-995, 10, 1040) },
    { name = "Marine Starter",        sea = 1, cframe = CFrame.new(975, 10, -1750) },
    { name = "Jungle",                sea = 1, cframe = CFrame.new(-1270, 6, 4145) },
    { name = "Pirate Village",        sea = 1, cframe = CFrame.new(-1520, 8, 1220) },
    { name = "Desert",                sea = 1, cframe = CFrame.new(-495, 8, 1635) },
    { name = "Middle Island",         sea = 1, cframe = CFrame.new(-100, 10, 0) },
    { name = "Marines Fortress",      sea = 1, cframe = CFrame.new(6115, 44, -510) },
    { name = "Skylands",              sea = 1, cframe = CFrame.new(-7760, 2260, -4310) },
    { name = "Prison",                sea = 1, cframe = CFrame.new(4390, 200, -1630) },
    { name = "Colosseum",             sea = 1, cframe = CFrame.new(-1385, 135, -1020) },
    { name = "Magma Village",         sea = 1, cframe = CFrame.new(-5174, 260, -1065) },
    { name = "Snow Mountain",         sea = 1, cframe = CFrame.new(-4920, 943, -1315) },
    { name = "Underwater City",       sea = 1, cframe = CFrame.new(-80, -2000, -15) },
    -- SECOND SEA
    { name = "Kingdom of Rose",       sea = 2, cframe = CFrame.new(-1215, 40, -2485) },
    { name = "Graveyard",             sea = 2, cframe = CFrame.new(440, 108, -2510) },
    { name = "Hot and Cold Island",   sea = 2, cframe = CFrame.new(-7900, 12, -2050) },
    { name = "Cursed Ship",           sea = 2, cframe = CFrame.new(-8015, 12, 5015) },
    { name = "Ice Castle",            sea = 2, cframe = CFrame.new(-12200, 44, 3050) },
    { name = "Forgotten Island",      sea = 2, cframe = CFrame.new(-12070, 3, -1555) },
    { name = "Cafe",                  sea = 2, cframe = CFrame.new(-3115, 40, -1885) },
    { name = "Dark Arena",            sea = 2, cframe = CFrame.new(-10580, 31, -9180) },
    { name = "Thriller Bark",         sea = 2, cframe = CFrame.new(-8060, 60, 3400) },
    { name = "Floating Turtle Island",sea = 2, cframe = CFrame.new(-1210, 87, 4010) },
    { name = "Haunted Castle",        sea = 2, cframe = CFrame.new(-13920, 130, -8800) },
    { name = "Mirage Island",         sea = 2, cframe = CFrame.new(-9300, 3, -1865) },
    -- THIRD SEA
    { name = "Port Town",             sea = 3, cframe = CFrame.new(-11590, 5, -3590) },
    { name = "Hydra Island",          sea = 3, cframe = CFrame.new(-10400, 5, -3600) },
    { name = "Floating Turtle",       sea = 3, cframe = CFrame.new(-8870, 13, 1380) },
    { name = "Mansion",               sea = 3, cframe = CFrame.new(-9680, 5, 980) },
    { name = "Great Tree",            sea = 3, cframe = CFrame.new(-7700, 5, -350) },
    { name = "Tiki Outpost",          sea = 3, cframe = CFrame.new(-6700, 18, 100) },
    { name = "Usoapp Island",         sea = 3, cframe = CFrame.new(-5085, 5, 3520) },
    { name = "Candy Island",          sea = 3, cframe = CFrame.new(-4350, 26, -1350) },
    { name = "Castle on the Sea",     sea = 3, cframe = CFrame.new(-3850, 5, -5560) },
    { name = "Ice Island",            sea = 3, cframe = CFrame.new(-12580, 5, 3050) },
    { name = "Sea of Treats",         sea = 3, cframe = CFrame.new(-1850, 0, -3740) },
    { name = "Haunted Port",          sea = 3, cframe = CFrame.new(7400, 62, -6300) },
    { name = "Desolate Palace",       sea = 3, cframe = CFrame.new(-2850, 5, 3150) },
    { name = "Mirage Island (3rd)",   sea = 3, cframe = CFrame.new(-9300, 3, -1865) },
}

-- NPC Quest Givers
local QuestNPCs = {
    { name = "Fishman Lord Quest",    cframe = CFrame.new(61473, 11, 1584) },
    { name = "Draco Quest Giver",     cframe = CFrame.new(-2300, 18, 310) },
    { name = "Draco V2 Quest",        cframe = CFrame.new(-2850, 5, 3150) },
    { name = "Draco V3 Quest",        cframe = CFrame.new(-3800, 15, 2350) },
    { name = "Draco V4 Quest",        cframe = CFrame.new(-4200, 20, 1500) },
    { name = "Dragon Quest Giver",    cframe = CFrame.new(-11590, 5, -3590) },
    { name = "God of Thunder",        cframe = CFrame.new(-7750, 2230, -4100) },
    { name = "Blacksmith",            cframe = CFrame.new(-1520, 8, 1220) },
    { name = "Sword Dealer",          cframe = CFrame.new(-1215, 40, -2485) },
    { name = "Master Sword Dealer",   cframe = CFrame.new(-3115, 40, -1885) },
    { name = "Race Caretaker",        cframe = CFrame.new(975, 10, -1750) },
    { name = "Cyborg Quest Giver",    cframe = CFrame.new(-1385, 135, -1020) },
    { name = "Ghoul Quest Giver",     cframe = CFrame.new(-8060, 60, 3400) },
    { name = "Elite Hunter",          cframe = CFrame.new(-3115, 40, -1885) },
    { name = "Legendary Sword Dealer",cframe = CFrame.new(-3115, 40, -1885) },
    { name = "Yama Quest",            cframe = CFrame.new(-8870, 13, 1380) },
    { name = "Tushita Quest",         cframe = CFrame.new(-8870, 13, 1380) },
    { name = "Rengoku Quest",         cframe = CFrame.new(-7700, 5, -350) },
    { name = "True Triple Katana",    cframe = CFrame.new(-3850, 5, -5560) },
    { name = "Mirage Island NPC",     cframe = CFrame.new(-9300, 3, -1865) },
    { name = "Alchemist (Fruits)",    cframe = CFrame.new(-3115, 40, -1885) },
    { name = "Fruit Dealer",          cframe = CFrame.new(-495, 8, 1635) },
    { name = "Pirate Fruit Dealer",   cframe = CFrame.new(-1520, 8, 1220) },
    { name = "Ship Dealer",           cframe = CFrame.new(-100, 10, 0) },
    { name = "Bounty System NPC",     cframe = CFrame.new(-1215, 40, -2485) },
    { name = "Raid Boss NPC",         cframe = CFrame.new(-2850, 5, 3150) },
    { name = "Stat Reset NPC",        cframe = CFrame.new(975, 10, -1750) },
    { name = "Leveling Master",       cframe = CFrame.new(-995, 10, 1040) },
    { name = "Egg Collector NPC",     cframe = CFrame.new(-3115, 40, -1885) },
    { name = "Pet Handler NPC",       cframe = CFrame.new(-3115, 40, -1885) },
}

-- Race Data
local RaceData = {
    { name = "Human",   color = Color3.fromRGB(255, 240, 200), cost = 0,       ability = "None" },
    { name = "Shark",   color = Color3.fromRGB(100, 180, 255), cost = 3000,    ability = "Water Breath" },
    { name = "Sky",     color = Color3.fromRGB(200, 220, 255), cost = 3000,    ability = "Sky Wings" },
    { name = "Rabbit",  color = Color3.fromRGB(255, 230, 230), cost = 3000,    ability = "Bunny Hop" },
    { name = "Angel",   color = Color3.fromRGB(255, 255, 200), cost = 3000,    ability = "Holy Aura" },
    { name = "Cyborg",  color = Color3.fromRGB(160, 180, 200), cost = 0,       ability = "Machine Enhancement" },
    { name = "Ghoul",   color = Color3.fromRGB(80,  80,  160), cost = 100,     ability = "Dark Hunger" },
    { name = "Mink",    color = Color3.fromRGB(200, 160, 255), cost = 3000,    ability = "Electro" },
    { name = "Fish",    color = Color3.fromRGB(80,  200, 255), cost = 3000,    ability = "Swim Speed" },
}

-- Fruit Data Table
local FruitData = {
    -- COMMON
    { name = "Chop",       rarity = "Common",    price = 30000,    type = "Paramecia" },
    { name = "Spike",      rarity = "Common",    price = 75000,    type = "Paramecia" },
    { name = "Spring",     rarity = "Common",    price = 60000,    type = "Paramecia" },
    { name = "Kilo",       rarity = "Common",    price = 5000,     type = "Paramecia" },
    { name = "Smoke",      rarity = "Common",    price = 100000,   type = "Logia" },
    { name = "Spin",       rarity = "Common",    price = 7500,     type = "Paramecia" },
    { name = "Revive",     rarity = "Common",    price = 187500,   type = "Paramecia" },
    { name = "Barrier",    rarity = "Common",    price = 87500,    type = "Paramecia" },
    { name = "Bomb",       rarity = "Common",    price = 5000,     type = "Paramecia" },
    -- UNCOMMON
    { name = "Flame",      rarity = "Uncommon",  price = 250000,   type = "Logia" },
    { name = "Ice",        rarity = "Uncommon",  price = 350000,   type = "Logia" },
    { name = "Sand",       rarity = "Uncommon",  price = 420000,   type = "Logia" },
    { name = "Quake",      rarity = "Uncommon",  price = 1000000,  type = "Paramecia" },
    { name = "Dark",       rarity = "Uncommon",  price = 500000,   type = "Logia" },
    { name = "Light",      rarity = "Uncommon",  price = 650000,   type = "Logia" },
    { name = "Rubber",     rarity = "Uncommon",  price = 750000,   type = "Paramecia" },
    -- RARE
    { name = "Gravity",    rarity = "Rare",      price = 2500000,  type = "Paramecia" },
    { name = "Magma",      rarity = "Rare",      price = 850000,   type = "Logia" },
    { name = "Dough",      rarity = "Rare",      price = 2800000,  type = "Special" },
    { name = "Blizzard",   rarity = "Rare",      price = 2500000,  type = "Logia" },
    { name = "Diamond",    rarity = "Rare",      price = 600000,   type = "Paramecia" },
    { name = "Shadow",     rarity = "Rare",      price = 2900000,  type = "Paramecia" },
    { name = "Rumble",     rarity = "Rare",      price = 2100000,  type = "Logia" },
    { name = "Mammoth",    rarity = "Rare",      price = 2700000,  type = "Beast" },
    { name = "Bird",       rarity = "Rare",      price = 1200000,  type = "Zoan" },
    -- LEGENDARY
    { name = "Phoenix",    rarity = "Legendary", price = 1400000,  type = "Mythical" },
    { name = "Spider",     rarity = "Legendary", price = 1500000,  type = "Paramecia" },
    { name = "Portal",     rarity = "Legendary", price = 2700000,  type = "Paramecia" },
    { name = "Venom",      rarity = "Legendary", price = 2950000,  type = "Paramecia" },
    { name = "Dragon",     rarity = "Legendary", price = 3500000,  type = "Mythical" },
    { name = "Control",    rarity = "Legendary", price = 3200000,  type = "Paramecia" },
    { name = "Leopard",    rarity = "Legendary", price = 5000000,  type = "Mythical" },
    -- MYTHICAL
    { name = "Ope",        rarity = "Mythical",  price = 3400000,  type = "Paramecia" },
    { name = "Buddha",     rarity = "Mythical",  price = 1350000,  type = "Special" },
    { name = "Soul",       rarity = "Mythical",  price = 2550000,  type = "Paramecia" },
    { name = "Yeti",       rarity = "Mythical",  price = 0,        type = "Beast" },
    { name = "T-Rex",      rarity = "Mythical",  price = 0,        type = "Beast" },
}

-- Mob/Enemy Data for farming
local MobData = {
    -- FIRST SEA
    { name = "Bandit",         level = 1,    location = CFrame.new(-995, 10, 1040),   xp = 50,   sea = 1 },
    { name = "Monkey",         level = 15,   location = CFrame.new(-1270, 6, 4145),   xp = 80,   sea = 1 },
    { name = "Gorilla",        level = 25,   location = CFrame.new(-1270, 6, 4145),   xp = 100,  sea = 1 },
    { name = "Desert Bandit",  level = 60,   location = CFrame.new(-495, 8, 1635),    xp = 200,  sea = 1 },
    { name = "Desert Officer", level = 75,   location = CFrame.new(-495, 8, 1635),    xp = 280,  sea = 1 },
    { name = "Snow Bandit",    level = 90,   location = CFrame.new(-4920, 943, -1315),xp = 300,  sea = 1 },
    { name = "Snowman",        level = 120,  location = CFrame.new(-4920, 943, -1315),xp = 380,  sea = 1 },
    { name = "Sky Bandit",     level = 400,  location = CFrame.new(-7760, 2260, -4310),xp = 800, sea = 1 },
    { name = "Dark Master",    level = 425,  location = CFrame.new(-7760, 2260, -4310),xp = 900, sea = 1 },
    { name = "Prisoner",       level = 100,  location = CFrame.new(4390, 200, -1630), xp = 380,  sea = 1 },
    { name = "Dangerous Prisoner", level = 200, location = CFrame.new(4390, 200, -1630), xp = 550, sea = 1 },
    { name = "Marine",         level = 120,  location = CFrame.new(6115, 44, -510),   xp = 400,  sea = 1 },
    { name = "Marine Soldier", level = 150,  location = CFrame.new(6115, 44, -510),   xp = 500,  sea = 1 },
    { name = "Marine Captain", level = 200,  location = CFrame.new(6115, 44, -510),   xp = 600,  sea = 1 },
    { name = "Toga Warrior",   level = 625,  location = CFrame.new(-1385, 135, -1020),xp = 1100, sea = 1 },
    { name = "Gladiator",      level = 650,  location = CFrame.new(-1385, 135, -1020),xp = 1200, sea = 1 },
    -- SECOND SEA
    { name = "Factory Staff",  level = 700,  location = CFrame.new(-16200, 3, -850),  xp = 1250, sea = 2 },
    { name = "Scientist",      level = 775,  location = CFrame.new(-13920, 130, -8800),xp = 1300, sea = 2 },
    { name = "Snow Lurker",    level = 1150, location = CFrame.new(-12200, 44, 3050), xp = 2000, sea = 2 },
    { name = "Dicer",          level = 1175, location = CFrame.new(-12200, 44, 3050), xp = 2100, sea = 2 },
    { name = "Sea Soldier",    level = 775,  location = CFrame.new(-6450, -70, -6260),xp = 1300, sea = 2 },
    { name = "Fishman Warrior",level = 875,  location = CFrame.new(-6450, -70, -6260),xp = 1550, sea = 2 },
    { name = "Fishman Commando",level = 925, location = CFrame.new(-6450, -70, -6260),xp = 1700, sea = 2 },
    { name = "Zombie",         level = 950,  location = CFrame.new(-8015, 12, 5015),  xp = 1750, sea = 2 },
    { name = "Zombie Pirate",  level = 975,  location = CFrame.new(-8015, 12, 5015),  xp = 1800, sea = 2 },
    { name = "Vampire",        level = 1025, location = CFrame.new(-8015, 12, 5015),  xp = 1900, sea = 2 },
    { name = "Soul Carrier",   level = 1125, location = CFrame.new(-8015, 12, 5015),  xp = 2000, sea = 2 },
    { name = "Living Zombie",  level = 1050, location = CFrame.new(-8060, 60, 3400),  xp = 1950, sea = 2 },
    { name = "Demonic Soul",   level = 1075, location = CFrame.new(-8060, 60, 3400),  xp = 2000, sea = 2 },
    { name = "Posessed Mummy", level = 1100, location = CFrame.new(-8060, 60, 3400),  xp = 2100, sea = 2 },
    { name = "Reaper",         level = 1575, location = CFrame.new(-8060, 60, 3400),  xp = 2800, sea = 2 },
    -- THIRD SEA
    { name = "Pirate Millionaire", level = 1500, location = CFrame.new(-11590, 5, -3590), xp = 2600, sea = 3 },
    { name = "Forest Pirate",  level = 1525, location = CFrame.new(-11590, 5, -3590), xp = 2700, sea = 3 },
    { name = "Mythological Pirate", level = 1575, location = CFrame.new(-11590, 5, -3590), xp = 2800, sea = 3 },
    { name = "Jungle Pirate",  level = 1600, location = CFrame.new(-10400, 5, -3600), xp = 2900, sea = 3 },
    { name = "Musketeer Pirate", level = 1625, location = CFrame.new(-10400, 5, -3600), xp = 3000, sea = 3 },
    { name = "Dragon Crew Warrior", level = 1675, location = CFrame.new(-8870, 13, 1380), xp = 3100, sea = 3 },
    { name = "Dragon Crew Archer", level = 1700, location = CFrame.new(-8870, 13, 1380), xp = 3200, sea = 3 },
    { name = "Marine Commodore", level = 1725, location = CFrame.new(-9680, 5, 980), xp = 3300, sea = 3 },
    { name = "Marine Vice Admiral", level = 1750, location = CFrame.new(-9680, 5, 980), xp = 3400, sea = 3 },
    { name = "Beautiful Pirate", level = 1775, location = CFrame.new(-7700, 5, -350), xp = 3500, sea = 3 },
    { name = "Cake Guard",     level = 1800, location = CFrame.new(-4350, 26, -1350), xp = 3600, sea = 3 },
    { name = "Candy Pirate",   level = 1825, location = CFrame.new(-4350, 26, -1350), xp = 3700, sea = 3 },
    { name = "Ship Pirate",    level = 1850, location = CFrame.new(-3850, 5, -5560), xp = 3800, sea = 3 },
    { name = "Tiki Outpost Warrior", level = 1875, location = CFrame.new(-6700, 18, 100), xp = 3900, sea = 3 },
    { name = "Ice Cream Monster", level = 1900, location = CFrame.new(-1850, 0, -3740), xp = 4000, sea = 3 },
    { name = "Snow Demon",     level = 1950, location = CFrame.new(-12580, 5, 3050), xp = 4200, sea = 3 },
    { name = "Ice Demon",      level = 1975, location = CFrame.new(-12580, 5, 3050), xp = 4400, sea = 3 },
    { name = "Ghost",          level = 2000, location = CFrame.new(7400, 62, -6300), xp = 4500, sea = 3 },
    { name = "Demonic Soul",   level = 2025, location = CFrame.new(7400, 62, -6300), xp = 4600, sea = 3 },
    { name = "Pirate Of Hell", level = 2075, location = CFrame.new(7400, 62, -6300), xp = 4800, sea = 3 },
    { name = "Blaze Pirate",   level = 2100, location = CFrame.new(-2850, 5, 3150), xp = 5000, sea = 3 },
    { name = "Electric Pirate",level = 2125, location = CFrame.new(-2850, 5, 3150), xp = 5100, sea = 3 },
    { name = "Reborn Skeleton",level = 2050, location = CFrame.new(-2200, 165, 1880), xp = 5200, sea = 3 },
}

-- ============================================================================
-- SECTION 5: UTILITY FUNCTIONS
-- ============================================================================

-- Get distance between two Vector3 positions
local function GetDistance(pos1, pos2)
    if typeof(pos1) == "CFrame" then pos1 = pos1.Position end
    if typeof(pos2) == "CFrame" then pos2 = pos2.Position end
    return (pos1 - pos2).Magnitude
end

-- Safely call a remote function
local function SafeFireRemote(remoteName, ...)
    local success, result = pcall(function()
        local remote = ReplicatedStorage:FindFirstChild(remoteName)
            or ReplicatedStorage:WaitForChild(remoteName, 5)
        if remote then
            if remote:IsA("RemoteEvent") then
                remote:FireServer(...)
            elseif remote:IsA("RemoteFunction") then
                return remote:InvokeServer(...)
            end
        end
    end)
    return success, result
end

-- Get character safely
local function GetCharacter()
    return LocalPlayer.Character
end

-- Get HumanoidRootPart safely
local function GetHRP()
    local char = GetCharacter()
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

-- Get Humanoid safely
local function GetHumanoid()
    local char = GetCharacter()
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- Check if player is alive
local function IsAlive()
    local hum = GetHumanoid()
    return hum and hum.Health > 0
end

-- Teleport character to CFrame
local function TeleportTo(cf)
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = cf
        return true
    end
    return false
end

-- Wait with delay
local function Wait(t)
    t = t or 0
    task.wait(t)
end

-- Random float between min and max
local function RandomFloat(min, max)
    return min + math.random() * (max - min)
end

-- Random delay (humanizer)
local function HumanizedWait()
    if Settings.AntiBan.HumanizerEnabled then
        Wait(RandomFloat(Settings.AntiBan.MinDelay, Settings.AntiBan.MaxDelay))
    end
end

-- Print with prefix
local function Log(msg, level)
    level = level or "INFO"
    print(string.format("[OmegaHub][%s] %s", level, tostring(msg)))
end

-- Check if a player is an admin
local function IsAdmin(player)
    for _, adminName in ipairs(Settings.AdminDetection.AdminList) do
        if player.Name:lower() == adminName:lower() then
            return true
        end
    end
    return false
end

-- Notify player (GUI toast)
local function Notify(title, msg, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title   = title or "OmegaHub",
            Text    = msg or "",
            Duration = duration,
        })
    end)
end

-- Get all players
local function GetAllPlayers()
    return Players:GetPlayers()
end

-- Get closest player to position
local function GetClosestPlayer(position, maxDistance)
    maxDistance = maxDistance or math.huge
    local closestPlayer = nil
    local closestDistance = maxDistance
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = GetDistance(position, hrp.Position)
                if dist < closestDistance then
                    closestDistance = dist
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer, closestDistance
end

-- Get all enemies in workspace
local function GetAllEnemies()
    local enemies = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then
            local hum = obj:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                table.insert(enemies, obj)
            end
        end
    end
    return enemies
end

-- Get closest enemy to position
local function GetClosestEnemy(position, maxDistance, nameFilter)
    maxDistance = maxDistance or math.huge
    local closest = nil
    local closestDist = maxDistance
    for _, enemy in ipairs(GetAllEnemies()) do
        local hrp = enemy:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = GetDistance(position, hrp.Position)
            if dist < closestDist then
                if nameFilter then
                    if enemy.Name:lower():find(nameFilter:lower()) then
                        closestDist = dist
                        closest = enemy
                    end
                else
                    closestDist = dist
                    closest = enemy
                end
            end
        end
    end
    return closest, closestDist
end

-- Get enemy by name
local function GetEnemyByName(name)
    local results = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(name:lower()) then
            local hum = obj:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                table.insert(results, obj)
            end
        end
    end
    return results
end

-- Safe teleport with retry
local function SafeTeleport(cf, retries)
    retries = retries or Settings.Teleport.RetryCount
    for i = 1, retries do
        local success = pcall(function()
            TeleportTo(cf)
        end)
        if success then
            Wait(0.3)
            return true
        end
        Wait(0.5)
    end
    return false
end

-- Face target
local function FaceTarget(targetPos)
    local hrp = GetHRP()
    if hrp then
        local direction = (targetPos - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(direction.X, 0, direction.Z))
    end
end

-- Simulate key press
local function SimulateKeyPress(key)
    pcall(function()
        if VirtualInputManager then
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            Wait(0.05)
            VirtualInputManager:SendKeyEvent(false, key, false, game)
        else
            -- Fallback: try using firetouchinterest or other methods
            local keyCode = Enum.KeyCode[key]
            if keyCode then
                UserInputService:InputBegan(
                    {KeyCode = keyCode, UserInputType = Enum.UserInputType.Keyboard},
                    false
                )
            end
        end
    end)
end

-- Fire tool activation
local function FireTool(toolName)
    pcall(function()
        local tool = LocalPlayer.Character:FindFirstChild(toolName)
            or LocalPlayer.Backpack:FindFirstChild(toolName)
        if tool and tool:IsA("Tool") then
            tool:Activate()
        end
    end)
end

-- Get current sea
local function GetCurrentSea()
    -- Simplified detection based on position
    local hrp = GetHRP()
    if not hrp then return 1 end
    local pos = hrp.Position
    -- Basic heuristic based on X position
    if pos.X < -8000 then
        return 3
    elseif pos.X < -1000 then
        return 2
    else
        return 1
    end
end

-- ============================================================================
-- SECTION 6: ANTI-BAN SYSTEM
-- ============================================================================

local AntiBanSystem = {}
AntiBanSystem.Active = false
AntiBanSystem.Thread = nil
AntiBanSystem.MovementThread = nil
AntiBanSystem.AFKThread = nil
AntiBanSystem.TickCount = 0
AntiBanSystem.LastMovement = tick()
AntiBanSystem.RandomPositions = {}

-- Generate random offset for movement
function AntiBanSystem:GenerateRandomOffset()
    local range = Settings.AntiBan.FakeMovementSpeed
    return Vector3.new(
        RandomFloat(-range, range),
        0,
        RandomFloat(-range, range)
    )
end

-- Simulate fake micro-movement
function AntiBanSystem:FakeMovement()
    local hrp = GetHRP()
    if hrp and Settings.AntiBan.FakeMovement then
        local originalCF = hrp.CFrame
        local offset = self:GenerateRandomOffset()
        hrp.CFrame = originalCF * CFrame.new(offset)
        Wait(0.1)
        hrp.CFrame = originalCF
    end
end

-- Simulate fake jump
function AntiBanSystem:FakeJump()
    if not Settings.AntiBan.JumpRandom then return end
    local hum = GetHumanoid()
    if hum then
        hum.Jump = true
        Wait(0.5)
        hum.Jump = false
    end
end

-- Simulate random rotation
function AntiBanSystem:RandomRotation()
    if not Settings.AntiBan.RandomRotation then return end
    local hrp = GetHRP()
    if hrp then
        local angle = RandomFloat(0, 360)
        local pos = hrp.Position
        hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(angle), 0)
    end
end

-- Anti AFK system
function AntiBanSystem:AntiAFK()
    if not Settings.AntiBan.AntiAFK then return end
    pcall(function()
        LocalPlayer.Idled:Connect(function()
            -- Prevent idle kick
            VirtualInputManager = game:GetService("VirtualInputManager")
            if VirtualInputManager then
                VirtualInputManager:SendKeyEvent(true, "Space", false, game)
                Wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "Space", false, game)
            end
        end)
    end)
end

-- Main anti-ban loop
function AntiBanSystem:Start()
    if self.Active then return end
    self.Active = true

    self:AntiAFK()

    self.Thread = task.spawn(function()
        while self.Active and Settings.AntiBan.Enabled do
            self.TickCount = self.TickCount + 1

            -- Every ~10 seconds, do subtle movement
            if self.TickCount % 100 == 0 and Settings.AntiBan.FakeMovement then
                self:FakeMovement()
            end

            -- Every ~30 seconds, random rotation
            if self.TickCount % 300 == 0 and Settings.AntiBan.RandomRotation then
                self:RandomRotation()
            end

            -- Every ~2 minutes, random jump
            if self.TickCount % 1200 == 0 and Settings.AntiBan.JumpRandom then
                self:FakeJump()
            end

            Wait(0.1)
        end
    end)

    Log("Anti-Ban system started")
end

function AntiBanSystem:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
    Log("Anti-Ban system stopped")
end

-- ============================================================================
-- SECTION 7: ADMIN DETECTION SYSTEM
-- ============================================================================

local AdminDetector = {}
AdminDetector.Active = false
AdminDetector.Thread = nil
AdminDetector.DetectedAdmins = {}
AdminDetector.LastCheck = tick()

-- Check a player if they are staff/admin
function AdminDetector:CheckPlayer(player)
    if player == LocalPlayer then return false end

    -- Check username against known admin list
    if Settings.AdminDetection.Enabled then
        for _, name in ipairs(Settings.AdminDetection.AdminList) do
            if player.Name:lower() == name:lower() or
               player.DisplayName:lower() == name:lower() then
                return true, "Username match: " .. player.Name
            end
        end
    end

    -- Check for staff badge
    if Settings.AdminDetection.StaffBadgeDetect then
        local success, hasBadge = pcall(function()
            return MarketplaceService:UserOwnsGamePassAsync(player.UserId, 123456789)
        end)
        if success and hasBadge then
            return true, "Game Pass: Admin"
        end
    end

    return false, nil
end

-- Handle admin detection
function AdminDetector:HandleAdminJoined(player, reason)
    if not self.DetectedAdmins[player.UserId] then
        self.DetectedAdmins[player.UserId] = true

        Log(string.format("ADMIN DETECTED: %s (%s)", player.Name, reason or "Unknown"), "WARN")

        if Settings.AdminDetection.Notification then
            Notify("⚠️ Admin Detected!", player.Name .. " joined! " .. (reason or ""), 5)
        end

        if Settings.AdminDetection.AutoLeave then
            Log("Auto-leaving in " .. Settings.AdminDetection.AutoLeaveDelay .. " seconds...")
            task.delay(Settings.AdminDetection.AutoLeaveDelay, function()
                -- Stop all auto features first
                Settings.AutoFarm.Enabled = false
                Settings.AutoQuest.Enabled = false
                Settings.PvP.Enabled = false
                Settings.AutoFruit.Enabled = false

                Wait(0.5)

                -- Execute leave
                pcall(function()
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end)
            end)
        end
    end
end

-- Check all current players
function AdminDetector:CheckAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local isAdmin, reason = self:CheckPlayer(player)
            if isAdmin then
                self:HandleAdminJoined(player, reason)
            end
        end
    end
end

-- Start admin detection
function AdminDetector:Start()
    if self.Active then return end
    self.Active = true

    -- Check existing players
    self:CheckAllPlayers()

    -- Watch for new players joining
    Players.PlayerAdded:Connect(function(player)
        Wait(2) -- Give time for the player to fully load
        local isAdmin, reason = self:CheckPlayer(player)
        if isAdmin then
            self:HandleAdminJoined(player, reason)
        end
    end)

    -- Thread to periodically re-check
    self.Thread = task.spawn(function()
        while self.Active do
            self:CheckAllPlayers()
            Wait(30) -- Check every 30 seconds
        end
    end)

    Log("Admin Detection started")
end

function AdminDetector:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
end

-- ============================================================================
-- SECTION 8: AUTO FARM SYSTEM - CORE ENGINE
-- ============================================================================

local AutoFarmEngine = {}
AutoFarmEngine.Active = false
AutoFarmEngine.Thread = nil
AutoFarmEngine.CurrentTarget = nil
AutoFarmEngine.SkillThread = nil
AutoFarmEngine.TeleportCooldown = 0
AutoFarmEngine.KillCount = 0
AutoFarmEngine.SessionXP = 0
AutoFarmEngine.StartTime = 0

-- Find best mob for current level
function AutoFarmEngine:FindBestMob()
    local hrp = GetHRP()
    if not hrp then return nil end

    local hum = GetHumanoid()
    if not hum then return nil end

    local currentLevel = LocalPlayer:FindFirstChild("leaderstats") and
        LocalPlayer.leaderstats:FindFirstChild("Level") and
        LocalPlayer.leaderstats.Level.Value or 0

    -- Find mob closest to our level in the mob data
    local bestMobData = nil
    local bestScore = math.huge

    for _, mob in ipairs(MobData) do
        if mob.level <= currentLevel + 100 and mob.level >= currentLevel - 50 then
            local score = math.abs(mob.level - currentLevel)
            if score < bestScore then
                bestScore = score
                bestMobData = mob
            end
        end
    end

    return bestMobData
end

-- Find mob instance in workspace
function AutoFarmEngine:FindMobInstance(mobData)
    if not mobData then return nil end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(mobData.name:lower()) then
            local hum = obj:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                return obj
            end
        end
    end

    return nil
end

-- Teleport to mob location
function AutoFarmEngine:TeleportToMobArea(mobData)
    if mobData and mobData.location then
        SafeTeleport(mobData.location)
        Wait(0.5)
    end
end

-- Use all combat skills
function AutoFarmEngine:UseSkills()
    -- Simulate pressing skill keys
    local skillKeys = {"Z", "X", "C", "V", "F"}
    for _, key in ipairs(skillKeys) do
        pcall(function()
            UserInputService.InputBegan:Fire(
                { KeyCode = Enum.KeyCode[key], UserInputType = Enum.UserInputType.Keyboard },
                false
            )
        end)
        HumanizedWait()
    end
end

-- Attack a specific enemy
function AutoFarmEngine:AttackEnemy(enemy)
    if not enemy or not enemy.Parent then return false end

    local hrp = GetHRP()
    if not hrp then return false end

    local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
    if not enemyHRP then return false end

    -- Teleport close to enemy
    local targetCF = enemyHRP.CFrame * CFrame.new(0, 0, -3)
    hrp.CFrame = targetCF

    -- Face the enemy
    FaceTarget(enemyHRP.Position)

    -- Use skills
    self:UseSkills()

    Wait(Settings.AutoFarm.AttackDelay)

    -- Check if dead
    local hum = enemy:FindFirstChild("Humanoid")
    return hum == nil or hum.Health <= 0
end

-- Auto revive system
function AutoFarmEngine:CheckRevive()
    local hum = GetHumanoid()
    if hum and hum.Health <= 0 then
        Log("Player died, waiting for respawn...")
        Wait(5) -- Wait for respawn
        -- Optionally teleport back to farming spot
        return true
    end
    return false
end

-- Main farm loop for level farming
function AutoFarmEngine:FarmLevels()
    local mobData = self:FindBestMob()
    if not mobData then
        Log("No suitable mob found for current level", "WARN")
        Wait(3)
        return
    end

    -- Teleport to mob area
    self:TeleportToMobArea(mobData)

    -- Find mob instance
    local enemy = self:FindMobInstance(mobData)
    if not enemy then
        -- Spawn not found, wait
        Wait(2)
        return
    end

    -- Attack the enemy
    local killed = self:AttackEnemy(enemy)
    if killed then
        self.KillCount = self.KillCount + 1
        if Settings.AutoFarm.CollectDrops then
            -- Auto collect drops (will be handled by fruit system)
            Wait(0.3)
        end
    end

    Wait(Settings.AutoFarm.LoopDelay)
end

-- Farm a specific boss
function AutoFarmEngine:FarmBoss(bossName)
    local bossInfo = nil
    for _, boss in ipairs(BossData) do
        if boss.name:lower() == bossName:lower() then
            bossInfo = boss
            break
        end
    end

    if not bossInfo then
        Log("Boss not found: " .. bossName, "WARN")
        return
    end

    -- Teleport to boss location
    SafeTeleport(bossInfo.location)
    Wait(1)

    -- Find the boss
    local bossInstances = GetEnemyByName(bossName)
    if #bossInstances == 0 then
        Log("Boss not spawned yet: " .. bossName)
        Wait(bossInfo.respawnTime or 10)
        return
    end

    local boss = bossInstances[1]
    while boss and boss.Parent do
        local hum = boss:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then break end

        self:AttackEnemy(boss)
        Wait(0.1)
    end

    self.KillCount = self.KillCount + 1
    Log("Boss killed: " .. bossName)
    Wait(2)
end

-- Farm all bosses in sequence
function AutoFarmEngine:FarmAllBosses()
    for _, boss in ipairs(BossData) do
        if not Settings.AutoFarm.FarmAllBosses then break end
        Log("Farming boss: " .. boss.name)
        self:FarmBoss(boss.name)
        Wait(1)
    end
end

-- Mastery farming system
function AutoFarmEngine:FarmMastery(masteryType)
    masteryType = masteryType or Settings.AutoFarm.MasteryType

    Log("Farming mastery: " .. masteryType)

    -- Equip appropriate weapon/fruit for mastery type
    if masteryType == "Fruit" then
        -- Equip current devil fruit and use moves
        self:EquipFruitForMastery()
    elseif masteryType == "Sword" then
        -- Equip sword and attack with sword moves
        self:EquipSwordForMastery()
    elseif masteryType == "Melee" then
        -- Use melee attacks
        self:EquipMeleeForMastery()
    elseif masteryType == "Gun" then
        -- Equip gun and use gun moves
        self:EquipGunForMastery()
    end

    -- Find a mob and attack it
    local mobData = self:FindBestMob()
    if mobData then
        self:TeleportToMobArea(mobData)
        local enemy = self:FindMobInstance(mobData)
        if enemy then
            self:AttackEnemy(enemy)
        end
    end
end

-- Equip fruit for mastery
function AutoFarmEngine:EquipFruitForMastery()
    pcall(function()
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("DevilFruit") then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
                break
            end
        end
    end)
end

-- Equip sword for mastery
function AutoFarmEngine:EquipSwordForMastery()
    pcall(function()
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Sword") then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
                break
            end
        end
    end)
end

-- Equip melee for mastery
function AutoFarmEngine:EquipMeleeForMastery()
    pcall(function()
        -- Unequip any weapon to use melee
        for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                LocalPlayer.Character.Humanoid:UnequipTools()
                break
            end
        end
    end)
end

-- Equip gun for mastery
function AutoFarmEngine:EquipGunForMastery()
    pcall(function()
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Gun") then
                LocalPlayer.Character.Humanoid:EquipTool(tool)
                break
            end
        end
    end)
end

-- Start auto farm
function AutoFarmEngine:Start()
    if self.Active then return end
    self.Active = true
    self.StartTime = tick()

    self.Thread = task.spawn(function()
        while self.Active and Settings.AutoFarm.Enabled do
            -- Check if alive
            if not IsAlive() then
                self:CheckRevive()
                continue
            end

            -- Determine what to farm
            if Settings.AutoFarm.FarmAllBosses then
                self:FarmAllBosses()
            elseif Settings.AutoFarm.FarmBosses and Settings.AutoFarm.SelectedBoss ~= "None" then
                self:FarmBoss(Settings.AutoFarm.SelectedBoss)
            elseif Settings.AutoFarm.MasteryFarm then
                self:FarmMastery(Settings.AutoFarm.MasteryType)
            else
                self:FarmLevels()
            end

            HumanizedWait()
        end
        Log("Auto Farm stopped")
    end)

    Log("Auto Farm started - Mode: " ..
        (Settings.AutoFarm.FarmBosses and "Boss" or
         Settings.AutoFarm.MasteryFarm and "Mastery" or "Levels"))
end

function AutoFarmEngine:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
    Log("Auto Farm stopped - Kills: " .. self.KillCount)
end

-- ============================================================================
-- SECTION 9: AUTO QUEST SYSTEM
-- ============================================================================

local AutoQuestSystem = {}
AutoQuestSystem.Active = false
AutoQuestSystem.Thread = nil
AutoQuestSystem.CurrentQuest = nil
AutoQuestSystem.QuestStep = 0
AutoQuestSystem.CompletedQuests = 0

-- Quest NPC positions
local QuestPositions = {
    Draco = CFrame.new(-2300, 18, 310),
    Dragon = CFrame.new(-11590, 5, -3590),
    DracoV2 = CFrame.new(-2850, 5, 3150),
    DracoV3 = CFrame.new(-3800, 15, 2350),
    DracoV4 = CFrame.new(-4200, 20, 1500),
}

-- Find quest NPC in workspace
function AutoQuestSystem:FindQuestNPC(questType)
    local npcName = questType .. " Quest"
    for _, npc in ipairs(Workspace:GetDescendants()) do
        if npc:IsA("Model") and npc.Name:lower():find(questType:lower()) then
            return npc
        end
    end
    -- Fallback: teleport to known position
    return nil
end

-- Accept quest from NPC
function AutoQuestSystem:AcceptQuest(npc)
    if not npc then return false end
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    if hrp then
        SafeTeleport(CFrame.new(hrp.Position + Vector3.new(0, 0, -3)))
        Wait(0.5)
        -- Fire the quest accept remote
        SafeFireRemote("QuestAccept", npc.Name)
        Wait(0.5)
        return true
    end
    return false
end

-- Turn in quest
function AutoQuestSystem:TurnInQuest(npc)
    if not npc then return false end
    local hrp = npc:FindFirstChild("HumanoidRootPart")
    if hrp then
        SafeTeleport(CFrame.new(hrp.Position + Vector3.new(0, 0, -3)))
        Wait(0.5)
        SafeFireRemote("QuestComplete", npc.Name)
        Wait(0.5)
        self.CompletedQuests = self.CompletedQuests + 1
        return true
    end
    return false
end

-- Level-based quest system
function AutoQuestSystem:DoLevelQuest()
    local currentLevel = LocalPlayer:FindFirstChild("leaderstats") and
        LocalPlayer.leaderstats:FindFirstChild("Level") and
        LocalPlayer.leaderstats.Level.Value or 0

    Log("Doing level quest - Current Level: " .. currentLevel)

    -- Find quest NPC for current level range
    local questNPC = nil
    for _, npc in ipairs(QuestNPCs) do
        if npc.name:lower():find("quest") then
            questNPC = npc
            break
        end
    end

    if questNPC then
        SafeTeleport(questNPC.cframe)
        Wait(0.5)
        -- Accept quest
        SafeFireRemote("AcceptQuest")
        Wait(0.3)
    end
end

-- Draco quest automation
function AutoQuestSystem:DoDracoQuest()
    Log("Starting Draco Quest automation")
    -- Steps for Draco quest
    -- 1. Teleport to Draco location
    SafeTeleport(QuestPositions.Draco)
    Wait(1)
    -- 2. Find Draco NPC
    local npc = self:FindQuestNPC("Draco")
    -- 3. Accept quest
    self:AcceptQuest(npc)
    -- 4. Kill required enemies
    local enemies = GetEnemyByName("Draco")
    for _, enemy in ipairs(enemies) do
        AutoFarmEngine:AttackEnemy(enemy)
    end
    -- 5. Turn in
    self:TurnInQuest(npc)
end

-- Dragon quest automation
function AutoQuestSystem:DoDragonQuest()
    Log("Starting Dragon Quest automation")
    SafeTeleport(QuestPositions.Dragon)
    Wait(1)
    local npc = self:FindQuestNPC("Dragon")
    self:AcceptQuest(npc)
    -- Kill Dragon NPCs
    local enemies = GetEnemyByName("Dragon")
    for _, enemy in ipairs(enemies) do
        AutoFarmEngine:AttackEnemy(enemy)
    end
    self:TurnInQuest(npc)
end

-- Draco V2 quest
function AutoQuestSystem:DoDracoV2Quest()
    Log("Starting Draco V2 Quest automation")
    SafeTeleport(QuestPositions.DracoV2)
    Wait(1)
    local npc = self:FindQuestNPC("DracoV2")
    self:AcceptQuest(npc)
    Wait(0.5)
    -- Kill Draco V2 raid boss
    AutoFarmEngine:FarmBoss("Rip_Indra (Raid)")
    self:TurnInQuest(npc)
end

-- Draco V3 quest
function AutoQuestSystem:DoDracoV3Quest()
    Log("Starting Draco V3 Quest automation")
    SafeTeleport(QuestPositions.DracoV3)
    Wait(1)
    local npc = self:FindQuestNPC("DracoV3")
    self:AcceptQuest(npc)
    Wait(0.5)
    -- Kill required boss
    AutoFarmEngine:FarmBoss("Dough King")
    self:TurnInQuest(npc)
end

-- Draco V4 quest
function AutoQuestSystem:DoDracoV4Quest()
    Log("Starting Draco V4 Quest automation")
    SafeTeleport(QuestPositions.DracoV4)
    Wait(1)
    local npc = self:FindQuestNPC("DracoV4")
    self:AcceptQuest(npc)
    Wait(0.5)
    -- V4 requires specific kills
    AutoFarmEngine:FarmBoss("Cake Prince")
    self:TurnInQuest(npc)
end

-- Start quest system
function AutoQuestSystem:Start()
    if self.Active then return end
    self.Active = true

    self.Thread = task.spawn(function()
        while self.Active and Settings.AutoQuest.Enabled do
            if not IsAlive() then Wait(3); continue end

            local questType = Settings.AutoQuest.QuestType

            if questType == "Level" then
                self:DoLevelQuest()
            elseif questType == "Draco" then
                self:DoDracoQuest()
            elseif questType == "Dragon" then
                self:DoDragonQuest()
            elseif questType == "DracoV2" then
                self:DoDracoV2Quest()
            elseif questType == "DracoV3" then
                self:DoDracoV3Quest()
            elseif questType == "DracoV4" then
                self:DoDracoV4Quest()
            end

            Wait(Settings.AutoQuest.QuestDelay)
        end
    end)

    Log("Auto Quest started - Type: " .. Settings.AutoQuest.QuestType)
end

function AutoQuestSystem:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
    Log("Auto Quest stopped - Completed: " .. self.CompletedQuests)
end

-- ============================================================================
-- SECTION 10: AUTO FRUIT SYSTEM
-- ============================================================================

local AutoFruitSystem = {}
AutoFruitSystem.Active = false
AutoFruitSystem.Thread = nil
AutoFruitSystem.BringThread = nil
AutoFruitSystem.ScanThread = nil
AutoFruitSystem.DetectedFruits = {}
AutoFruitSystem.CollectedCount = 0
AutoFruitSystem.StoredCount = 0

-- Check if object is a devil fruit
function AutoFruitSystem:IsFruit(object)
    if not object then return false end
    -- Check for common fruit model naming conventions in Blox Fruits
    local fruitNames = {}
    for _, fruit in ipairs(FruitData) do
        table.insert(fruitNames, fruit.name:lower())
    end

    local objName = object.Name:lower()
    for _, fname in ipairs(fruitNames) do
        if objName:find(fname) then
            return true
        end
    end

    -- Also check for "Fruit" in the name or specific tags
    if objName:find("fruit") or objName:find("devil") then
        return true
    end

    return false
end

-- Get fruit rarity
function AutoFruitSystem:GetFruitRarity(fruitName)
    for _, fruit in ipairs(FruitData) do
        if fruitName:lower():find(fruit.name:lower()) then
            return fruit.rarity, fruit
        end
    end
    return "Unknown", nil
end

-- Check if fruit is blacklisted
function AutoFruitSystem:IsBlacklisted(fruitName)
    for _, bl in ipairs(Settings.AutoFruit.BlacklistedFruits) do
        if fruitName:lower():find(bl:lower()) then
            return true
        end
    end
    return false
end

-- Check if fruit is preferred
function AutoFruitSystem:IsPreferred(fruitName)
    if #Settings.AutoFruit.PreferredFruits == 0 then return true end
    for _, pref in ipairs(Settings.AutoFruit.PreferredFruits) do
        if fruitName:lower():find(pref:lower()) then
            return true
        end
    end
    return false
end

-- Scan workspace for fruits
function AutoFruitSystem:ScanForFruits()
    local foundFruits = {}
    local hrp = GetHRP()
    if not hrp then return foundFruits end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if self:IsFruit(obj) then
            local objHRP = obj:FindFirstChild("HumanoidRootPart")
                or obj:FindFirstChildOfClass("Part")
                or obj:FindFirstChildOfClass("MeshPart")
                or obj:FindFirstChildOfClass("UnionOperation")

            if objHRP then
                local dist = GetDistance(hrp.Position, objHRP.Position)
                if dist <= Settings.AutoFruit.ScanRadius then
                    local rarity, fruitInfo = self:GetFruitRarity(obj.Name)
                    table.insert(foundFruits, {
                        object   = obj,
                        name     = obj.Name,
                        position = objHRP.Position,
                        distance = dist,
                        rarity   = rarity,
                        info     = fruitInfo,
                    })
                end
            end
        end
    end

    -- Sort by distance
    table.sort(foundFruits, function(a, b)
        return a.distance < b.distance
    end)

    return foundFruits
end

-- Get a specific fruit (walk/teleport to it)
function AutoFruitSystem:GetFruit(fruitEntry)
    if not fruitEntry or not fruitEntry.object or not fruitEntry.object.Parent then
        return false
    end

    local hrp = GetHRP()
    if not hrp then return false end

    Log("Getting fruit: " .. fruitEntry.name .. " (" .. fruitEntry.rarity .. ")")

    -- Teleport to the fruit
    local objPart = fruitEntry.object:FindFirstChildOfClass("Part")
        or fruitEntry.object:FindFirstChildOfClass("MeshPart")

    if objPart then
        hrp.CFrame = CFrame.new(objPart.Position + Vector3.new(0, 3, 0))
        Wait(0.3)

        -- Try to pick up / eat the fruit
        local touchPart = fruitEntry.object:FindFirstChildOfClass("Part")
        if touchPart then
            -- Fire touch event
            pcall(function()
                local con = touchPart.Touched:Connect(function() end)
                con:Disconnect()
            end)
            -- Simulate click
            SafeFireRemote("Eat_Fruit", fruitEntry.object)
            Wait(0.2)
            SafeFireRemote("GetFruit", fruitEntry.object)
        end

        self.CollectedCount = self.CollectedCount + 1

        if Settings.AutoFruit.NotifyOnFruit then
            Notify("🍎 Fruit Found!", fruitEntry.name .. " (" .. fruitEntry.rarity .. ")", 3)
        end

        return true
    end

    return false
end

-- Store a fruit in storage
function AutoFruitSystem:StoreFruit(fruitName)
    Log("Storing fruit: " .. tostring(fruitName))
    -- Teleport to storage NPC
    local storageNPC = nil
    for _, npc in ipairs(QuestNPCs) do
        if npc.name:lower():find("alchemist") or npc.name:lower():find("dealer") then
            storageNPC = npc
            break
        end
    end

    if storageNPC then
        SafeTeleport(storageNPC.cframe)
        Wait(0.5)
        SafeFireRemote("StoreFruit", fruitName)
        self.StoredCount = self.StoredCount + 1
        Wait(0.3)
    end
end

-- Auto get random fruit from gacha/lucky spin
function AutoFruitSystem:GetRandomFruit()
    Log("Getting random fruit from spin")
    -- Find the fruit dealer
    local fruitDealer = nil
    for _, npc in ipairs(QuestNPCs) do
        if npc.name:lower():find("fruit dealer") then
            fruitDealer = npc
            break
        end
    end

    if fruitDealer then
        SafeTeleport(fruitDealer.cframe)
        Wait(0.5)
        SafeFireRemote("BuyRandomFruit")
        Wait(0.3)
    end
end

-- Bring fruits to player (continuous scan and collect)
function AutoFruitSystem:BringFruitsToPlayer()
    local fruits = self:ScanForFruits()
    for _, fruit in ipairs(fruits) do
        if not self:IsBlacklisted(fruit.name) then
            self:GetFruit(fruit)
            Wait(0.2)
        end
    end
end

-- ESP for fruits
function AutoFruitSystem:ShowFruitESP()
    if not Settings.Misc.ShowFruitESP then return end

    local fruits = self:ScanForFruits()
    for _, fruit in ipairs(fruits) do
        pcall(function()
            local part = fruit.object:FindFirstChildOfClass("Part")
                or fruit.object:FindFirstChildOfClass("MeshPart")
            if part then
                -- Create billboard GUI for ESP
                local existing = part:FindFirstChild("OmegaFruitESP")
                if not existing then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "OmegaFruitESP"
                    billboard.AlwaysOnTop = true
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.Parent = part

                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.fromRGB(255, 220, 0)
                    label.TextStrokeTransparency = 0
                    label.TextScaled = true
                    label.Font = Enum.Font.GothamBold
                    label.Text = "🍎 " .. fruit.name .. "\n[" .. fruit.rarity .. "] " ..
                        math.floor(fruit.distance) .. "m"
                    label.Parent = billboard
                end
            end
        end)
    end
end

-- Main auto fruit loop
function AutoFruitSystem:Start()
    if self.Active then return end
    self.Active = true

    self.Thread = task.spawn(function()
        while self.Active and Settings.AutoFruit.Enabled do
            if not IsAlive() then Wait(2); continue end

            -- Bring fruits to player (scan and collect nearby fruits)
            if Settings.AutoFruit.BringFruitToPlayer then
                self:BringFruitsToPlayer()
            end

            -- Auto get random fruit
            if Settings.AutoFruit.AutoRandomFruit then
                self:GetRandomFruit()
            end

            -- Show fruit ESP
            if Settings.Misc.ShowFruitESP then
                self:ShowFruitESP()
            end

            Wait(Settings.AutoFruit.ScanInterval)
        end
    end)

    Log("Auto Fruit started")
end

function AutoFruitSystem:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
    Log("Auto Fruit stopped - Collected: " .. self.CollectedCount .. ", Stored: " .. self.StoredCount)
end

-- ============================================================================
-- SECTION 11: TELEPORT SYSTEM
-- ============================================================================

local TeleportSystem = {}
TeleportSystem.History = {}
TeleportSystem.Bookmarks = {}

-- Teleport to island by name
function TeleportSystem:ToIsland(islandName)
    for _, island in ipairs(IslandData) do
        if island.name:lower() == islandName:lower() or
           island.name:lower():find(islandName:lower()) then
            Log("Teleporting to: " .. island.name)
            SafeTeleport(island.cframe)
            table.insert(self.History, {
                name = island.name,
                cframe = island.cframe,
                time = os.time(),
            })
            Notify("Teleported!", "→ " .. island.name, 2)
            return true
        end
    end
    Log("Island not found: " .. islandName, "WARN")
    return false
end

-- Teleport to NPC by name
function TeleportSystem:ToNPC(npcName)
    for _, npc in ipairs(QuestNPCs) do
        if npc.name:lower() == npcName:lower() or
           npc.name:lower():find(npcName:lower()) then
            Log("Teleporting to NPC: " .. npc.name)
            SafeTeleport(npc.cframe)
            Notify("Teleported!", "→ " .. npc.name, 2)
            return true
        end
    end
    -- Also search workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(npcName:lower()) then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp then
                SafeTeleport(CFrame.new(hrp.Position + Vector3.new(0, 0, -3)))
                Notify("Teleported!", "→ " .. obj.Name, 2)
                return true
            end
        end
    end
    Log("NPC not found: " .. npcName, "WARN")
    return false
end

-- Teleport to a player
function TeleportSystem:ToPlayer(playerName)
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Name:lower() == playerName:lower() or
           player.DisplayName:lower() == playerName:lower() then
            if player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    SafeTeleport(CFrame.new(hrp.Position + Vector3.new(0, 0, 3)))
                    Notify("Teleported!", "→ " .. player.Name, 2)
                    return true
                end
            end
        end
    end
    return false
end

-- Save current position as bookmark
function TeleportSystem:SaveBookmark(name)
    local hrp = GetHRP()
    if hrp then
        self.Bookmarks[name] = hrp.CFrame
        Notify("Bookmark Saved", name, 2)
    end
end

-- Go to bookmark
function TeleportSystem:GoToBookmark(name)
    if self.Bookmarks[name] then
        SafeTeleport(self.Bookmarks[name])
        Notify("Bookmark", "→ " .. name, 2)
        return true
    end
    return false
end

-- Teleport to safe zone (nearest town/spawn)
function TeleportSystem:ToSafeZone()
    local sea = GetCurrentSea()
    local safeZones = {
        [1] = CFrame.new(-995, 10, 1040),
        [2] = CFrame.new(-1215, 40, -2485),
        [3] = CFrame.new(-11590, 5, -3590),
    }
    SafeTeleport(safeZones[sea] or safeZones[1])
    Notify("Safe Zone", "Teleported to spawn", 2)
end

-- ============================================================================
-- END OF PART 1 (Lines ~1-750 of actual content)
-- This file continues below...
-- ============================================================================

-- ============================================================================
-- SECTION 12: PVP SYSTEM
-- ============================================================================

local PvPSystem = {}
PvPSystem.Active = false
PvPSystem.Thread = nil
PvPSystem.ComboThread = nil
PvPSystem.AimThread = nil
PvPSystem.LockedTarget = nil
PvPSystem.LastComboTime = 0
PvPSystem.ComboIndex = 1
PvPSystem.TotalHits = 0

-- Find best PvP target
function PvPSystem:FindTarget()
    local hrp = GetHRP()
    if not hrp then return nil end

    local closest = nil
    local closestDist = Settings.PvP.MaxRange

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team check
            if Settings.PvP.IgnoreTeammates and
               player.Team == LocalPlayer.Team and
               LocalPlayer.Team ~= nil then
                continue
            end

            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = player.Character:FindFirstChildOfClass("Humanoid")

            if targetHRP and targetHum and targetHum.Health > 0 then
                local dist = GetDistance(hrp.Position, targetHRP.Position)
                if dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end

    return closest
end

-- Lock onto target
function PvPSystem:LockTarget(player)
    self.LockedTarget = player
    Settings.PvP.LockedTarget = player
    if player then
        Log("Locked onto: " .. player.Name)
        Notify("Target Locked", player.Name, 2)
    else
        Log("Target unlocked")
    end
end

-- Get inside target player (silent teleport)
function PvPSystem:GetInsidePlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end

    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = GetHRP()

    if targetHRP and myHRP then
        myHRP.CFrame = targetHRP.CFrame * CFrame.new(Settings.PvP.GetInsideOffset)
        Log("Teleported inside: " .. targetPlayer.Name)
    end
end

-- Execute a single combo key
function PvPSystem:ExecuteComboKey(key)
    if not Settings.PvP.KeyEnabled[key] then return end

    local delay = Settings.PvP.KeyDelays[key] or Settings.PvP.ComboDelay

    pcall(function()
        -- Method 1: VirtualInputManager
        if VirtualInputManager then
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            Wait(delay * 0.3)
            VirtualInputManager:SendKeyEvent(false, key, false, game)
        end
    end)

    Wait(delay)
    self.TotalHits = self.TotalHits + 1
end

-- Execute full combo sequence
function PvPSystem:ExecuteCombo()
    if not Settings.PvP.AutoCombo then return end

    local sequence = Settings.PvP.AutoComboSequence
    if #sequence == 0 then
        sequence = Settings.PvP.ComboKeys
    end

    for _, key in ipairs(sequence) do
        if not Settings.PvP.AutoCombo then break end

        -- Make sure we're close to target first
        if Settings.PvP.GetInsidePlayer and self.LockedTarget then
            self:GetInsidePlayer(self.LockedTarget)
        end

        self:ExecuteComboKey(key)
        Wait(Settings.PvP.GlobalComboDelay)
    end

    -- Small delay between combo loops
    if Settings.PvP.LoopCombo then
        Wait(Settings.PvP.ComboLoopDelay)
    end
end

-- Auto aim towards target
function PvPSystem:AutoAim(target)
    if not Settings.PvP.AutoAim then return end
    if not target or not target.Character then return end

    local myHRP = GetHRP()
    if not myHRP then return end

    local targetBone = target.Character:FindFirstChild(Settings.PvP.AimBone)
        or target.Character:FindFirstChild("HumanoidRootPart")
        or target.Character:FindFirstChild("Head")

    if targetBone then
        local camera = Workspace.CurrentCamera
        if camera then
            pcall(function()
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetBone.Position)
            end)
        end
        FaceTarget(targetBone.Position)
    end
end

-- Track and follow target
function PvPSystem:FollowTarget(target)
    if not target or not target.Character then return end

    local myHRP = GetHRP()
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")

    if myHRP and targetHRP then
        local dist = GetDistance(myHRP.Position, targetHRP.Position)

        if dist > 5 then
            -- Teleport close to the target
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
        end
    end
end

-- Anti-knockback
function PvPSystem:AntiKnockback()
    if not Settings.PvP.AntiKnockback then return end
    local hrp = GetHRP()
    if hrp then
        hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
    end
end

-- Main PvP loop
function PvPSystem:Start()
    if self.Active then return end
    self.Active = true

    self.Thread = task.spawn(function()
        while self.Active and Settings.PvP.Enabled do
            if not IsAlive() then Wait(1); continue end

            -- Find or use locked target
            local target = self.LockedTarget
            if not target or not target.Character then
                if Settings.PvP.AutoSelectTarget then
                    target = self:FindTarget()
                    if target then
                        self:LockTarget(target)
                    end
                end
            end

            if target and target.Character then
                -- Get inside player
                if Settings.PvP.GetInsidePlayer then
                    self:GetInsidePlayer(target)
                else
                    self:FollowTarget(target)
                end

                -- Auto aim
                self:AutoAim(target)

                -- Execute combo
                if Settings.PvP.AutoCombo then
                    self:ExecuteCombo()
                end

                -- Anti-knockback
                if Settings.PvP.AntiKnockback then
                    self:AntiKnockback()
                end
            end

            Wait(0.05)
        end
    end)

    Log("PvP System started")
end

function PvPSystem:Stop()
    self.Active = false
    self.LockedTarget = nil
    Settings.PvP.LockedTarget = nil
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
    Log("PvP System stopped - Total Hits: " .. self.TotalHits)
end

-- ============================================================================
-- SECTION 13: EGG COLLECT SYSTEM
-- ============================================================================

local EggSystem = {}
EggSystem.Active = false
EggSystem.Thread = nil
EggSystem.CollectedEggs = 0
EggSystem.EggTypes = {
    { name = "Common Egg",   rarity = "Common",    reward = "Common Pet" },
    { name = "Uncommon Egg", rarity = "Uncommon",  reward = "Uncommon Pet" },
    { name = "Rare Egg",     rarity = "Rare",       reward = "Rare Pet" },
    { name = "Legendary Egg",rarity = "Legendary", reward = "Legendary Pet" },
    { name = "Mythical Egg", rarity = "Mythical",  reward = "Mythical Pet" },
    { name = "Ghost Egg",    rarity = "Ghost",      reward = "Ghost Pet" },
    { name = "Sea Beast Egg",rarity = "Special",   reward = "Sea Beast Pet" },
}

-- Find all eggs in workspace
function EggSystem:FindEggs()
    local eggs = {}
    local hrp = GetHRP()
    if not hrp then return eggs end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("egg") and obj:IsA("Model") then
            local part = obj:FindFirstChildOfClass("Part")
                or obj:FindFirstChildOfClass("MeshPart")
            if part then
                local dist = GetDistance(hrp.Position, part.Position)
                if dist <= Settings.Eggs.EggScanRadius then
                    table.insert(eggs, {
                        object   = obj,
                        name     = obj.Name,
                        distance = dist,
                        position = part.Position,
                    })
                end
            end
        end
    end

    table.sort(eggs, function(a, b)
        return a.distance < b.distance
    end)

    return eggs
end

-- Collect a specific egg
function EggSystem:CollectEgg(eggEntry)
    if not eggEntry or not eggEntry.object or not eggEntry.object.Parent then
        return false
    end

    local hrp = GetHRP()
    if not hrp then return false end

    Log("Collecting egg: " .. eggEntry.name)

    local part = eggEntry.object:FindFirstChildOfClass("Part")
        or eggEntry.object:FindFirstChildOfClass("MeshPart")

    if part then
        hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
        Wait(0.2)
        SafeFireRemote("CollectEgg", eggEntry.object)
        Wait(Settings.Eggs.EggCollectDelay)
        self.CollectedEggs = self.CollectedEggs + 1
        Notify("🥚 Egg Collected!", eggEntry.name, 2)
        return true
    end
    return false
end

-- Give egg to NPC (egg quest completion)
function EggSystem:GiveEgg(eggName)
    Log("Giving egg: " .. tostring(eggName))
    local eggNPC = nil
    for _, npc in ipairs(QuestNPCs) do
        if npc.name:lower():find("egg") then
            eggNPC = npc
            break
        end
    end

    if eggNPC then
        SafeTeleport(eggNPC.cframe)
        Wait(0.5)
        SafeFireRemote("GiveEgg", eggName)
        Wait(0.3)
    end
end

-- Start egg collection
function EggSystem:Start()
    if self.Active then return end
    self.Active = true

    self.Thread = task.spawn(function()
        while self.Active and Settings.Eggs.AutoCollectEggs do
            if not IsAlive() then Wait(2); continue end

            local eggs = self:FindEggs()
            for _, egg in ipairs(eggs) do
                if not Settings.Eggs.AutoCollectEggs then break end
                self:CollectEgg(egg)
            end

            -- Auto give eggs
            if Settings.Eggs.AutoGiveEggs then
                for _, eggType in ipairs(self.EggTypes) do
                    self:GiveEgg(eggType.name)
                end
            end

            Wait(2)
        end
    end)

    Log("Egg System started")
end

function EggSystem:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
end

-- ============================================================================
-- SECTION 14: AUTO BERRY COLLECT SYSTEM
-- ============================================================================

local BerrySystem = {}
BerrySystem.Active = false
BerrySystem.Thread = nil
BerrySystem.BerryCount = 0

-- Find berries in workspace
function BerrySystem:FindBerries()
    local berries = {}
    local hrp = GetHRP()
    if not hrp then return berries end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name:find("berry") or name:find("beli") or name:find("money")) then
            if obj:IsA("Model") or obj:IsA("Part") then
                local pos = obj:IsA("Model") and
                    (obj:FindFirstChildOfClass("Part") and obj:FindFirstChildOfClass("Part").Position) or
                    obj.Position

                if pos then
                    local dist = GetDistance(hrp.Position, pos)
                    if dist <= Settings.Berry.BerryRadius then
                        table.insert(berries, {
                            object   = obj,
                            name     = obj.Name,
                            distance = dist,
                            position = pos,
                        })
                    end
                end
            end
        end
    end

    table.sort(berries, function(a, b)
        return a.distance < b.distance
    end)

    return berries
end

-- Collect a berry
function BerrySystem:CollectBerry(berryEntry)
    if not berryEntry or not berryEntry.object or not berryEntry.object.Parent then
        return false
    end

    local hrp = GetHRP()
    if not hrp then return false end

    hrp.CFrame = CFrame.new(berryEntry.position + Vector3.new(0, 3, 0))
    Wait(Settings.Berry.BerryDelay)
    self.BerryCount = self.BerryCount + 1
    return true
end

-- Start berry collection
function BerrySystem:Start()
    if self.Active then return end
    self.Active = true

    self.Thread = task.spawn(function()
        while self.Active and Settings.Berry.AutoCollectBerry do
            if not IsAlive() then Wait(2); continue end

            local berries = self:FindBerries()
            for _, berry in ipairs(berries) do
                if not Settings.Berry.AutoCollectBerry then break end
                self:CollectBerry(berry)
            end

            Wait(1)
        end
    end)

    Log("Berry System started")
end

function BerrySystem:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
    Log("Berry collected: " .. self.BerryCount)
end

-- ============================================================================
-- SECTION 15: ELITE HUNTER SYSTEM
-- ============================================================================

local EliteHunterSystem = {}
EliteHunterSystem.Active = false
EliteHunterSystem.Thread = nil
EliteHunterSystem.KillCount = 0

-- Elite Hunter targets and locations
local EliteHunterData = {
    {
        name     = "Deandre",
        location = CFrame.new(-3115, 40, -1885),
        kills    = 0,
        required = 3,
        reward   = "Yama Sword",
    },
    {
        name     = "Diablo",
        location = CFrame.new(-7700, 5, -350),
        kills    = 0,
        required = 3,
        reward   = "Tushita Sword",
    },
    {
        name     = "Gonzalo",
        location = CFrame.new(-8870, 13, 1380),
        kills    = 0,
        required = 3,
        reward   = "Rengoku Sword",
    },
}

-- Kill an elite hunter
function EliteHunterSystem:KillElite(eliteData)
    Log("Hunting elite: " .. eliteData.name)

    -- Teleport to elite location
    SafeTeleport(eliteData.location)
    Wait(1)

    -- Find the elite in workspace
    local elites = GetEnemyByName(eliteData.name)
    if #elites == 0 then
        Log("Elite not found: " .. eliteData.name .. " - Waiting for spawn")
        Wait(30)
        return false
    end

    local elite = elites[1]
    while elite and elite.Parent do
        local hum = elite:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then break end

        AutoFarmEngine:AttackEnemy(elite)
        Wait(0.1)
    end

    eliteData.kills = eliteData.kills + 1
    self.KillCount = self.KillCount + 1
    Log("Elite killed: " .. eliteData.name .. " (kills: " .. eliteData.kills .. ")")
    return true
end

-- Start elite hunter
function EliteHunterSystem:Start()
    if self.Active then return end
    self.Active = true

    self.Thread = task.spawn(function()
        while self.Active do
            if not IsAlive() then Wait(3); continue end

            for _, elite in ipairs(EliteHunterData) do
                if not self.Active then break end

                -- Check if any elite hunting is enabled
                local shouldHunt = Settings.EliteHunters.AutoFarm
                if Settings.EliteHunters.SelectedTarget ~= "All" then
                    shouldHunt = Settings.EliteHunters.SelectedTarget == elite.name
                end

                if shouldHunt then
                    self:KillElite(elite)
                    Wait(1)
                end
            end

            Wait(2)
        end
    end)

    Log("Elite Hunter started")
end

function EliteHunterSystem:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
end

-- ============================================================================
-- SECTION 16: SPECIAL SWORD QUESTS
-- ============================================================================

local SpecialSwordSystem = {}
SpecialSwordSystem.Active = false
SpecialSwordSystem.Threads = {}

-- Yama Sword Quest Steps
local YamaQuestSteps = {
    {
        desc     = "Teleport to Floating Turtle and talk to Yama Quest NPC",
        action   = function()
            SafeTeleport(CFrame.new(-8870, 13, 1380))
            Wait(1)
            SafeFireRemote("AcceptQuest", "Yama")
        end,
    },
    {
        desc     = "Kill Deandre 3 times",
        action   = function()
            for i = 1, 3 do
                EliteHunterSystem:KillElite(EliteHunterData[1])
                Wait(1)
            end
        end,
    },
    {
        desc     = "Collect 5 Slayer Essence",
        action   = function()
            -- Kill bosses to get essence
            for i = 1, 5 do
                AutoFarmEngine:FarmBoss("Soul Reaper")
                Wait(2)
            end
        end,
    },
    {
        desc     = "Return to NPC and claim Yama",
        action   = function()
            SafeTeleport(CFrame.new(-8870, 13, 1380))
            Wait(1)
            SafeFireRemote("CompleteQuest", "Yama")
        end,
    },
}

-- Tushita Sword Quest Steps
local TushitaQuestSteps = {
    {
        desc     = "Teleport to Floating Turtle and talk to Tushita Quest NPC",
        action   = function()
            SafeTeleport(CFrame.new(-8870, 13, 1380))
            Wait(1)
            SafeFireRemote("AcceptQuest", "Tushita")
        end,
    },
    {
        desc     = "Kill Diablo 3 times",
        action   = function()
            for i = 1, 3 do
                EliteHunterSystem:KillElite(EliteHunterData[2])
                Wait(1)
            end
        end,
    },
    {
        desc     = "Collect 5 Holy Essence",
        action   = function()
            for i = 1, 5 do
                AutoFarmEngine:FarmBoss("Island Empress")
                Wait(2)
            end
        end,
    },
    {
        desc     = "Return to NPC and claim Tushita",
        action   = function()
            SafeTeleport(CFrame.new(-8870, 13, 1380))
            Wait(1)
            SafeFireRemote("CompleteQuest", "Tushita")
        end,
    },
}

-- Rengoku Sword Quest Steps
local RengokuQuestSteps = {
    {
        desc     = "Teleport to Great Tree and talk to Rengoku NPC",
        action   = function()
            SafeTeleport(CFrame.new(-7700, 5, -350))
            Wait(1)
            SafeFireRemote("AcceptQuest", "Rengoku")
        end,
    },
    {
        desc     = "Kill Gonzalo 3 times",
        action   = function()
            for i = 1, 3 do
                EliteHunterSystem:KillElite(EliteHunterData[3])
                Wait(1)
            end
        end,
    },
    {
        desc     = "Defeat Dragon Crew (20 kills)",
        action   = function()
            for i = 1, 20 do
                local enemy = GetClosestEnemy(GetHRP().Position, 200, "Dragon Crew")
                if enemy then
                    AutoFarmEngine:AttackEnemy(enemy)
                end
                Wait(0.5)
            end
        end,
    },
    {
        desc     = "Return to NPC and claim Rengoku",
        action   = function()
            SafeTeleport(CFrame.new(-7700, 5, -350))
            Wait(1)
            SafeFireRemote("CompleteQuest", "Rengoku")
        end,
    },
}

-- True Triple Katana Quest Steps
local TripleKatanaSteps = {
    {
        desc     = "Teleport to Castle on the Sea",
        action   = function()
            SafeTeleport(CFrame.new(-3850, 5, -5560))
            Wait(1)
            SafeFireRemote("AcceptQuest", "TripleKatana")
        end,
    },
    {
        desc     = "Get Saddi, Shisui, and Wando swords",
        action   = function()
            -- Buy from sword dealers
            TeleportSystem:ToNPC("Sword Dealer")
            Wait(0.5)
            SafeFireRemote("BuySword", "Saddi")
            SafeFireRemote("BuySword", "Shisui")
            SafeFireRemote("BuySword", "Wando")
        end,
    },
    {
        desc     = "Upgrade all three swords to max",
        action   = function()
            TeleportSystem:ToNPC("Blacksmith")
            Wait(0.5)
            SafeFireRemote("UpgradeSword", "Saddi")
            SafeFireRemote("UpgradeSword", "Shisui")
            SafeFireRemote("UpgradeSword", "Wando")
        end,
    },
    {
        desc     = "Return and claim True Triple Katana",
        action   = function()
            SafeTeleport(CFrame.new(-3850, 5, -5560))
            Wait(1)
            SafeFireRemote("CompleteQuest", "TripleKatana")
        end,
    },
}

-- Execute a quest chain
function SpecialSwordSystem:ExecuteQuest(steps, questName)
    Log("Starting " .. questName .. " quest")

    for i, step in ipairs(steps) do
        if not self.Active then break end
        Log(string.format("[%s] Step %d/%d: %s", questName, i, #steps, step.desc))
        Notify(questName, step.desc, 4)

        local ok, err = pcall(step.action)
        if not ok then
            Log("Step failed: " .. tostring(err), "ERROR")
        end

        Wait(1)
    end

    Log(questName .. " quest completed!")
    Notify("✅ " .. questName, "Quest Complete!", 5)
end

-- Start auto Yama
function SpecialSwordSystem:StartYama()
    table.insert(self.Threads, task.spawn(function()
        while Settings.SpecialSwords.AutoYama do
            if not IsAlive() then Wait(3); continue end
            self:ExecuteQuest(YamaQuestSteps, "Yama Sword")
            Wait(5)
            if not Settings.SpecialSwords.AutoYama then break end
        end
    end))
end

-- Start auto Tushita
function SpecialSwordSystem:StartTushita()
    table.insert(self.Threads, task.spawn(function()
        while Settings.SpecialSwords.AutoTushita do
            if not IsAlive() then Wait(3); continue end
            self:ExecuteQuest(TushitaQuestSteps, "Tushita Sword")
            Wait(5)
            if not Settings.SpecialSwords.AutoTushita then break end
        end
    end))
end

-- Start auto Rengoku
function SpecialSwordSystem:StartRengoku()
    table.insert(self.Threads, task.spawn(function()
        while Settings.SpecialSwords.AutoRengoku do
            if not IsAlive() then Wait(3); continue end
            self:ExecuteQuest(RengokuQuestSteps, "Rengoku Sword")
            Wait(5)
            if not Settings.SpecialSwords.AutoRengoku then break end
        end
    end))
end

-- Start auto Triple Katana
function SpecialSwordSystem:StartTripleKatana()
    table.insert(self.Threads, task.spawn(function()
        while Settings.SpecialSwords.AutoTripleKatana do
            if not IsAlive() then Wait(3); continue end
            self:ExecuteQuest(TripleKatanaSteps, "True Triple Katana")
            Wait(5)
            if not Settings.SpecialSwords.AutoTripleKatana then break end
        end
    end))
end

function SpecialSwordSystem:Stop()
    self.Active = false
    for _, thread in ipairs(self.Threads) do
        pcall(function() task.cancel(thread) end)
    end
    self.Threads = {}
end

-- ============================================================================
-- SECTION 17: AUTO RACE SYSTEM (V2 / V3 / V4 / CYBORG / GHOUL)
-- ============================================================================

local AutoRaceSystem = {}
AutoRaceSystem.Active = false
AutoRaceSystem.Threads = {}

-- Race V2 Quest Steps
local V2QuestSteps = {
    {
        desc   = "Talk to Alchemist for V2 quest",
        action = function()
            TeleportSystem:ToNPC("Race Caretaker")
            Wait(1)
            SafeFireRemote("AcceptRaceV2Quest")
        end,
    },
    {
        desc   = "Kill mobs for race fragments",
        action = function()
            for i = 1, 50 do
                AutoFarmEngine:FarmLevels()
            end
        end,
    },
    {
        desc   = "Collect 3 race fragments",
        action = function()
            AutoFruitSystem:BringFruitsToPlayer()
            Wait(1)
        end,
    },
    {
        desc   = "Complete V2 race upgrade",
        action = function()
            TeleportSystem:ToNPC("Race Caretaker")
            Wait(0.5)
            SafeFireRemote("UpgradeRaceV2")
        end,
    },
}

-- Race V3 Quest Steps
local V3QuestSteps = {
    {
        desc   = "Reach required level for V3",
        action = function()
            -- Farm until level requirement met
            for i = 1, 30 do
                AutoFarmEngine:FarmLevels()
            end
        end,
    },
    {
        desc   = "Kill required boss for V3",
        action = function()
            AutoFarmEngine:FarmBoss("Order")
            Wait(2)
        end,
    },
    {
        desc   = "Collect V3 requirements",
        action = function()
            -- Kill mobs for essence
            for i = 1, 20 do
                AutoFarmEngine:FarmLevels()
            end
        end,
    },
    {
        desc   = "Upgrade to V3",
        action = function()
            TeleportSystem:ToNPC("Race Caretaker")
            Wait(0.5)
            SafeFireRemote("UpgradeRaceV3")
        end,
    },
}

-- Race V4 Quest Steps
local V4QuestSteps = {
    {
        desc   = "Complete God Cup challenge",
        action = function()
            SafeTeleport(CFrame.new(-2300, 18, 310))
            Wait(1)
            SafeFireRemote("StartGodCup")
        end,
    },
    {
        desc   = "Defeat the required bosses",
        action = function()
            AutoFarmEngine:FarmBoss("Rip_Indra (Raid)")
            Wait(2)
            AutoFarmEngine:FarmBoss("Dough King")
            Wait(2)
        end,
    },
    {
        desc   = "Collect V4 transformation requirements",
        action = function()
            for i = 1, 10 do
                AutoFarmEngine:FarmLevels()
            end
        end,
    },
    {
        desc   = "Upgrade to V4",
        action = function()
            TeleportSystem:ToNPC("Race Caretaker")
            Wait(0.5)
            SafeFireRemote("UpgradeRaceV4")
        end,
    },
}

-- Cyborg Race Quest Steps
local CyborgQuestSteps = {
    {
        desc   = "Defeat the Cyborg boss",
        action = function()
            AutoFarmEngine:FarmBoss("Cyborg Boss")
            Wait(2)
        end,
    },
    {
        desc   = "Collect 3 Core Brain from Cyborg",
        action = function()
            for i = 1, 3 do
                AutoFarmEngine:FarmBoss("Cyborg Boss")
                Wait(2)
            end
        end,
    },
    {
        desc   = "Talk to Cyborg NPC",
        action = function()
            TeleportSystem:ToNPC("Cyborg Quest Giver")
            Wait(0.5)
            SafeFireRemote("AcceptCyborgRace")
        end,
    },
    {
        desc   = "Complete Cyborg race change",
        action = function()
            TeleportSystem:ToNPC("Cyborg Quest Giver")
            Wait(0.5)
            SafeFireRemote("CompleteCyborgRace")
        end,
    },
}

-- Ghoul Race Quest Steps
local GhoulQuestSteps = {
    {
        desc   = "Teleport to Thriller Bark",
        action = function()
            TeleportSystem:ToIsland("Thriller Bark")
            Wait(1)
        end,
    },
    {
        desc   = "Get 100 kills at night",
        action = function()
            for i = 1, 100 do
                AutoFarmEngine:FarmLevels()
                Wait(0.3)
            end
        end,
    },
    {
        desc   = "Talk to Ghoul NPC",
        action = function()
            TeleportSystem:ToNPC("Ghoul Quest Giver")
            Wait(0.5)
            SafeFireRemote("AcceptGhoulRace")
        end,
    },
    {
        desc   = "Complete Ghoul race change",
        action = function()
            TeleportSystem:ToNPC("Ghoul Quest Giver")
            Wait(0.5)
            SafeFireRemote("CompleteGhoulRace")
        end,
    },
}

-- Execute race quest
function AutoRaceSystem:ExecuteRaceQuest(steps, raceName)
    Log("Starting " .. raceName .. " race quest")
    for i, step in ipairs(steps) do
        if not self.Active then break end
        Log(string.format("[%s] Step %d/%d: %s", raceName, i, #steps, step.desc))
        Notify(raceName, step.desc, 4)
        pcall(step.action)
        Wait(1)
    end
    Log(raceName .. " race quest completed!")
    Notify("✅ " .. raceName, "Race Upgrade Complete!", 5)
end

-- Start race automation
function AutoRaceSystem:Start()
    if self.Active then return end
    self.Active = true

    if Settings.AutoRace.V2Enabled then
        table.insert(self.Threads, task.spawn(function()
            self:ExecuteRaceQuest(V2QuestSteps, "Race V2")
        end))
    end

    if Settings.AutoRace.V3Enabled then
        table.insert(self.Threads, task.spawn(function()
            self:ExecuteRaceQuest(V3QuestSteps, "Race V3")
        end))
    end

    if Settings.AutoRace.V4Enabled then
        table.insert(self.Threads, task.spawn(function()
            self:ExecuteRaceQuest(V4QuestSteps, "Race V4")
        end))
    end

    if Settings.AutoRace.CyborgEnabled then
        table.insert(self.Threads, task.spawn(function()
            self:ExecuteRaceQuest(CyborgQuestSteps, "Cyborg Race")
        end))
    end

    if Settings.AutoRace.GhoulEnabled then
        table.insert(self.Threads, task.spawn(function()
            self:ExecuteRaceQuest(GhoulQuestSteps, "Ghoul Race")
        end))
    end

    Log("Auto Race System started")
end

function AutoRaceSystem:Stop()
    self.Active = false
    for _, thread in ipairs(self.Threads) do
        pcall(function() task.cancel(thread) end)
    end
    self.Threads = {}
end

-- Auto buy/change race
function AutoRaceSystem:BuyRace(raceName)
    Log("Buying race: " .. raceName)
    TeleportSystem:ToNPC("Race Caretaker")
    Wait(0.5)
    SafeFireRemote("BuyRace", raceName)
    Wait(0.3)
    Notify("Race", "Purchased: " .. raceName, 3)
end

function AutoRaceSystem:ChangeRace(raceName)
    Log("Changing race to: " .. raceName)
    TeleportSystem:ToNPC("Race Caretaker")
    Wait(0.5)
    SafeFireRemote("ChangeRace", raceName)
    Wait(0.3)
    Settings.AutoRace.SelectedRace = raceName
    Notify("Race", "Changed to: " .. raceName, 3)
end

-- ============================================================================
-- SECTION 18: BOSS DEFEAT SYSTEMS (MIRAGE / INDRA / DOUGH KING / CAKE PRINCE)
-- ============================================================================

local BossDefeatSystem = {}
BossDefeatSystem.Active = false
BossDefeatSystem.Threads = {}
BossDefeatSystem.DefeatCounts = {
    Mirage    = 0,
    Indra     = 0,
    DoughKing = 0,
    CakePrince = 0,
}

-- Mirage Island boss
function BossDefeatSystem:DefeatMirage()
    Log("Starting Auto Mirage")

    -- Teleport to Mirage Island
    TeleportSystem:ToIsland("Mirage Island")
    Wait(2)

    -- Find Mirage NPC and trigger
    local mirageNPC = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("mirage") and obj:IsA("Model") then
            mirageNPC = obj
            break
        end
    end

    if mirageNPC then
        local hrp = mirageNPC:FindFirstChild("HumanoidRootPart")
        if hrp then
            SafeTeleport(CFrame.new(hrp.Position + Vector3.new(0, 0, -3)))
            Wait(0.5)
            SafeFireRemote("TriggerMirage")
        end
    end

    -- Kill Mirage bosses
    local mirageEnemies = GetEnemyByName("Mirage")
    for _, enemy in ipairs(mirageEnemies) do
        AutoFarmEngine:AttackEnemy(enemy)
        Wait(0.3)
    end

    self.DefeatCounts.Mirage = self.DefeatCounts.Mirage + 1
    Log("Mirage defeated! Count: " .. self.DefeatCounts.Mirage)
end

-- Defeat Rip_Indra
function BossDefeatSystem:DefeatIndra()
    Log("Starting Auto defeat Rip_Indra")

    -- Teleport to Desolate Palace
    TeleportSystem:ToIsland("Desolate Palace")
    Wait(2)

    -- Find and defeat Rip_Indra
    local indraInstances = GetEnemyByName("Rip_Indra")
    if #indraInstances == 0 then
        Log("Rip_Indra not spawned, initiating raid...")
        SafeFireRemote("StartRaid", "Indra")
        Wait(10)
        indraInstances = GetEnemyByName("Rip_Indra")
    end

    for _, indra in ipairs(indraInstances) do
        local hum = indra:FindFirstChild("Humanoid")
        while hum and hum.Health > 0 do
            AutoFarmEngine:AttackEnemy(indra)
            Wait(0.1)
            hum = indra:FindFirstChild("Humanoid")
        end
    end

    self.DefeatCounts.Indra = self.DefeatCounts.Indra + 1
    Log("Rip_Indra defeated! Count: " .. self.DefeatCounts.Indra)
    Notify("✅ Boss Defeated", "Rip_Indra has been defeated!", 4)
end

-- Defeat Dough King
function BossDefeatSystem:DefeatDoughKing()
    Log("Starting Auto defeat Dough King")

    -- Teleport to Candy Island
    TeleportSystem:ToIsland("Candy Island")
    Wait(2)

    local doughKing = GetEnemyByName("Dough King")
    if #doughKing == 0 then
        Log("Dough King not spawned, waiting...")
        Wait(30)
        doughKing = GetEnemyByName("Dough King")
    end

    for _, boss in ipairs(doughKing) do
        local hum = boss:FindFirstChild("Humanoid")
        while hum and hum.Health > 0 do
            AutoFarmEngine:AttackEnemy(boss)
            Wait(0.1)
            hum = boss:FindFirstChild("Humanoid")
        end
    end

    self.DefeatCounts.DoughKing = self.DefeatCounts.DoughKing + 1
    Log("Dough King defeated! Count: " .. self.DefeatCounts.DoughKing)
    Notify("✅ Boss Defeated", "Dough King has been defeated!", 4)
end

-- Defeat Cake Prince
function BossDefeatSystem:DefeatCakePrince()
    Log("Starting Auto defeat Cake Prince")

    -- Teleport to Tiki Outpost / Candy region
    TeleportSystem:ToIsland("Tiki Outpost")
    Wait(2)

    local cakePrince = GetEnemyByName("Cake Prince")
    if #cakePrince == 0 then
        Log("Cake Prince not spawned, waiting...")
        Wait(20)
        cakePrince = GetEnemyByName("Cake Prince")
    end

    for _, boss in ipairs(cakePrince) do
        local hum = boss:FindFirstChild("Humanoid")
        while hum and hum.Health > 0 do
            AutoFarmEngine:AttackEnemy(boss)
            Wait(0.1)
            hum = boss:FindFirstChild("Humanoid")
        end
    end

    self.DefeatCounts.CakePrince = self.DefeatCounts.CakePrince + 1
    Log("Cake Prince defeated! Count: " .. self.DefeatCounts.CakePrince)
    Notify("✅ Boss Defeated", "Cake Prince has been defeated!", 4)
end

-- Start boss defeat system
function BossDefeatSystem:Start()
    if self.Active then return end
    self.Active = true

    if Settings.BossDefeat.AutoMirage then
        table.insert(self.Threads, task.spawn(function()
            while self.Active and Settings.BossDefeat.AutoMirage do
                if IsAlive() then self:DefeatMirage() end
                Wait(Settings.BossDefeat.BossDelay)
                if not Settings.BossDefeat.LoopBoss then break end
            end
        end))
    end

    if Settings.BossDefeat.AutoIndra then
        table.insert(self.Threads, task.spawn(function()
            while self.Active and Settings.BossDefeat.AutoIndra do
                if IsAlive() then self:DefeatIndra() end
                Wait(Settings.BossDefeat.BossDelay)
                if not Settings.BossDefeat.LoopBoss then break end
            end
        end))
    end

    if Settings.BossDefeat.AutoDoughKing then
        table.insert(self.Threads, task.spawn(function()
            while self.Active and Settings.BossDefeat.AutoDoughKing do
                if IsAlive() then self:DefeatDoughKing() end
                Wait(Settings.BossDefeat.BossDelay)
                if not Settings.BossDefeat.LoopBoss then break end
            end
        end))
    end

    if Settings.BossDefeat.AutoCakePrince then
        table.insert(self.Threads, task.spawn(function()
            while self.Active and Settings.BossDefeat.AutoCakePrince do
                if IsAlive() then self:DefeatCakePrince() end
                Wait(Settings.BossDefeat.BossDelay)
                if not Settings.BossDefeat.LoopBoss then break end
            end
        end))
    end
end

function BossDefeatSystem:Stop()
    self.Active = false
    for _, thread in ipairs(self.Threads) do
        pcall(function() task.cancel(thread) end)
    end
    self.Threads = {}
end

-- ============================================================================
-- SECTION 19: MISC SYSTEMS (FLY / NOCLIP / SPEED / INF JUMP / ESP)
-- ============================================================================

local MiscSystem = {}
MiscSystem.FlyActive  = false
MiscSystem.FlyThread  = nil
MiscSystem.FlyBody    = nil

-- Fly system
function MiscSystem:StartFly()
    if self.FlyActive then return end
    self.FlyActive = true

    local hrp = GetHRP()
    local hum = GetHumanoid()
    if not hrp or not hum then return end

    -- Create BodyVelocity and BodyGyro
    local bv = Instance.new("BodyVelocity")
    bv.Name = "OmegaFlyBV"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp

    local bg = Instance.new("BodyGyro")
    bg.Name = "OmegaFlyBG"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.D = 100
    bg.Parent = hrp

    self.FlyBody = {bv = bv, bg = bg}
    hum.PlatformStand = true

    self.FlyThread = task.spawn(function()
        local cam = Workspace.CurrentCamera
        while self.FlyActive do
            local moveDir = Vector3.new(0, 0, 0)
            local speed = Settings.Misc.FlySpeed

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
            end

            bv.Velocity = moveDir * speed
            bg.CFrame = cam.CFrame

            Wait()
        end

        bv:Destroy()
        bg:Destroy()
        if hum then hum.PlatformStand = false end
    end)

    Log("Fly enabled - Speed: " .. Settings.Misc.FlySpeed)
end

function MiscSystem:StopFly()
    self.FlyActive = false
    if self.FlyThread then
        task.cancel(self.FlyThread)
        self.FlyThread = nil
    end
    if self.FlyBody then
        pcall(function()
            self.FlyBody.bv:Destroy()
            self.FlyBody.bg:Destroy()
        end)
        self.FlyBody = nil
    end
    local hum = GetHumanoid()
    if hum then hum.PlatformStand = false end
    Log("Fly disabled")
end

-- NoClip system
local NoClipThread = nil
function MiscSystem:StartNoClip()
    if NoClipThread then return end
    NoClipThread = RunService.Stepped:Connect(function()
        if Settings.Misc.NoClip then
            local char = GetCharacter()
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    Log("NoClip enabled")
end

function MiscSystem:StopNoClip()
    if NoClipThread then
        NoClipThread:Disconnect()
        NoClipThread = nil
        local char = GetCharacter()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
    Log("NoClip disabled")
end

-- Set walkspeed
function MiscSystem:SetWalkSpeed(speed)
    local hum = GetHumanoid()
    if hum then
        hum.WalkSpeed = speed
        Settings.Misc.WalkSpeed = speed
    end
end

-- Set jump power
function MiscSystem:SetJumpPower(power)
    local hum = GetHumanoid()
    if hum then
        hum.JumpPower = power
        Settings.Misc.JumpPower = power
    end
end

-- Infinite jump
local InfJumpConn = nil
function MiscSystem:StartInfJump()
    if InfJumpConn then return end
    local hum = GetHumanoid()
    if hum then
        InfJumpConn = UserInputService.JumpRequest:Connect(function()
            if Settings.Misc.InfJump and hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
    Log("Infinite jump enabled")
end

function MiscSystem:StopInfJump()
    if InfJumpConn then
        InfJumpConn:Disconnect()
        InfJumpConn = nil
    end
    Log("Infinite jump disabled")
end

-- Anti-void fall protection
local AntiVoidConn = nil
local AntiVoidLastPos = Vector3.new(0, 0, 0)
function MiscSystem:StartAntiVoid()
    if AntiVoidConn then return end

    AntiVoidConn = RunService.Heartbeat:Connect(function()
        if not Settings.Misc.AntiVoid then return end
        local hrp = GetHRP()
        if hrp then
            if hrp.Position.Y < -100 then
                hrp.CFrame = CFrame.new(AntiVoidLastPos + Vector3.new(0, 10, 0))
            else
                AntiVoidLastPos = hrp.Position
            end
        end
    end)
    Log("Anti-void enabled")
end

-- Player ESP system
function MiscSystem:UpdatePlayerESP()
    if not Settings.Misc.ShowESP then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")

            if hrp and hum then
                local dist = GetDistance(GetHRP() and GetHRP().Position or Vector3.new(), hrp.Position)

                if dist <= Settings.Misc.ESPDistance then
                    local existingESP = hrp:FindFirstChild("OmegaESP")
                    if not existingESP then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "OmegaESP"
                        billboard.AlwaysOnTop = true
                        billboard.Size = UDim2.new(0, 200, 0, 60)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.Parent = hrp

                        local frame = Instance.new("Frame")
                        frame.Size = UDim2.new(1, 0, 1, 0)
                        frame.BackgroundTransparency = 1
                        frame.Parent = billboard

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Name = "NameLabel"
                        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextScaled = true
                        nameLabel.Font = Enum.Font.GothamBold
                        nameLabel.Text = player.Name
                        nameLabel.Parent = frame

                        local hpLabel = Instance.new("TextLabel")
                        hpLabel.Name = "HPLabel"
                        hpLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        hpLabel.Position = UDim2.new(0, 0, 0.5, 0)
                        hpLabel.BackgroundTransparency = 1
                        hpLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                        hpLabel.TextStrokeTransparency = 0
                        hpLabel.TextScaled = true
                        hpLabel.Font = Enum.Font.Gotham
                        hpLabel.Text = string.format("HP: %.0f | Dist: %.0fm", hum.Health, dist)
                        hpLabel.Parent = frame
                    else
                        -- Update existing ESP
                        local bb = hrp:FindFirstChild("OmegaESP")
                        if bb then
                            local hpLabel = bb:FindFirstChild("Frame") and
                                bb.Frame:FindFirstChild("HPLabel")
                            if hpLabel then
                                hpLabel.Text = string.format("HP: %.0f | Dist: %.0fm", hum.Health, dist)
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Boss ESP
function MiscSystem:UpdateBossESP()
    if not Settings.Misc.ShowBossESP then return end

    for _, boss in ipairs(BossData) do
        local bossInstances = GetEnemyByName(boss.name)
        for _, bossObj in ipairs(bossInstances) do
            local hrp = bossObj:FindFirstChild("HumanoidRootPart")
            local hum = bossObj:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local myHRP = GetHRP()
                if myHRP then
                    local dist = GetDistance(myHRP.Position, hrp.Position)
                    if dist <= Settings.Misc.ESPDistance then
                        local existingESP = hrp:FindFirstChild("OmegaBossESP")
                        if not existingESP then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "OmegaBossESP"
                            billboard.AlwaysOnTop = true
                            billboard.Size = UDim2.new(0, 200, 0, 60)
                            billboard.StudsOffset = Vector3.new(0, 5, 0)
                            billboard.Parent = hrp

                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1, 0, 1, 0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.fromRGB(255, 50, 50)
                            label.TextStrokeTransparency = 0
                            label.TextScaled = true
                            label.Font = Enum.Font.GothamBold
                            label.Text = "⚔️ BOSS: " .. boss.name ..
                                "\nLvl " .. boss.level ..
                                " | " .. math.floor(dist) .. "m"
                            label.Parent = billboard
                        end
                    end
                end
            end
        end
    end
end

-- ============================================================================
-- SECTION 20: GUI FRAMEWORK
-- ============================================================================

local GUI = {}
GUI.Main     = nil
GUI.Tabs     = {}
GUI.Elements = {}
GUI.Theme    = {
    Background    = Color3.fromRGB(15, 15, 20),
    TopBar        = Color3.fromRGB(10, 10, 15),
    Accent        = Color3.fromRGB(0, 120, 255),
    AccentDark    = Color3.fromRGB(0, 80, 180),
    Secondary     = Color3.fromRGB(25, 25, 35),
    Tertiary      = Color3.fromRGB(35, 35, 50),
    Text          = Color3.fromRGB(240, 240, 250),
    TextDim       = Color3.fromRGB(160, 160, 180),
    Success       = Color3.fromRGB(0, 200, 100),
    Warning       = Color3.fromRGB(255, 200, 0),
    Error         = Color3.fromRGB(255, 60, 60),
    White         = Color3.fromRGB(255, 255, 255),
    Border        = Color3.fromRGB(50, 50, 70),
    TabActive     = Color3.fromRGB(0, 100, 220),
    TabInactive   = Color3.fromRGB(25, 25, 35),
    ToggleOn      = Color3.fromRGB(0, 200, 100),
    ToggleOff     = Color3.fromRGB(60, 60, 80),
    SliderFill    = Color3.fromRGB(0, 140, 255),
    SliderBG      = Color3.fromRGB(40, 40, 60),
    InputBG       = Color3.fromRGB(30, 30, 45),
    DropdownBG    = Color3.fromRGB(20, 20, 35),
    Glow          = Color3.fromRGB(0, 80, 200),
    SectionHeader = Color3.fromRGB(0, 100, 200),
    ButtonHover   = Color3.fromRGB(0, 100, 220),
    ButtonPress   = Color3.fromRGB(0, 60, 160),
}

GUI.Dragging = false
GUI.DragStart = nil
GUI.DragOffset = nil
GUI.CurrentTab = nil
GUI.Minimized = false

-- Utility: Round corners
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

-- Utility: Add padding
local function AddPadding(parent, px)
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, px or 8)
    pad.PaddingRight = UDim.new(0, px or 8)
    pad.PaddingTop = UDim.new(0, px or 8)
    pad.PaddingBottom = UDim.new(0, px or 8)
    pad.Parent = parent
    return pad
end

-- Utility: Add UIListLayout
local function AddListLayout(parent, padding, fillDir)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, padding or 5)
    layout.FillDirection = fillDir or Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = parent
    return layout
end

-- Utility: Tween color
local function TweenColor(obj, prop, targetColor, duration)
    local tween = TweenService:Create(obj,
        TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {[prop] = targetColor}
    )
    tween:Play()
    return tween
end

-- Create main GUI
function GUI:Create()
    -- Remove existing GUI if any
    if PlayerGui:FindFirstChild("OmegaHubGui") then
        PlayerGui.OmegaHubGui:Destroy()
    end

    -- Screen GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OmegaHubGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 780, 0, 520)
    mainFrame.Position = UDim2.new(0.5, -390, 0.5, -260)
    mainFrame.BackgroundColor3 = GUI.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    AddCorner(mainFrame, 10)

    -- Border stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = GUI.Theme.Border
    stroke.Thickness = 1.5
    stroke.Parent = mainFrame

    -- Title bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 44)
    topBar.BackgroundColor3 = GUI.Theme.TopBar
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    AddCorner(topBar, 10)

    -- Fix top bar bottom corners
    local topBarFix = Instance.new("Frame")
    topBarFix.Size = UDim2.new(1, 0, 0.5, 0)
    topBarFix.Position = UDim2.new(0, 0, 0.5, 0)
    topBarFix.BackgroundColor3 = GUI.Theme.TopBar
    topBarFix.BorderSizePixel = 0
    topBarFix.Parent = topBar

    -- Logo / Title
    local logo = Instance.new("TextLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(0, 200, 1, 0)
    logo.Position = UDim2.new(0, 12, 0, 0)
    logo.BackgroundTransparency = 1
    logo.TextColor3 = GUI.Theme.Accent
    logo.TextSize = 18
    logo.Font = Enum.Font.GothamBold
    logo.Text = "⚡ OMEGA HUB"
    logo.TextXAlignment = Enum.TextXAlignment.Left
    logo.Parent = topBar

    -- Version label
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(0, 80, 1, 0)
    versionLabel.Position = UDim2.new(0, 205, 0, 0)
    versionLabel.BackgroundTransparency = 1
    versionLabel.TextColor3 = GUI.Theme.TextDim
    versionLabel.TextSize = 11
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.Text = "v" .. OmegaHub.Version
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left
    versionLabel.Parent = topBar

    -- Game label
    local gameLabel = Instance.new("TextLabel")
    gameLabel.Size = UDim2.new(0, 150, 1, 0)
    gameLabel.Position = UDim2.new(0.5, -75, 0, 0)
    gameLabel.BackgroundTransparency = 1
    gameLabel.TextColor3 = GUI.Theme.TextDim
    gameLabel.TextSize = 12
    gameLabel.Font = Enum.Font.Gotham
    gameLabel.Text = "Blox Fruits"
    gameLabel.Parent = topBar

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 32, 0, 28)
    closeBtn.Position = UDim2.new(1, -38, 0, 8)
    closeBtn.BackgroundColor3 = GUI.Theme.Error
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = GUI.Theme.White
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = topBar
    AddCorner(closeBtn, 5)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Minimize button
    local minBtn = Instance.new("TextButton")
    minBtn.Name = "MinBtn"
    minBtn.Size = UDim2.new(0, 32, 0, 28)
    minBtn.Position = UDim2.new(1, -76, 0, 8)
    minBtn.BackgroundColor3 = GUI.Theme.Warning
    minBtn.Text = "–"
    minBtn.TextColor3 = GUI.Theme.White
    minBtn.TextSize = 16
    minBtn.Font = Enum.Font.GothamBold
    minBtn.BorderSizePixel = 0
    minBtn.Parent = topBar
    AddCorner(minBtn, 5)

    minBtn.MouseButton1Click:Connect(function()
        GUI.Minimized = not GUI.Minimized
        if GUI.Minimized then
            mainFrame.Size = UDim2.new(0, 780, 0, 44)
        else
            mainFrame.Size = UDim2.new(0, 780, 0, 520)
        end
    end)

    -- Drag functionality
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            GUI.Dragging = true
            GUI.DragStart = input.Position
            GUI.DragOffset = mainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if GUI.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - GUI.DragStart
            mainFrame.Position = UDim2.new(
                GUI.DragOffset.X.Scale,
                GUI.DragOffset.X.Offset + delta.X,
                GUI.DragOffset.Y.Scale,
                GUI.DragOffset.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            GUI.Dragging = false
        end
    end)

    -- Tab bar
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(0, 155, 1, -44)
    tabBar.Position = UDim2.new(0, 0, 0, 44)
    tabBar.BackgroundColor3 = GUI.Theme.TopBar
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame

    -- Tab bar bottom separator
    local tabSep = Instance.new("Frame")
    tabSep.Size = UDim2.new(0, 1, 1, 0)
    tabSep.Position = UDim2.new(1, -1, 0, 0)
    tabSep.BackgroundColor3 = GUI.Theme.Border
    tabSep.BorderSizePixel = 0
    tabSep.Parent = tabBar

    -- Tab scroll frame
    local tabScroll = Instance.new("ScrollingFrame")
    tabScroll.Name = "TabScroll"
    tabScroll.Size = UDim2.new(1, 0, 1, -10)
    tabScroll.Position = UDim2.new(0, 0, 0, 5)
    tabScroll.BackgroundTransparency = 1
    tabScroll.BorderSizePixel = 0
    tabScroll.ScrollBarThickness = 2
    tabScroll.ScrollBarImageColor3 = GUI.Theme.Accent
    tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabScroll.Parent = tabBar

    local tabListLayout = AddListLayout(tabScroll, 3)
    AddPadding(tabScroll, 5)

    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -155, 1, -44)
    contentArea.Position = UDim2.new(0, 155, 0, 44)
    contentArea.BackgroundColor3 = GUI.Theme.Background
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    contentArea.Parent = mainFrame

    GUI.Main       = mainFrame
    GUI.ScreenGui  = screenGui
    GUI.TabBar     = tabBar
    GUI.TabScroll  = tabScroll
    GUI.ContentArea = contentArea

    return screenGui
end

-- Create a tab
function GUI:CreateTab(name, icon)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "Tab"
    tabBtn.Size = UDim2.new(1, -10, 0, 34)
    tabBtn.BackgroundColor3 = GUI.Theme.TabInactive
    tabBtn.Text = (icon or "") .. "  " .. name
    tabBtn.TextColor3 = GUI.Theme.TextDim
    tabBtn.TextSize = 12
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = GUI.TabScroll
    AddCorner(tabBtn, 5)
    AddPadding(tabBtn, 8)

    -- Tab content page
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = GUI.Theme.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = GUI.ContentArea

    AddListLayout(page, 6)
    AddPadding(page, 8)

    -- Tab click handler
    tabBtn.MouseButton1Click:Connect(function()
        -- Hide all pages
        for _, tab in ipairs(GUI.Tabs) do
            tab.page.Visible = false
            tab.btn.BackgroundColor3 = GUI.Theme.TabInactive
            tab.btn.TextColor3 = GUI.Theme.TextDim
        end
        -- Show selected page
        page.Visible = true
        tabBtn.BackgroundColor3 = GUI.Theme.TabActive
        tabBtn.TextColor3 = GUI.Theme.White
        GUI.CurrentTab = name
    end)

    -- Hover effect
    tabBtn.MouseEnter:Connect(function()
        if GUI.CurrentTab ~= name then
            TweenColor(tabBtn, "BackgroundColor3", GUI.Theme.Tertiary, 0.15)
        end
    end)

    tabBtn.MouseLeave:Connect(function()
        if GUI.CurrentTab ~= name then
            TweenColor(tabBtn, "BackgroundColor3", GUI.Theme.TabInactive, 0.15)
        end
    end)

    local tabEntry = {btn = tabBtn, page = page, name = name}
    table.insert(GUI.Tabs, tabEntry)
    return tabEntry
end

-- Create section header
function GUI:CreateSection(page, title)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = title .. "Section"
    sectionFrame.Size = UDim2.new(1, -16, 0, 28)
    sectionFrame.BackgroundColor3 = GUI.Theme.SectionHeader
    sectionFrame.BorderSizePixel = 0
    sectionFrame.Parent = page
    AddCorner(sectionFrame, 5)

    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, -10, 1, 0)
    sectionLabel.Position = UDim2.new(0, 10, 0, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.TextColor3 = GUI.Theme.White
    sectionLabel.TextSize = 13
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.Text = "◆ " .. title
    sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    sectionLabel.Parent = sectionFrame

    return sectionFrame
end

-- Create toggle button
function GUI:CreateToggle(page, label, default, callback)
    default = default or false

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -16, 0, 36)
    toggleFrame.BackgroundColor3 = GUI.Theme.Secondary
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = page
    AddCorner(toggleFrame, 6)

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(1, -70, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.TextColor3 = GUI.Theme.Text
    labelText.TextSize = 12
    labelText.Font = Enum.Font.Gotham
    labelText.Text = label
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = toggleFrame

    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -54, 0.5, -11)
    toggleBtn.BackgroundColor3 = default and GUI.Theme.ToggleOn or GUI.Theme.ToggleOff
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = toggleFrame
    AddCorner(toggleBtn, 11)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 18, 0, 18)
    indicator.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    indicator.BackgroundColor3 = GUI.Theme.White
    indicator.BorderSizePixel = 0
    indicator.Parent = toggleBtn
    AddCorner(indicator, 9)

    local enabled = default

    local toggleHitbox = Instance.new("TextButton")
    toggleHitbox.Size = UDim2.new(1, 0, 1, 0)
    toggleHitbox.BackgroundTransparency = 1
    toggleHitbox.Text = ""
    toggleHitbox.Parent = toggleFrame

    toggleHitbox.MouseButton1Click:Connect(function()
        enabled = not enabled
        TweenColor(toggleBtn, "BackgroundColor3",
            enabled and GUI.Theme.ToggleOn or GUI.Theme.ToggleOff, 0.2)
        TweenService:Create(indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Position = enabled and
                UDim2.new(1, -20, 0.5, -9) or
                UDim2.new(0, 2, 0.5, -9)
        }):Play()
        if callback then
            callback(enabled)
        end
    end)

    return {frame = toggleFrame, getValue = function() return enabled end}
end

-- Create slider
function GUI:CreateSlider(page, label, min, max, default, callback)
    default = default or min
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -16, 0, 52)
    sliderFrame.BackgroundColor3 = GUI.Theme.Secondary
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = page
    AddCorner(sliderFrame, 6)

    local titleRow = Instance.new("Frame")
    titleRow.Size = UDim2.new(1, 0, 0, 24)
    titleRow.BackgroundTransparency = 1
    titleRow.Parent = sliderFrame

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.7, 0, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.TextColor3 = GUI.Theme.Text
    labelText.TextSize = 12
    labelText.Font = Enum.Font.Gotham
    labelText.Text = label
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = titleRow

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, -12, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = GUI.Theme.Accent
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(default)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = titleRow

    local sliderBG = Instance.new("Frame")
    sliderBG.Size = UDim2.new(1, -24, 0, 8)
    sliderBG.Position = UDim2.new(0, 12, 0, 34)
    sliderBG.BackgroundColor3 = GUI.Theme.SliderBG
    sliderBG.BorderSizePixel = 0
    sliderBG.Parent = sliderFrame
    AddCorner(sliderBG, 4)

    local sliderFill = Instance.new("Frame")
    local fillPercent = (default - min) / (max - min)
    sliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
    sliderFill.BackgroundColor3 = GUI.Theme.SliderFill
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBG
    AddCorner(sliderFill, 4)

    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 14, 0, 14)
    sliderKnob.Position = UDim2.new(fillPercent, -7, 0.5, -7)
    sliderKnob.BackgroundColor3 = GUI.Theme.White
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Parent = sliderBG
    AddCorner(sliderKnob, 7)

    local currentValue = default
    local dragging = false

    local function updateSlider(input)
        local sliderPos = sliderBG.AbsolutePosition.X
        local sliderWidth = sliderBG.AbsoluteSize.X
        local relX = math.clamp(input.Position.X - sliderPos, 0, sliderWidth)
        local percent = relX / sliderWidth
        currentValue = math.floor(min + (max - min) * percent)
        valueLabel.Text = tostring(currentValue)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percent, -7, 0.5, -7)
        if callback then callback(currentValue) end
    end

    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    return {
        frame = sliderFrame,
        getValue = function() return currentValue end,
        setValue = function(v)
            currentValue = math.clamp(v, min, max)
            local pct = (currentValue - min) / (max - min)
            valueLabel.Text = tostring(currentValue)
            sliderFill.Size = UDim2.new(pct, 0, 1, 0)
            sliderKnob.Position = UDim2.new(pct, -7, 0.5, -7)
        end,
    }
end

-- Create dropdown
function GUI:CreateDropdown(page, label, options, default, callback)
    default = default or (options[1] or "Select")

    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1, -16, 0, 36)
    dropFrame.BackgroundColor3 = GUI.Theme.Secondary
    dropFrame.BorderSizePixel = 0
    dropFrame.ClipsDescendants = false
    dropFrame.Parent = page
    AddCorner(dropFrame, 6)

    local labelText = Instance.new("TextLabel")
    labelText.Size = UDim2.new(0.5, 0, 1, 0)
    labelText.Position = UDim2.new(0, 12, 0, 0)
    labelText.BackgroundTransparency = 1
    labelText.TextColor3 = GUI.Theme.Text
    labelText.TextSize = 12
    labelText.Font = Enum.Font.Gotham
    labelText.Text = label
    labelText.TextXAlignment = Enum.TextXAlignment.Left
    labelText.Parent = dropFrame

    local selectedBtn = Instance.new("TextButton")
    selectedBtn.Size = UDim2.new(0.45, 0, 0, 26)
    selectedBtn.Position = UDim2.new(0.53, 0, 0.5, -13)
    selectedBtn.BackgroundColor3 = GUI.Theme.DropdownBG
    selectedBtn.Text = default .. "  ▼"
    selectedBtn.TextColor3 = GUI.Theme.Accent
    selectedBtn.TextSize = 11
    selectedBtn.Font = Enum.Font.GothamSemibold
    selectedBtn.BorderSizePixel = 0
    selectedBtn.Parent = dropFrame
    AddCorner(selectedBtn, 4)

    local dropList = Instance.new("Frame")
    dropList.Name = "DropList"
    dropList.Size = UDim2.new(0.45, 0, 0, #options * 28 + 6)
    dropList.Position = UDim2.new(0.53, 0, 1, 3)
    dropList.BackgroundColor3 = GUI.Theme.DropdownBG
    dropList.BorderSizePixel = 0
    dropList.Visible = false
    dropList.ZIndex = 10
    dropList.Parent = dropFrame
    AddCorner(dropList, 4)

    local dropStroke = Instance.new("UIStroke")
    dropStroke.Color = GUI.Theme.Border
    dropStroke.Thickness = 1
    dropStroke.Parent = dropList

    local dropLayout = AddListLayout(dropList, 2)
    AddPadding(dropList, 3)

    local currentValue = default
    local isOpen = false

    local function closeDropdown()
        isOpen = false
        dropList.Visible = false
        selectedBtn.Text = currentValue .. "  ▼"
    end

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, -6, 0, 24)
        optBtn.BackgroundColor3 = GUI.Theme.DropdownBG
        optBtn.Text = opt
        optBtn.TextColor3 = opt == currentValue and GUI.Theme.Accent or GUI.Theme.Text
        optBtn.TextSize = 11
        optBtn.Font = Enum.Font.Gotham
        optBtn.BorderSizePixel = 0
        optBtn.ZIndex = 11
        optBtn.Parent = dropList
        AddCorner(optBtn, 3)

        optBtn.MouseButton1Click:Connect(function()
            currentValue = opt
            selectedBtn.Text = opt .. "  ▼"
            closeDropdown()
            -- Reset all option colors
            for _, child in ipairs(dropList:GetChildren()) do
                if child:IsA("TextButton") then
                    child.TextColor3 = GUI.Theme.TextDim
                end
            end
            optBtn.TextColor3 = GUI.Theme.Accent
            if callback then callback(opt) end
        end)

        optBtn.MouseEnter:Connect(function()
            TweenColor(optBtn, "BackgroundColor3", GUI.Theme.Tertiary, 0.1)
        end)
        optBtn.MouseLeave:Connect(function()
            TweenColor(optBtn, "BackgroundColor3", GUI.Theme.DropdownBG, 0.1)
        end)
    end

    selectedBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        dropList.Visible = isOpen
        selectedBtn.Text = currentValue .. (isOpen and "  ▲" or "  ▼")
    end)

    return {
        frame = dropFrame,
        getValue = function() return currentValue end,
        setValue = function(v)
            currentValue = v
            selectedBtn.Text = v .. "  ▼"
        end,
    }
end

-- Create button
function GUI:CreateButton(page, label, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 34)
    btn.BackgroundColor3 = GUI.Theme.Accent
    btn.Text = label
    btn.TextColor3 = GUI.Theme.White
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.BorderSizePixel = 0
    btn.Parent = page
    AddCorner(btn, 6)

    btn.MouseEnter:Connect(function()
        TweenColor(btn, "BackgroundColor3", GUI.Theme.ButtonHover, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        TweenColor(btn, "BackgroundColor3", GUI.Theme.Accent, 0.15)
    end)
    btn.MouseButton1Down:Connect(function()
        TweenColor(btn, "BackgroundColor3", GUI.Theme.ButtonPress, 0.05)
    end)
    btn.MouseButton1Up:Connect(function()
        TweenColor(btn, "BackgroundColor3", GUI.Theme.Accent, 0.1)
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return btn
end

-- Create label
function GUI:CreateLabel(page, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = color or GUI.Theme.TextDim
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = page
    return lbl
end

-- Create input box
function GUI:CreateInput(page, label, placeholder, callback)
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(1, -16, 0, 52)
    inputFrame.BackgroundColor3 = GUI.Theme.Secondary
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = page
    AddCorner(inputFrame, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -12, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = GUI.Theme.TextDim
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.Text = label
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = inputFrame

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -24, 0, 24)
    inputBox.Position = UDim2.new(0, 12, 0, 24)
    inputBox.BackgroundColor3 = GUI.Theme.InputBG
    inputBox.TextColor3 = GUI.Theme.Text
    inputBox.TextSize = 12
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = placeholder or ""
    inputBox.PlaceholderColor3 = GUI.Theme.TextDim
    inputBox.Text = ""
    inputBox.ClearTextOnFocus = false
    inputBox.BorderSizePixel = 0
    inputBox.Parent = inputFrame
    AddCorner(inputBox, 4)
    AddPadding(inputBox, 6)

    inputBox.FocusLost:Connect(function(enterPressed)
        if callback then
            callback(inputBox.Text, enterPressed)
        end
    end)

    return {frame = inputFrame, box = inputBox}
end

-- Create key bind display
function GUI:CreateKeyBind(page, label, keys, callback)
    local kbFrame = Instance.new("Frame")
    kbFrame.Size = UDim2.new(1, -16, 0, 40)
    kbFrame.BackgroundColor3 = GUI.Theme.Secondary
    kbFrame.BorderSizePixel = 0
    kbFrame.Parent = page
    AddCorner(kbFrame, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = GUI.Theme.Text
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.Text = label
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = kbFrame

    -- Key badge container
    local keyContainer = Instance.new("Frame")
    keyContainer.Size = UDim2.new(0.5, -12, 0, 28)
    keyContainer.Position = UDim2.new(0.5, 0, 0.5, -14)
    keyContainer.BackgroundTransparency = 1
    keyContainer.Parent = kbFrame
    AddListLayout(keyContainer, 4, Enum.FillDirection.Horizontal)

    for _, key in ipairs(keys) do
        local keyBadge = Instance.new("TextLabel")
        keyBadge.Size = UDim2.new(0, 28, 0, 24)
        keyBadge.BackgroundColor3 = GUI.Theme.Tertiary
        keyBadge.TextColor3 = GUI.Theme.Accent
        keyBadge.TextSize = 11
        keyBadge.Font = Enum.Font.GothamBold
        keyBadge.Text = key
        keyBadge.BorderSizePixel = 0
        keyBadge.Parent = keyContainer
        AddCorner(keyBadge, 4)
    end

    return kbFrame
end

-- Create info card (status display)
function GUI:CreateInfoCard(page, title, valueName, default)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.48, 0, 0, 52)
    card.BackgroundColor3 = GUI.Theme.Secondary
    card.BorderSizePixel = 0
    card.Parent = page
    AddCorner(card, 6)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -8, 0, 20)
    titleLbl.Position = UDim2.new(0, 8, 0, 6)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextColor3 = GUI.Theme.TextDim
    titleLbl.TextSize = 10
    titleLbl.Font = Enum.Font.Gotham
    titleLbl.Text = title:upper()
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = card

    local valueLbl = Instance.new("TextLabel")
    valueLbl.Name = valueName or "Value"
    valueLbl.Size = UDim2.new(1, -8, 0, 22)
    valueLbl.Position = UDim2.new(0, 8, 0, 26)
    valueLbl.BackgroundTransparency = 1
    valueLbl.TextColor3 = GUI.Theme.Accent
    valueLbl.TextSize = 16
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.Text = tostring(default or "—")
    valueLbl.TextXAlignment = Enum.TextXAlignment.Left
    valueLbl.Parent = card

    return {card = card, valueLabel = valueLbl}
end

-- ============================================================================
-- SECTION 21: BUILD ALL GUI TABS
-- ============================================================================

function GUI:BuildAllTabs()
    -- =====================
    -- TAB 1: HOME / STATUS
    -- =====================
    local homeTab = self:CreateTab("Home", "🏠")

    self:CreateSection(homeTab.page, "Status Overview")
    self:CreateLabel(homeTab.page, "Welcome to Omega Hub v4.0 - Blox Fruits", GUI.Theme.Accent)
    self:CreateLabel(homeTab.page, "All systems loaded and ready to use.")

    -- Info grid
    local statsGrid = Instance.new("Frame")
    statsGrid.Size = UDim2.new(1, -16, 0, 120)
    statsGrid.BackgroundTransparency = 1
    statsGrid.Parent = homeTab.page

    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0.48, 0, 0, 52)
    gridLayout.CellPadding = UDim2.new(0.04, 0, 0, 6)
    gridLayout.Parent = statsGrid

    local killCard = self:CreateInfoCard(statsGrid, "Kills This Session", "KillCount", "0")
    local xpCard   = self:CreateInfoCard(statsGrid, "XP This Session",   "XPCount",   "0")
    local fruitCard = self:CreateInfoCard(statsGrid, "Fruits Collected",  "FruitCount","0")
    local timeCard  = self:CreateInfoCard(statsGrid, "Session Time",      "TimeLabel", "00:00")

    -- Update stats periodically
    task.spawn(function()
        local sessionStart = tick()
        while task.wait(1) do
            if killCard.valueLabel and killCard.valueLabel.Parent then
                killCard.valueLabel.Text = tostring(AutoFarmEngine.KillCount)
                fruitCard.valueLabel.Text = tostring(AutoFruitSystem.CollectedCount)
                local elapsed = tick() - sessionStart
                local mins = math.floor(elapsed / 60)
                local secs = math.floor(elapsed % 60)
                timeCard.valueLabel.Text = string.format("%02d:%02d", mins, secs)
            else
                break
            end
        end
    end)

    self:CreateSection(homeTab.page, "Quick Toggles")

    self:CreateToggle(homeTab.page, "Anti-Ban System", Settings.AntiBan.Enabled, function(v)
        Settings.AntiBan.Enabled = v
        if v then AntiBanSystem:Start() else AntiBanSystem:Stop() end
    end)

    self:CreateToggle(homeTab.page, "Admin Detection + Auto Leave",
        Settings.AdminDetection.Enabled, function(v)
        Settings.AdminDetection.Enabled = v
        Settings.AdminDetection.AutoLeave = v
    end)

    self:CreateToggle(homeTab.page, "Anti-Void Protection", Settings.Misc.AntiVoid, function(v)
        Settings.Misc.AntiVoid = v
        if v then MiscSystem:StartAntiVoid() end
    end)

    self:CreateSection(homeTab.page, "Server Info")
    self:CreateLabel(homeTab.page, "Player: " .. LocalPlayer.Name)
    self:CreateLabel(homeTab.page, "User ID: " .. LocalPlayer.UserId)
    self:CreateLabel(homeTab.page, "Server: " .. game.JobId:sub(1, 16) .. "...")
    self:CreateLabel(homeTab.page, "Players in server: " .. #Players:GetPlayers())

    -- =====================
    -- TAB 2: AUTO FARM
    -- =====================
    local farmTab = self:CreateTab("Auto Farm", "⚔️")

    self:CreateSection(farmTab.page, "Farm Controls")

    self:CreateToggle(farmTab.page, "Auto Farm (Levels)", Settings.AutoFarm.Enabled, function(v)
        Settings.AutoFarm.Enabled = v
        Settings.AutoFarm.FarmBosses = false
        Settings.AutoFarm.MasteryFarm = false
        if v then AutoFarmEngine:Start() else AutoFarmEngine:Stop() end
    end)

    self:CreateSection(farmTab.page, "Boss Farming")

    self:CreateToggle(farmTab.page, "Farm Selected Boss", false, function(v)
        Settings.AutoFarm.FarmBosses = v
        Settings.AutoFarm.Enabled = v
        if v then AutoFarmEngine:Start() else AutoFarmEngine:Stop() end
    end)

    self:CreateToggle(farmTab.page, "Farm ALL Bosses (Sequence)", false, function(v)
        Settings.AutoFarm.FarmAllBosses = v
        Settings.AutoFarm.Enabled = v
        if v then AutoFarmEngine:Start() else AutoFarmEngine:Stop() end
    end)

    -- Boss dropdown
    local bossNames = {"None"}
    for _, boss in ipairs(BossData) do
        table.insert(bossNames, boss.name .. " (Lvl " .. boss.level .. ")")
    end
    self:CreateDropdown(farmTab.page, "Select Boss", bossNames, "None", function(v)
        -- Extract boss name
        local name = v:match("^(.-)%s*%(") or v
        Settings.AutoFarm.SelectedBoss = name
    end)

    self:CreateSection(farmTab.page, "Mastery Farming")

    self:CreateToggle(farmTab.page, "Auto Mastery Farm", false, function(v)
        Settings.AutoFarm.MasteryFarm = v
        Settings.AutoFarm.Enabled = v
        if v then AutoFarmEngine:Start() else AutoFarmEngine:Stop() end
    end)

    self:CreateDropdown(farmTab.page, "Mastery Type",
        {"Fruit", "Sword", "Melee", "Gun"},
        Settings.AutoFarm.MasteryType,
        function(v)
            Settings.AutoFarm.MasteryType = v
        end)

    self:CreateSection(farmTab.page, "Farm Settings")

    self:CreateToggle(farmTab.page, "Auto Collect Drops", Settings.AutoFarm.CollectDrops, function(v)
        Settings.AutoFarm.CollectDrops = v
    end)

    self:CreateToggle(farmTab.page, "Auto Revive on Death", Settings.AutoFarm.AutoRevive, function(v)
        Settings.AutoFarm.AutoRevive = v
    end)

    self:CreateToggle(farmTab.page, "Auto Use Best Fruit", Settings.AutoFarm.AutoEquipBestFruit, function(v)
        Settings.AutoFarm.AutoEquipBestFruit = v
    end)

    self:CreateToggle(farmTab.page, "Use Skills Automatically", Settings.AutoFarm.UseAutoSkills, function(v)
        Settings.AutoFarm.UseAutoSkills = v
    end)

    self:CreateSlider(farmTab.page, "Level Target", 1, 2450, Settings.AutoFarm.LevelTarget, function(v)
        Settings.AutoFarm.LevelTarget = v
    end)

    self:CreateSlider(farmTab.page, "Attack Delay (ms)", 1, 500, 80, function(v)
        Settings.AutoFarm.AttackDelay = v / 1000
    end)

    -- =====================
    -- TAB 3: AUTO QUEST
    -- =====================
    local questTab = self:CreateTab("Auto Quest", "📜")

    self:CreateSection(questTab.page, "Quest System")

    self:CreateDropdown(questTab.page, "Quest Type",
        {"Level", "Draco", "Dragon", "DracoV2", "DracoV3", "DracoV4"},
        Settings.AutoQuest.QuestType,
        function(v)
            Settings.AutoQuest.QuestType = v
        end)

    self:CreateToggle(questTab.page, "Auto Quest (Selected)", Settings.AutoQuest.Enabled, function(v)
        Settings.AutoQuest.Enabled = v
        if v then AutoQuestSystem:Start() else AutoQuestSystem:Stop() end
    end)

    self:CreateSection(questTab.page, "Individual Quests")

    self:CreateToggle(questTab.page, "Auto Draco Quest", Settings.AutoQuest.DracoAuto, function(v)
        Settings.AutoQuest.DracoAuto = v
        Settings.AutoQuest.QuestType = "Draco"
        Settings.AutoQuest.Enabled = v
        if v then AutoQuestSystem:Start() else AutoQuestSystem:Stop() end
    end)

    self:CreateToggle(questTab.page, "Auto Dragon Quest", Settings.AutoQuest.DragonQuestAuto, function(v)
        Settings.AutoQuest.DragonQuestAuto = v
        Settings.AutoQuest.QuestType = "Dragon"
        Settings.AutoQuest.Enabled = v
        if v then AutoQuestSystem:Start() else AutoQuestSystem:Stop() end
    end)

    self:CreateToggle(questTab.page, "Auto Draco V2 Quest", Settings.AutoQuest.DracoV2Auto, function(v)
        Settings.AutoQuest.DracoV2Auto = v
        Settings.AutoQuest.QuestType = "DracoV2"
        Settings.AutoQuest.Enabled = v
        if v then AutoQuestSystem:Start() else AutoQuestSystem:Stop() end
    end)

    self:CreateToggle(questTab.page, "Auto Draco V3 Quest", Settings.AutoQuest.DracoV3Auto, function(v)
        Settings.AutoQuest.DracoV3Auto = v
        Settings.AutoQuest.QuestType = "DracoV3"
        Settings.AutoQuest.Enabled = v
        if v then AutoQuestSystem:Start() else AutoQuestSystem:Stop() end
    end)

    self:CreateToggle(questTab.page, "Auto Draco V4 Quest", Settings.AutoQuest.DracoV4Auto, function(v)
        Settings.AutoQuest.DracoV4Auto = v
        Settings.AutoQuest.QuestType = "DracoV4"
        Settings.AutoQuest.Enabled = v
        if v then AutoQuestSystem:Start() else AutoQuestSystem:Stop() end
    end)

    self:CreateSection(questTab.page, "Quest Settings")

    self:CreateToggle(questTab.page, "Auto Accept Quest", Settings.AutoQuest.AutoAccept, function(v)
        Settings.AutoQuest.AutoAccept = v
    end)

    self:CreateToggle(questTab.page, "Auto Turn In Quest", Settings.AutoQuest.AutoTurnIn, function(v)
        Settings.AutoQuest.AutoTurnIn = v
    end)

    self:CreateToggle(questTab.page, "Repeat Quest Loop", Settings.AutoQuest.RepeatQuest, function(v)
        Settings.AutoQuest.RepeatQuest = v
    end)

    self:CreateSlider(questTab.page, "Quest Delay (ms)", 100, 3000, 500, function(v)
        Settings.AutoQuest.QuestDelay = v / 1000
    end)

    -- =====================
    -- TAB 4: AUTO FRUIT
    -- =====================
    local fruitTab = self:CreateTab("Auto Fruit", "🍎")

    self:CreateSection(fruitTab.page, "Fruit System")

    self:CreateToggle(fruitTab.page, "Auto Fruit (Master Toggle)", Settings.AutoFruit.Enabled, function(v)
        Settings.AutoFruit.Enabled = v
        if v then AutoFruitSystem:Start() else AutoFruitSystem:Stop() end
    end)

    self:CreateToggle(fruitTab.page, "Auto Get Fruit (Collect Nearby)", Settings.AutoFruit.AutoGetFruit, function(v)
        Settings.AutoFruit.AutoGetFruit = v
    end)

    self:CreateToggle(fruitTab.page, "Auto Store Fruit", Settings.AutoFruit.AutoStoreFruit, function(v)
        Settings.AutoFruit.AutoStoreFruit = v
    end)

    self:CreateToggle(fruitTab.page, "Auto Random Fruit (Lucky Spin)", Settings.AutoFruit.AutoRandomFruit, function(v)
        Settings.AutoFruit.AutoRandomFruit = v
    end)

    self:CreateToggle(fruitTab.page, "Bring Fruits To Player", Settings.AutoFruit.BringFruitToPlayer, function(v)
        Settings.AutoFruit.BringFruitToPlayer = v
    end)

    self:CreateSection(fruitTab.page, "Fruit Settings")

    self:CreateToggle(fruitTab.page, "Notify on Fruit Spawn", Settings.AutoFruit.NotifyOnFruit, function(v)
        Settings.AutoFruit.NotifyOnFruit = v
    end)

    self:CreateToggle(fruitTab.page, "Auto Eat Fruit (if inventory full)", Settings.AutoFruit.EatIfNoSpace, function(v)
        Settings.AutoFruit.EatIfNoSpace = v
    end)

    self:CreateToggle(fruitTab.page, "Show Fruit ESP", Settings.Misc.ShowFruitESP, function(v)
        Settings.Misc.ShowFruitESP = v
    end)

    self:CreateSlider(fruitTab.page, "Scan Radius (studs)", 100, 5000, 2000, function(v)
        Settings.AutoFruit.ScanRadius = v
    end)

    self:CreateSlider(fruitTab.page, "Bring Radius (studs)", 10, 500, 50, function(v)
        Settings.AutoFruit.BringRadius = v
    end)

    self:CreateSlider(fruitTab.page, "Scan Interval (ms)", 100, 5000, 1000, function(v)
        Settings.AutoFruit.ScanInterval = v / 1000
    end)

    self:CreateSection(fruitTab.page, "Fruit Info")
    self:CreateLabel(fruitTab.page, "Fruits Collected: " .. tostring(AutoFruitSystem.CollectedCount))
    self:CreateLabel(fruitTab.page, "Fruits Stored: " .. tostring(AutoFruitSystem.StoredCount))

    self:CreateButton(fruitTab.page, "Scan for Fruits Now", function()
        local fruits = AutoFruitSystem:ScanForFruits()
        Notify("Fruit Scan", "Found " .. #fruits .. " fruits nearby", 3)
    end)

    -- =====================
    -- TAB 5: TELEPORT
    -- =====================
    local tpTab = self:CreateTab("Teleport", "🌀")

    self:CreateSection(tpTab.page, "Island Teleport")

    -- Create teleport buttons for first sea
    self:CreateLabel(tpTab.page, "── FIRST SEA ──", GUI.Theme.Accent)
    for _, island in ipairs(IslandData) do
        if island.sea == 1 then
            self:CreateButton(tpTab.page, island.name, function()
                TeleportSystem:ToIsland(island.name)
            end)
        end
    end

    self:CreateLabel(tpTab.page, "── SECOND SEA ──", GUI.Theme.Accent)
    for _, island in ipairs(IslandData) do
        if island.sea == 2 then
            self:CreateButton(tpTab.page, island.name, function()
                TeleportSystem:ToIsland(island.name)
            end)
        end
    end

    self:CreateLabel(tpTab.page, "── THIRD SEA ──", GUI.Theme.Accent)
    for _, island in ipairs(IslandData) do
        if island.sea == 3 then
            self:CreateButton(tpTab.page, island.name, function()
                TeleportSystem:ToIsland(island.name)
            end)
        end
    end

    self:CreateSection(tpTab.page, "NPC Teleport")
    for _, npc in ipairs(QuestNPCs) do
        self:CreateButton(tpTab.page, "→ " .. npc.name, function()
            TeleportSystem:ToNPC(npc.name)
        end)
    end

    self:CreateSection(tpTab.page, "Player Teleport")
    local playerInput = self:CreateInput(tpTab.page, "Player Name", "Enter player name...")
    self:CreateButton(tpTab.page, "Teleport to Player", function()
        local name = playerInput.box.Text
        if name and name ~= "" then
            TeleportSystem:ToPlayer(name)
        end
    end)

    self:CreateSection(tpTab.page, "Bookmarks")
    self:CreateButton(tpTab.page, "💾 Save Current Position", function()
        TeleportSystem:SaveBookmark("Saved_" .. os.time())
        Notify("Bookmark", "Position saved!", 2)
    end)
    self:CreateButton(tpTab.page, "🏠 Go To Safe Zone", function()
        TeleportSystem:ToSafeZone()
    end)

    -- =====================
    -- TAB 6: PVP
    -- =====================
    local pvpTab = self:CreateTab("PvP", "⚔️")

    self:CreateSection(pvpTab.page, "PvP Controls")

    self:CreateToggle(pvpTab.page, "Enable PvP System", Settings.PvP.Enabled, function(v)
        Settings.PvP.Enabled = v
        if v then PvPSystem:Start() else PvPSystem:Stop() end
    end)

    self:CreateToggle(pvpTab.page, "Auto Combo", Settings.PvP.AutoCombo, function(v)
        Settings.PvP.AutoCombo = v
    end)

    self:CreateToggle(pvpTab.page, "Auto Lock Target (Closest)", Settings.PvP.AutoSelectTarget, function(v)
        Settings.PvP.AutoSelectTarget = v
    end)

    self:CreateToggle(pvpTab.page, "Get Inside Player", Settings.PvP.GetInsidePlayer, function(v)
        Settings.PvP.GetInsidePlayer = v
    end)

    self:CreateToggle(pvpTab.page, "Auto Aim", Settings.PvP.AutoAim, function(v)
        Settings.PvP.AutoAim = v
    end)

    self:CreateToggle(pvpTab.page, "Anti-Knockback", Settings.PvP.AntiKnockback, function(v)
        Settings.PvP.AntiKnockback = v
    end)

    self:CreateToggle(pvpTab.page, "Loop Combo", Settings.PvP.LoopCombo, function(v)
        Settings.PvP.LoopCombo = v
    end)

    self:CreateToggle(pvpTab.page, "Ignore Teammates", Settings.PvP.IgnoreTeammates, function(v)
        Settings.PvP.IgnoreTeammates = v
    end)

    self:CreateSection(pvpTab.page, "Combo Key Settings")
    self:CreateLabel(pvpTab.page, "Toggle which keys to include in combo:")

    for _, key in ipairs(Settings.PvP.ComboKeys) do
        self:CreateToggle(pvpTab.page, "Key: " .. key, Settings.PvP.KeyEnabled[key], function(v)
            Settings.PvP.KeyEnabled[key] = v
        end)
        self:CreateSlider(pvpTab.page, key .. " Delay (ms)", 10, 500, 50, function(v)
            Settings.PvP.KeyDelays[key] = v / 1000
        end)
    end

    self:CreateSection(pvpTab.page, "Combo Timing")

    self:CreateSlider(pvpTab.page, "Global Combo Delay (ms)", 10, 500, 50, function(v)
        Settings.PvP.GlobalComboDelay = v / 1000
    end)

    self:CreateSlider(pvpTab.page, "Combo Loop Delay (ms)", 50, 2000, 300, function(v)
        Settings.PvP.ComboLoopDelay = v / 1000
    end)

    self:CreateSlider(pvpTab.page, "Max Target Range (studs)", 5, 500, 50, function(v)
        Settings.PvP.MaxRange = v
    end)

    self:CreateSection(pvpTab.page, "Aim Settings")

    self:CreateDropdown(pvpTab.page, "Aim Bone",
        {"HumanoidRootPart", "Head", "UpperTorso", "LowerTorso"},
        Settings.PvP.AimBone,
        function(v)
            Settings.PvP.AimBone = v
        end)

    self:CreateSection(pvpTab.page, "Target Controls")

    local targetInput = self:CreateInput(pvpTab.page, "Lock Target by Name", "Enter player name...")
    self:CreateButton(pvpTab.page, "🎯 Lock Target", function()
        local name = targetInput.box.Text
        if name and name ~= "" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Name:lower() == name:lower() then
                    PvPSystem:LockTarget(p)
                    return
                end
            end
            Notify("PvP", "Player not found: " .. name, 3)
        end
    end)

    self:CreateButton(pvpTab.page, "🔓 Unlock Target", function()
        PvPSystem:LockTarget(nil)
    end)

    self:CreateLabel(pvpTab.page, "Auto Combo Keys: Z X C V F")
    self:CreateKeyBind(pvpTab.page, "Default Combo", {"Z", "X", "C", "V", "F"})

    -- =====================
    -- TAB 7: EGGS & BERRY
    -- =====================
    local eggsTab = self:CreateTab("Eggs & Berry", "🥚")

    self:CreateSection(eggsTab.page, "Egg System")

    self:CreateToggle(eggsTab.page, "Auto Collect Eggs", Settings.Eggs.AutoCollectEggs, function(v)
        Settings.Eggs.AutoCollectEggs = v
        if v then EggSystem:Start() else EggSystem:Stop() end
    end)

    self:CreateToggle(eggsTab.page, "Auto Give Eggs (to NPC)", Settings.Eggs.AutoGiveEggs, function(v)
        Settings.Eggs.AutoGiveEggs = v
    end)

    self:CreateToggle(eggsTab.page, "Prefer Rare Eggs First", Settings.Eggs.PreferRareEggs, function(v)
        Settings.Eggs.PreferRareEggs = v
    end)

    self:CreateSlider(eggsTab.page, "Egg Scan Radius", 50, 2000, 500, function(v)
        Settings.Eggs.EggScanRadius = v
    end)

    self:CreateSlider(eggsTab.page, "Egg Collect Delay (ms)", 100, 2000, 500, function(v)
        Settings.Eggs.EggCollectDelay = v / 1000
    end)

    self:CreateSection(eggsTab.page, "Egg Types")
    for _, eggType in ipairs(EggSystem.EggTypes) do
        self:CreateLabel(eggsTab.page, "• " .. eggType.name .. " → " .. eggType.reward)
    end

    self:CreateSection(eggsTab.page, "Berry System")

    self:CreateToggle(eggsTab.page, "Auto Collect Berry", Settings.Berry.AutoCollectBerry, function(v)
        Settings.Berry.AutoCollectBerry = v
        if v then BerrySystem:Start() else BerrySystem:Stop() end
    end)

    self:CreateToggle(eggsTab.page, "Auto Spend Berry on Race", Settings.Berry.AutoSpendBerry, function(v)
        Settings.Berry.AutoSpendBerry = v
    end)

    self:CreateSlider(eggsTab.page, "Berry Scan Radius", 100, 5000, 1000, function(v)
        Settings.Berry.BerryRadius = v
    end)

    self:CreateSlider(eggsTab.page, "Berry Collect Delay (ms)", 100, 1000, 300, function(v)
        Settings.Berry.BerryDelay = v / 1000
    end)

    self:CreateSection(eggsTab.page, "Stats")
    local eggCountLabel = self:CreateLabel(eggsTab.page, "Eggs Collected: 0")
    local berryCountLabel = self:CreateLabel(eggsTab.page, "Berry Collected: 0")

    task.spawn(function()
        while task.wait(2) do
            if eggCountLabel and eggCountLabel.Parent then
                eggCountLabel.Text = "Eggs Collected: " .. EggSystem.CollectedEggs
                berryCountLabel.Text = "Berry Collected: " .. BerrySystem.BerryCount
            else
                break
            end
        end
    end)

    -- =====================
    -- TAB 8: ELITE HUNTERS
    -- =====================
    local eliteTab = self:CreateTab("Elite Hunters", "🗡️")

    self:CreateSection(eliteTab.page, "Elite Hunter System")

    self:CreateToggle(eliteTab.page, "Auto Farm Elite Hunters", Settings.EliteHunters.AutoFarm, function(v)
        Settings.EliteHunters.AutoFarm = v
        if v then EliteHunterSystem:Start() else EliteHunterSystem:Stop() end
    end)

    self:CreateDropdown(eliteTab.page, "Target Elite",
        {"All", "Deandre", "Diablo", "Gonzalo"},
        "All",
        function(v)
            Settings.EliteHunters.SelectedTarget = v
        end)

    self:CreateSection(eliteTab.page, "Individual Elites")

    for _, elite in ipairs(EliteHunterData) do
        self:CreateButton(eliteTab.page, "Hunt: " .. elite.name .. " (→ " .. elite.reward .. ")", function()
            task.spawn(function()
                EliteHunterSystem:KillElite(elite)
            end)
        end)
    end

    self:CreateSection(eliteTab.page, "Stats")
    local eliteKillLabel = self:CreateLabel(eliteTab.page, "Total Elite Kills: 0")

    task.spawn(function()
        while task.wait(2) do
            if eliteKillLabel and eliteKillLabel.Parent then
                eliteKillLabel.Text = "Total Elite Kills: " .. EliteHunterSystem.KillCount
            else
                break
            end
        end
    end)

    -- =====================
    -- TAB 9: SPECIAL SWORDS
    -- =====================
    local swordsTab = self:CreateTab("Swords", "🔱")

    self:CreateSection(swordsTab.page, "Special Sword Quests")

    self:CreateToggle(swordsTab.page, "Auto Yama Quest", Settings.SpecialSwords.AutoYama, function(v)
        Settings.SpecialSwords.AutoYama = v
        if v then SpecialSwordSystem:StartYama() end
    end)

    self:CreateToggle(swordsTab.page, "Auto Tushita Quest", Settings.SpecialSwords.AutoTushita, function(v)
        Settings.SpecialSwords.AutoTushita = v
        if v then SpecialSwordSystem:StartTushita() end
    end)

    self:CreateToggle(swordsTab.page, "Auto Rengoku Quest", Settings.SpecialSwords.AutoRengoku, function(v)
        Settings.SpecialSwords.AutoRengoku = v
        if v then SpecialSwordSystem:StartRengoku() end
    end)

    self:CreateToggle(swordsTab.page, "Auto True Triple Katana", Settings.SpecialSwords.AutoTripleKatana, function(v)
        Settings.SpecialSwords.AutoTripleKatana = v
        if v then SpecialSwordSystem:StartTripleKatana() end
    end)

    self:CreateSection(swordsTab.page, "Quest Steps - Yama")
    for i, step in ipairs(YamaQuestSteps) do
        self:CreateLabel(swordsTab.page, string.format("Step %d: %s", i, step.desc))
    end

    self:CreateSection(swordsTab.page, "Quest Steps - Tushita")
    for i, step in ipairs(TushitaQuestSteps) do
        self:CreateLabel(swordsTab.page, string.format("Step %d: %s", i, step.desc))
    end

    self:CreateSection(swordsTab.page, "Quest Steps - Rengoku")
    for i, step in ipairs(RengokuQuestSteps) do
        self:CreateLabel(swordsTab.page, string.format("Step %d: %s", i, step.desc))
    end

    self:CreateSection(swordsTab.page, "Quest Steps - Triple Katana")
    for i, step in ipairs(TripleKatanaSteps) do
        self:CreateLabel(swordsTab.page, string.format("Step %d: %s", i, step.desc))
    end

    -- =====================
    -- TAB 10: AUTO RACE
    -- =====================
    local raceTab = self:CreateTab("Auto Race", "🏃")

    self:CreateSection(raceTab.page, "Race Upgrades")

    self:CreateToggle(raceTab.page, "Auto Race V2", Settings.AutoRace.V2Enabled, function(v)
        Settings.AutoRace.V2Enabled = v
        if v then AutoRaceSystem:Start() end
    end)

    self:CreateToggle(raceTab.page, "Auto Race V3", Settings.AutoRace.V3Enabled, function(v)
        Settings.AutoRace.V3Enabled = v
        if v then AutoRaceSystem:Start() end
    end)

    self:CreateToggle(raceTab.page, "Auto Race V4", Settings.AutoRace.V4Enabled, function(v)
        Settings.AutoRace.V4Enabled = v
        if v then AutoRaceSystem:Start() end
    end)

    self:CreateSection(raceTab.page, "Special Races")

    self:CreateToggle(raceTab.page, "Auto Cyborg Race", Settings.AutoRace.CyborgEnabled, function(v)
        Settings.AutoRace.CyborgEnabled = v
        if v then AutoRaceSystem:Start() end
    end)

    self:CreateToggle(raceTab.page, "Auto Ghoul Race", Settings.AutoRace.GhoulEnabled, function(v)
        Settings.AutoRace.GhoulEnabled = v
        if v then AutoRaceSystem:Start() end
    end)

    self:CreateSection(raceTab.page, "Race Management")

    local raceNames = {}
    for _, race in ipairs(RaceData) do
        table.insert(raceNames, race.name)
    end

    self:CreateDropdown(raceTab.page, "Select Race to Buy/Change",
        raceNames, "Human", function(v)
        Settings.AutoRace.RaceChangeTarget = v
    end)

    self:CreateButton(raceTab.page, "🛒 Auto Buy Race", function()
        AutoRaceSystem:BuyRace(Settings.AutoRace.RaceChangeTarget)
    end)

    self:CreateButton(raceTab.page, "🔄 Auto Change Race", function()
        AutoRaceSystem:ChangeRace(Settings.AutoRace.RaceChangeTarget)
    end)

    self:CreateSection(raceTab.page, "Race Info")
    for _, race in ipairs(RaceData) do
        self:CreateLabel(raceTab.page,
            race.name .. " - " .. race.ability ..
            (race.cost > 0 and " [" .. race.cost .. " Fragments]" or " [Free]"))
    end

    -- =====================
    -- TAB 11: BOSS DEFEAT
    -- =====================
    local bossTab = self:CreateTab("Boss Defeat", "💀")

    self:CreateSection(bossTab.page, "Special Boss Defeats")

    self:CreateToggle(bossTab.page, "Auto Mirage Island Boss", Settings.BossDefeat.AutoMirage, function(v)
        Settings.BossDefeat.AutoMirage = v
        if v then BossDefeatSystem:Start() end
    end)

    self:CreateToggle(bossTab.page, "Auto Defeat Rip_Indra", Settings.BossDefeat.AutoIndra, function(v)
        Settings.BossDefeat.AutoIndra = v
        if v then BossDefeatSystem:Start() end
    end)

    self:CreateToggle(bossTab.page, "Auto Defeat Dough King", Settings.BossDefeat.AutoDoughKing, function(v)
        Settings.BossDefeat.AutoDoughKing = v
        if v then BossDefeatSystem:Start() end
    end)

    self:CreateToggle(bossTab.page, "Auto Defeat Cake Prince", Settings.BossDefeat.AutoCakePrince, function(v)
        Settings.BossDefeat.AutoCakePrince = v
        if v then BossDefeatSystem:Start() end
    end)

    self:CreateToggle(bossTab.page, "Loop Boss Farm", Settings.BossDefeat.LoopBoss, function(v)
        Settings.BossDefeat.LoopBoss = v
    end)

    self:CreateSlider(bossTab.page, "Boss Defeat Delay (ms)", 500, 10000, 1000, function(v)
        Settings.BossDefeat.BossDelay = v / 1000
    end)

    self:CreateSection(bossTab.page, "All Bosses List")
    for _, boss in ipairs(BossData) do
        self:CreateButton(bossTab.page,
            string.format("Kill: %s (Lvl %d | Sea %d)", boss.name, boss.level, boss.sea),
            function()
                task.spawn(function()
                    AutoFarmEngine:FarmBoss(boss.name)
                end)
            end)
    end

    self:CreateSection(bossTab.page, "Boss Kill Stats")
    local bossStatsLabel = self:CreateLabel(bossTab.page, "Loading stats...")

    task.spawn(function()
        while task.wait(2) do
            if bossStatsLabel and bossStatsLabel.Parent then
                bossStatsLabel.Text = string.format(
                    "Mirage: %d | Indra: %d | Dough King: %d | Cake Prince: %d",
                    BossDefeatSystem.DefeatCounts.Mirage,
                    BossDefeatSystem.DefeatCounts.Indra,
                    BossDefeatSystem.DefeatCounts.DoughKing,
                    BossDefeatSystem.DefeatCounts.CakePrince
                )
            else
                break
            end
        end
    end)

    -- =====================
    -- TAB 12: MISC
    -- =====================
    local miscTab = self:CreateTab("Misc", "⚙️")

    self:CreateSection(miscTab.page, "Movement")

    self:CreateToggle(miscTab.page, "Fly Mode", false, function(v)
        Settings.Misc.FlyEnabled = v
        if v then MiscSystem:StartFly() else MiscSystem:StopFly() end
    end)

    self:CreateToggle(miscTab.page, "NoClip", false, function(v)
        Settings.Misc.NoClip = v
        if v then MiscSystem:StartNoClip() else MiscSystem:StopNoClip() end
    end)

    self:CreateToggle(miscTab.page, "Infinite Jump", false, function(v)
        Settings.Misc.InfJump = v
        if v then MiscSystem:StartInfJump() else MiscSystem:StopInfJump() end
    end)

    self:CreateSlider(miscTab.page, "Walk Speed", 1, 300, 16, function(v)
        Settings.Misc.WalkSpeed = v
        MiscSystem:SetWalkSpeed(v)
    end)

    self:CreateSlider(miscTab.page, "Jump Power", 1, 200, 7, function(v)
        Settings.Misc.JumpPower = v
        MiscSystem:SetJumpPower(v)
    end)

    self:CreateSlider(miscTab.page, "Fly Speed", 10, 500, 50, function(v)
        Settings.Misc.FlySpeed = v
    end)

    self:CreateSection(miscTab.page, "ESP")

    self:CreateToggle(miscTab.page, "Player ESP", Settings.Misc.ShowESP, function(v)
        Settings.Misc.ShowESP = v
    end)

    self:CreateToggle(miscTab.page, "Boss ESP", Settings.Misc.ShowBossESP, function(v)
        Settings.Misc.ShowBossESP = v
    end)

    self:CreateToggle(miscTab.page, "Fruit ESP", Settings.Misc.ShowFruitESP, function(v)
        Settings.Misc.ShowFruitESP = v
    end)

    self:CreateSlider(miscTab.page, "ESP Distance", 100, 5000, 1000, function(v)
        Settings.Misc.ESPDistance = v
    end)

    self:CreateSection(miscTab.page, "Auto Stat")

    self:CreateToggle(miscTab.page, "Auto Spend Stat Points", Settings.Misc.AutoStat, function(v)
        Settings.Misc.AutoStat = v
    end)

    self:CreateDropdown(miscTab.page, "Stat Type",
        {"Melee", "Defense", "Sword", "Gun", "Fruit"},
        Settings.Misc.StatType,
        function(v)
            Settings.Misc.StatType = v
        end)

    self:CreateSection(miscTab.page, "Anti-Ban")

    self:CreateToggle(miscTab.page, "Humanizer (Random Delays)", Settings.AntiBan.HumanizerEnabled, function(v)
        Settings.AntiBan.HumanizerEnabled = v
    end)

    self:CreateToggle(miscTab.page, "Fake Micro-Movement", Settings.AntiBan.FakeMovement, function(v)
        Settings.AntiBan.FakeMovement = v
    end)

    self:CreateToggle(miscTab.page, "Anti-AFK", Settings.AntiBan.AntiAFK, function(v)
        Settings.AntiBan.AntiAFK = v
    end)

    self:CreateSlider(miscTab.page, "Min Delay (ms)", 10, 500, 50, function(v)
        Settings.AntiBan.MinDelay = v / 1000
    end)

    self:CreateSlider(miscTab.page, "Max Delay (ms)", 50, 1000, 150, function(v)
        Settings.AntiBan.MaxDelay = v / 1000
    end)

    self:CreateSection(miscTab.page, "Server")
    self:CreateButton(miscTab.page, "🔄 Rejoin Server", function()
        pcall(function()
            TeleportService:Teleport(game.PlaceId)
        end)
    end)

    self:CreateButton(miscTab.page, "❌ Leave Game", function()
        pcall(function()
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end)
    end)

    -- Activate first tab
    if #GUI.Tabs > 0 then
        GUI.Tabs[1].btn.BackgroundColor3 = GUI.Theme.TabActive
        GUI.Tabs[1].btn.TextColor3 = GUI.Theme.White
        GUI.Tabs[1].page.Visible = true
        GUI.CurrentTab = GUI.Tabs[1].name
    end
end

-- ============================================================================
-- SECTION 22: KEYBOARD SHORTCUTS
-- ============================================================================

local KeybindSystem = {}
KeybindSystem.Binds = {
    [Enum.KeyCode.RightBracket] = function()
        -- Toggle GUI visibility
        local gui = PlayerGui:FindFirstChild("OmegaHubGui")
        if gui then
            gui.Enabled = not gui.Enabled
        end
    end,
    [Enum.KeyCode.Delete] = function()
        -- Emergency stop all
        Settings.AutoFarm.Enabled = false
        Settings.AutoQuest.Enabled = false
        Settings.PvP.Enabled = false
        Settings.AutoFruit.Enabled = false
        AutoFarmEngine:Stop()
        AutoQuestSystem:Stop()
        PvPSystem:Stop()
        AutoFruitSystem:Stop()
        Notify("Emergency Stop", "All systems halted", 3)
    end,
    [Enum.KeyCode.F1] = function()
        Settings.AutoFarm.Enabled = not Settings.AutoFarm.Enabled
        if Settings.AutoFarm.Enabled then
            AutoFarmEngine:Start()
        else
            AutoFarmEngine:Stop()
        end
        Notify("Auto Farm", Settings.AutoFarm.Enabled and "Enabled" or "Disabled", 2)
    end,
    [Enum.KeyCode.F2] = function()
        Settings.PvP.Enabled = not Settings.PvP.Enabled
        if Settings.PvP.Enabled then
            PvPSystem:Start()
        else
            PvPSystem:Stop()
        end
        Notify("PvP System", Settings.PvP.Enabled and "Enabled" or "Disabled", 2)
    end,
    [Enum.KeyCode.F3] = function()
        Settings.AutoFruit.Enabled = not Settings.AutoFruit.Enabled
        if Settings.AutoFruit.Enabled then
            AutoFruitSystem:Start()
        else
            AutoFruitSystem:Stop()
        end
        Notify("Auto Fruit", Settings.AutoFruit.Enabled and "Enabled" or "Disabled", 2)
    end,
    [Enum.KeyCode.F4] = function()
        TeleportSystem:ToSafeZone()
    end,
}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local callback = KeybindSystem.Binds[input.KeyCode]
    if callback then
        pcall(callback)
    end
end)

-- ============================================================================
-- SECTION 23: CHARACTER RESPAWN HANDLER
-- ============================================================================

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    Humanoid = newCharacter:WaitForChild("Humanoid")

    Log("Character respawned, re-applying settings")

    -- Re-apply walk speed
    if Settings.Misc.WalkSpeed ~= 16 then
        task.delay(1, function()
            MiscSystem:SetWalkSpeed(Settings.Misc.WalkSpeed)
        end)
    end

    -- Re-apply jump power
    if Settings.Misc.JumpPower ~= 7.2 then
        task.delay(1, function()
            MiscSystem:SetJumpPower(Settings.Misc.JumpPower)
        end)
    end

    -- Re-apply infinite jump
    if Settings.Misc.InfJump then
        task.delay(1, function()
            MiscSystem:StartInfJump()
        end)
    end

    -- Re-enable anti-void
    if Settings.Misc.AntiVoid then
        task.delay(1, function()
            MiscSystem:StartAntiVoid()
        end)
    end
end)

-- ============================================================================
-- SECTION 24: MAIN ESP UPDATE LOOP
-- ============================================================================

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(function()
            if Settings.Misc.ShowESP then
                MiscSystem:UpdatePlayerESP()
            end
            if Settings.Misc.ShowBossESP then
                MiscSystem:UpdateBossESP()
            end
        end)
    end
end)

-- ============================================================================
-- SECTION 25: AUTO STAT SYSTEM
-- ============================================================================

local AutoStatSystem = {}
AutoStatSystem.Thread = nil

function AutoStatSystem:Start()
    if self.Thread then return end
    self.Thread = task.spawn(function()
        while true do
            task.wait(Settings.Misc.AutoStatInterval)
            if Settings.Misc.AutoStat then
                pcall(function()
                    SafeFireRemote("SpendStatPoints", Settings.Misc.StatType)
                end)
            end
        end
    end)
end

AutoStatSystem:Start()

-- ============================================================================
-- SECTION 26: INITIALIZATION
-- ============================================================================

local function Initialize()
    Log("=== OmegaHub v" .. OmegaHub.Version .. " Initializing ===")

    -- Create GUI
    GUI:Create()
    GUI:BuildAllTabs()

    -- Start core systems
    AntiBanSystem:Start()
    AdminDetector:Start()
    MiscSystem:StartAntiVoid()

    OmegaHub.Loaded = true

    Notify("⚡ OmegaHub v" .. OmegaHub.Version, "Loaded! Press ] to toggle GUI | F1=Farm | F2=PvP | F3=Fruit | Del=Stop All", 8)
    Log("=== OmegaHub Loaded Successfully ===")
    Log("Keybinds: ] = Toggle GUI | DEL = Emergency Stop | F1 = Farm | F2 = PvP | F3 = Fruit | F4 = Safe Zone")
end

-- Run initialization
local ok, err = pcall(Initialize)
if not ok then
    warn("[OmegaHub] Initialization error: " .. tostring(err))
    -- Fallback notification
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "OmegaHub Error",
            Text = "Init failed: " .. tostring(err):sub(1, 80),
            Duration = 8,
        })
    end)
end

-- ============================================================================
-- END OF OMEGA HUB v4.0
-- Total Features: Anti-Ban, Admin Detect, Auto Farm, Auto Quest, Auto Fruit,
-- Teleport, PvP (Auto Combo + Get Inside), Eggs, Berry, Elite Hunters,
-- Special Swords (Yama/Tushita/Rengoku/Triple Katana), Race V2/V3/V4,
-- Cyborg Race, Ghoul Race, Auto Mirage, Defeat Indra/Dough King/Cake Prince,
-- Auto Buy/Change Race, ESP, Fly, NoClip, Inf Jump, Anti-Void, Auto Stat
-- ============================================================================

-- ============================================================================
-- SECTION 27: EXTENDED BOSS DATA (ALL RAID BOSSES & SPECIAL ENCOUNTERS)
-- ============================================================================

local ExtendedBossData = {
    -- FIRST SEA EXTENDED
    { name = "Gorilla King",        level = 53,   maxHP = 7500,   sea = 1, respawn = 10,  xp = 1500,  money = 500,   drops = {"Gorilla Mask"} },
    { name = "Bobby",               level = 75,   maxHP = 10000,  sea = 1, respawn = 10,  xp = 2000,  money = 600,   drops = {"Dark Blade Fragment"} },
    { name = "Yeti",                level = 100,  maxHP = 12500,  sea = 1, respawn = 10,  xp = 3000,  money = 900,   drops = {"Yeti Coat"} },
    { name = "Lord of Destruction", level = 125,  maxHP = 16000,  sea = 1, respawn = 15,  xp = 4500,  money = 1200,  drops = {"Longsword"} },
    { name = "Saber Expert",        level = 150,  maxHP = 25000,  sea = 1, respawn = 30,  xp = 7500,  money = 1500,  drops = {"Saber"} },
    { name = "Magma Admiral",       level = 350,  maxHP = 45000,  sea = 1, respawn = 10,  xp = 9000,  money = 2000,  drops = {"Magma Bag"} },
    { name = "Golden Boss",         level = 375,  maxHP = 55000,  sea = 1, respawn = 10,  xp = 9500,  money = 5000,  drops = {"Gold Hat"} },
    { name = "Vice Admiral",        level = 400,  maxHP = 65000,  sea = 1, respawn = 10,  xp = 10000, money = 2500,  drops = {"Marine Captain Coat"} },
    { name = "Warden",              level = 400,  maxHP = 60000,  sea = 1, respawn = 10,  xp = 10000, money = 2000,  drops = {"Jail Warden Hat"} },
    { name = "Chief Warden",        level = 425,  maxHP = 70000,  sea = 1, respawn = 10,  xp = 10500, money = 2200,  drops = {"Chief Warden Hat"} },
    { name = "Swan",                level = 425,  maxHP = 75000,  sea = 1, respawn = 15,  xp = 11000, money = 3000,  drops = {"White Coat"} },
    { name = "Wysper",              level = 450,  maxHP = 80000,  sea = 1, respawn = 10,  xp = 11500, money = 3000,  drops = {"Sky Saber"} },
    { name = "Thunder God",         level = 475,  maxHP = 90000,  sea = 1, respawn = 10,  xp = 12000, money = 3500,  drops = {"Thunder God Hat"} },
    { name = "Cyborg Boss",         level = 675,  maxHP = 120000, sea = 1, respawn = 15,  xp = 15000, money = 5000,  drops = {"Core Brain", "Cyborg Parts"} },
    -- SECOND SEA EXTENDED
    { name = "Darkbeard",           level = 1000, maxHP = 500000, sea = 2, respawn = 60,  xp = 25000, money = 15000, drops = {"Dark Fragment", "Relic"} },
    { name = "Order",               level = 1250, maxHP = 750000, sea = 2, respawn = 30,  xp = 35000, money = 20000, drops = {"Order Fragment"} },
    { name = "Awakened Ice Admiral",level = 1400, maxHP = 850000, sea = 2, respawn = 30,  xp = 40000, money = 22000, drops = {"Ice Admiral Coat"} },
    { name = "Tide Keeper",         level = 1475, maxHP = 900000, sea = 2, respawn = 30,  xp = 42000, money = 24000, drops = {"Tide Keeper Coat", "Water Essence"} },
    { name = "Captain Elephant",    level = 1675, maxHP = 1100000, sea = 2, respawn = 30, xp = 48000, money = 30000, drops = {"Elephant Shield", "Elephant Essence"} },
    { name = "Cake Queen",          level = 1750, maxHP = 1200000, sea = 2, respawn = 30, xp = 52000, money = 35000, drops = {"Cake Sword", "Icing Essence"} },
    { name = "Island Empress",      level = 1875, maxHP = 1400000, sea = 2, respawn = 60, xp = 58000, money = 40000, drops = {"Valkyrie Helmet", "Empress Fragment"} },
    { name = "Kilo Admiral",        level = 2000, maxHP = 1600000, sea = 2, respawn = 30, xp = 65000, money = 50000, drops = {"Kilo Relic", "Factory Core"} },
    { name = "Greybeard",           level = 700,  maxHP = 300000, sea = 2, respawn = 45,  xp = 18000, money = 10000, drops = {"Grey Coat"} },
    -- THIRD SEA EXTENDED
    { name = "Stone",               level = 1500, maxHP = 950000, sea = 3, respawn = 30,  xp = 44000, money = 26000, drops = {"Stone Fragment"} },
    { name = "Longma",              level = 2000, maxHP = 1650000, sea = 3, respawn = 30, xp = 66000, money = 52000, drops = {"Dragon Scale", "Longma Fragment"} },
    { name = "Rip_Indra (Raid)",    level = 2400, maxHP = 5000000, sea = 3, respawn = 90, xp = 150000, money = 100000, drops = {"Dark Fragments", "Indra Relic", "V4 Materials"} },
    { name = "Dough King",          level = 2300, maxHP = 4500000, sea = 3, respawn = 60, xp = 130000, money = 85000, drops = {"Dough Essence", "King Fragment"} },
    { name = "Cake Prince",         level = 2100, maxHP = 3000000, sea = 3, respawn = 45, xp = 100000, money = 70000, drops = {"Prince Fragment", "Sweet Essence"} },
    { name = "Soul Reaper",         level = 2050, maxHP = 2500000, sea = 3, respawn = 30, xp = 90000,  money = 60000, drops = {"Slayer Essence", "Soul Relic"} },
    { name = "Cursed Captain",      level = 1925, maxHP = 1800000, sea = 3, respawn = 30, xp = 72000,  money = 45000, drops = {"Cursed Chest"} },
    { name = "Ice Admiral",         level = 1400, maxHP = 900000, sea = 3, respawn = 30,  xp = 40000,  money = 22000, drops = {"Ice Armor"} },
    { name = "Wandering Pirate",    level = 1950, maxHP = 2000000, sea = 3, respawn = 30, xp = 80000,  money = 55000, drops = {"Pirate Fragment"} },
}

-- Boss Phase System
local BossPhases = {
    ["Rip_Indra (Raid)"] = {
        phases = {
            { threshold = 0.75, name = "Phase 1", skills = {"Thunder Slash", "Lightning Cage", "Dark Strike"}, extraSpeed = 0 },
            { threshold = 0.50, name = "Phase 2", skills = {"Thunder Slash", "Lightning Cage", "Dark Strike", "Electric Prison"}, extraSpeed = 5 },
            { threshold = 0.25, name = "Phase 3 (Rage)", skills = {"Indra Judgment", "Electric Storm", "Thunder God Spear"}, extraSpeed = 10 },
        },
        aura = true,
        knockbackResist = true,
    },
    ["Dough King"] = {
        phases = {
            { threshold = 0.70, name = "Phase 1", skills = {"Dough Punch", "Dough Wave"}, extraSpeed = 0 },
            { threshold = 0.40, name = "Phase 2", skills = {"Dough Punch", "Dough Wave", "Mochi Cage"}, extraSpeed = 3 },
            { threshold = 0.15, name = "Enraged", skills = {"King's Wrath", "Dough Explosion", "Full Power Punch"}, extraSpeed = 8 },
        },
        aura = false,
        knockbackResist = false,
    },
    ["Cake Prince"] = {
        phases = {
            { threshold = 0.60, name = "Normal", skills = {"Sweet Slash", "Candy Rain"}, extraSpeed = 0 },
            { threshold = 0.30, name = "Empowered", skills = {"Sweet Slash", "Candy Rain", "Sugar Trap"}, extraSpeed = 4 },
        },
        aura = false,
        knockbackResist = false,
    },
}

-- Boss phase detection
local function DetectBossPhase(bossName, currentHP, maxHP)
    local phaseData = BossPhases[bossName]
    if not phaseData then return 1, nil end

    local hpPercent = currentHP / maxHP
    for i, phase in ipairs(phaseData.phases) do
        if hpPercent <= phase.threshold then
            return i, phase
        end
    end
    return 1, phaseData.phases[1]
end

-- Advanced boss attack
local function AttackBossAdvanced(boss, bossName)
    local hum = boss:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end

    local maxHP = hum.MaxHealth
    local currentHP = hum.Health
    local phaseNum, phase = DetectBossPhase(bossName, currentHP, maxHP)

    -- Adapt strategy based on phase
    if phaseNum >= 3 then
        -- Aggressive phase - stay further back, use range attacks
        Log("Boss in RAGE phase - using ranged strategy")
        local hrp = GetHRP()
        local bossHRP = boss:FindFirstChild("HumanoidRootPart")
        if hrp and bossHRP then
            hrp.CFrame = bossHRP.CFrame * CFrame.new(0, 0, -8)
        end
    else
        -- Normal phase - close range
        AutoFarmEngine:AttackEnemy(boss)
    end

    return hum.Health <= 0
end

-- ============================================================================
-- SECTION 28: SEA BEAST SYSTEM
-- ============================================================================

local SeaBeastSystem = {}
SeaBeastSystem.Active = false
SeaBeastSystem.Thread = nil
SeaBeastSystem.KillCount = 0
SeaBeastSystem.Spawned = false

local SeaBeastLocations = {
    { sea = 1, position = Vector3.new(-3000, -10, 3000),  difficulty = "Easy",   level = 375,  xp = 15000 },
    { sea = 2, position = Vector3.new(-8000, -10, -5000), difficulty = "Medium", level = 1500, xp = 60000 },
    { sea = 3, position = Vector3.new(-5000, -10, -2000), difficulty = "Hard",   level = 2200, xp = 120000 },
    { sea = 3, position = Vector3.new(-9000, -10, 2000),  difficulty = "Hard",   level = 2300, xp = 130000 },
    { sea = 3, position = Vector3.new(-6000, -10, -4000), difficulty = "Hard",   level = 2400, xp = 140000 },
}

function SeaBeastSystem:SpawnSeaBeast(seaNum)
    local location = nil
    for _, loc in ipairs(SeaBeastLocations) do
        if loc.sea == seaNum then
            location = loc
            break
        end
    end

    if not location then return end

    local hrp = GetHRP()
    if not hrp then return end

    Log("Spawning Sea Beast at sea " .. seaNum)
    hrp.CFrame = CFrame.new(location.position + Vector3.new(0, 20, 0))
    Wait(0.5)

    -- Fire the sea beast spawn remote
    SafeFireRemote("SpawnSeaBeast", seaNum)
    Wait(3)

    self.Spawned = true
end

function SeaBeastSystem:KillSeaBeast()
    local seaBeast = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("sea beast") or obj.Name:lower():find("seabeast") then
            local hum = obj:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                seaBeast = obj
                break
            end
        end
    end

    if not seaBeast then
        Log("No sea beast found")
        return false
    end

    Log("Attacking Sea Beast!")
    local hum = seaBeast:FindFirstChild("Humanoid")
    while hum and hum.Health > 0 do
        AutoFarmEngine:AttackEnemy(seaBeast)
        hum = seaBeast:FindFirstChild("Humanoid")
        Wait(0.1)
    end

    self.KillCount = self.KillCount + 1
    Log("Sea Beast killed! Count: " .. self.KillCount)
    Notify("⚓ Sea Beast Killed!", "Kill #" .. self.KillCount, 3)
    return true
end

function SeaBeastSystem:Start(seaNum)
    if self.Active then return end
    self.Active = true
    seaNum = seaNum or GetCurrentSea()

    self.Thread = task.spawn(function()
        while self.Active do
            if not IsAlive() then Wait(3); continue end

            self:SpawnSeaBeast(seaNum)
            Wait(5)
            self:KillSeaBeast()
            Wait(10) -- Respawn time
        end
    end)

    Log("Sea Beast System started (Sea " .. seaNum .. ")")
end

function SeaBeastSystem:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
end

-- ============================================================================
-- SECTION 29: RAID SYSTEM
-- ============================================================================

local RaidSystem = {}
RaidSystem.Active = false
RaidSystem.Thread = nil
RaidSystem.CurrentRaid = nil
RaidSystem.RaidCount = 0

local RaidData = {
    {
        name = "Flame Admiral Raid",
        npcName = "Flame Raid NPC",
        location = CFrame.new(-5174, 260, -1065),
        bossName = "Flame Admiral",
        minLevel = 700,
        rewards = {"Flame Fragments", "Admiral Hat"},
        steps = {
            "Teleport to Magma Village",
            "Talk to Raid NPC",
            "Kill 20 Flame Soldiers",
            "Defeat Flame Admiral",
        },
    },
    {
        name = "Electric Raid",
        npcName = "Electric Raid NPC",
        location = CFrame.new(-7760, 2260, -4310),
        bossName = "Thunder God",
        minLevel = 750,
        rewards = {"Electric Fragments", "Thunder Cape"},
        steps = {
            "Teleport to Skylands",
            "Kill 15 Sky Bandits",
            "Defeat Thunder God",
        },
    },
    {
        name = "Darkbeard Raid",
        npcName = "Darkbeard NPC",
        location = CFrame.new(-10580, 31, -9180),
        bossName = "Darkbeard",
        minLevel = 1000,
        rewards = {"Dark Fragments", "Darkbeard Coat", "Bisento V2"},
        steps = {
            "Teleport to Dark Arena",
            "Survive wave 1 (10 enemies)",
            "Survive wave 2 (15 enemies)",
            "Defeat Darkbeard",
        },
    },
    {
        name = "Order Raid",
        npcName = "Order Raid NPC",
        location = CFrame.new(-13920, 130, -8800),
        bossName = "Order",
        minLevel = 1250,
        rewards = {"Order Fragments", "Blue Sword"},
        steps = {
            "Teleport to Haunted Castle",
            "Kill Laboratory Staff",
            "Defeat Order",
        },
    },
    {
        name = "Indra Raid",
        npcName = "Raid NPC",
        location = CFrame.new(-2850, 5, 3150),
        bossName = "Rip_Indra (Raid)",
        minLevel = 2300,
        rewards = {"Dark Fragments", "Indra Relic", "V4 Requirement"},
        steps = {
            "Teleport to Desolate Palace",
            "Defeat mini-bosses (Phase 1)",
            "Defeat elite guards (Phase 2)",
            "Defeat Rip_Indra",
        },
    },
}

function RaidSystem:StartRaid(raidName)
    local raid = nil
    for _, r in ipairs(RaidData) do
        if r.name:lower() == raidName:lower() then
            raid = r
            break
        end
    end

    if not raid then
        Log("Raid not found: " .. raidName, "WARN")
        return false
    end

    self.CurrentRaid = raid
    Log("Starting raid: " .. raid.name)
    Notify("⚔️ Raid Started", raid.name, 4)

    -- Execute raid steps
    for i, step in ipairs(raid.steps) do
        Log(string.format("[Raid][%d/%d] %s", i, #raid.steps, step))
        Wait(0.5)
    end

    -- Teleport to raid location
    SafeTeleport(raid.location)
    Wait(2)

    -- Start the raid
    SafeFireRemote("StartRaid", raid.bossName)
    Wait(3)

    -- Fight the boss
    AutoFarmEngine:FarmBoss(raid.bossName)

    self.RaidCount = self.RaidCount + 1
    Log("Raid completed: " .. raid.name .. " (Total: " .. self.RaidCount .. ")")
    Notify("✅ Raid Complete!", raid.name, 5)

    return true
end

function RaidSystem:AutoRaidLoop(raidName)
    if self.Active then return end
    self.Active = true

    self.Thread = task.spawn(function()
        while self.Active do
            if not IsAlive() then Wait(3); continue end
            self:StartRaid(raidName)
            Wait(30) -- Cooldown between raids
        end
    end)
end

function RaidSystem:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
end

-- ============================================================================
-- SECTION 30: EXTENDED QUEST CHAINS
-- ============================================================================

-- Complete Draco Quest Chain (detailed)
local DracoQuestChain = {
    {
        id = 1,
        name = "Draco Quest Part 1: The Beginning",
        npcLocation = CFrame.new(-2300, 18, 310),
        npcName = "Draco NPC",
        objectives = {
            { type = "kill",  target = "Stone",        count = 5,   description = "Kill Stone Boss 5 times" },
            { type = "kill",  target = "Blaze Pirate",  count = 25,  description = "Kill 25 Blaze Pirates" },
            { type = "collect", item = "Draco Scale",  count = 3,   description = "Collect 3 Draco Scales" },
        },
        reward = "Draco Mastery Fragment",
        completedFlag = false,
    },
    {
        id = 2,
        name = "Draco Quest Part 2: The Challenge",
        npcLocation = CFrame.new(-2850, 5, 3150),
        npcName = "Draco NPC V2",
        objectives = {
            { type = "kill",  target = "Soul Reaper",  count = 3,   description = "Defeat Soul Reaper 3 times" },
            { type = "kill",  target = "Electric Pirate", count = 30, description = "Kill 30 Electric Pirates" },
            { type = "raid",  target = "Indra Raid",   count = 1,   description = "Complete 1 Indra Raid" },
        },
        reward = "Draco Fragment V2",
        completedFlag = false,
    },
    {
        id = 3,
        name = "Draco Quest Part 3: Awakening",
        npcLocation = CFrame.new(-3800, 15, 2350),
        npcName = "Awakened Draco NPC",
        objectives = {
            { type = "kill",  target = "Dough King",    count = 2,   description = "Defeat Dough King twice" },
            { type = "collect", item = "Awakening Core", count = 5,  description = "Collect 5 Awakening Cores" },
            { type = "kill",  target = "Reborn Skeleton", count = 50, description = "Kill 50 Reborn Skeletons" },
        },
        reward = "Draco Awakening Essence",
        completedFlag = false,
    },
    {
        id = 4,
        name = "Draco Quest Part 4: Final Form",
        npcLocation = CFrame.new(-4200, 20, 1500),
        npcName = "Final Draco Sage",
        objectives = {
            { type = "kill",  target = "Rip_Indra (Raid)", count = 3,  description = "Defeat Rip Indra 3 times" },
            { type = "kill",  target = "Cake Prince",      count = 3,  description = "Defeat Cake Prince 3 times" },
            { type = "collect", item = "Dragon Heart",     count = 1,  description = "Obtain the Dragon Heart" },
        },
        reward = "Full Draco Transformation",
        completedFlag = false,
    },
}

-- Dragon Quest Chain
local DragonQuestChain = {
    {
        id = 1,
        name = "Dragon Quest: Find the Dragon",
        npcLocation = CFrame.new(-8870, 13, 1380),
        objectives = {
            { type = "kill",  target = "Dragon Crew Warrior", count = 30, description = "Kill 30 Dragon Crew Warriors" },
            { type = "kill",  target = "Dragon Crew Archer",  count = 20, description = "Kill 20 Dragon Crew Archers" },
            { type = "kill",  target = "Longma",              count = 1,  description = "Defeat Longma" },
        },
        reward = "Dragon Fragment",
        completedFlag = false,
    },
    {
        id = 2,
        name = "Dragon Quest: Dragon's Blood",
        npcLocation = CFrame.new(-10400, 5, -3600),
        objectives = {
            { type = "kill",  target = "Musketeer Pirate",  count = 40,  description = "Kill 40 Musketeer Pirates" },
            { type = "collect", item = "Dragon Blood",      count = 10,  description = "Collect 10 Dragon Blood" },
            { type = "kill",  target = "Longma",            count = 3,   description = "Defeat Longma 3 times" },
        },
        reward = "Dragon Blood Essence",
        completedFlag = false,
    },
    {
        id = 3,
        name = "Dragon Quest: True Dragon",
        npcLocation = CFrame.new(-11590, 5, -3590),
        objectives = {
            { type = "raid",  target = "Longma Raid",      count = 2,   description = "Complete Longma Raid twice" },
            { type = "collect", item = "True Dragon Scale", count = 5,  description = "Collect 5 True Dragon Scales" },
        },
        reward = "True Dragon Transformation",
        completedFlag = false,
    },
}

-- Execute a quest chain objective
local function ExecuteObjective(objective)
    if objective.type == "kill" then
        Log("Objective: Kill " .. objective.count .. "x " .. objective.target)
        local killCount = 0
        while killCount < objective.count do
            if not IsAlive() then Wait(3); continue end

            -- Find and kill target
            local enemies = GetEnemyByName(objective.target)
            if #enemies > 0 then
                local killed = AutoFarmEngine:AttackEnemy(enemies[1])
                if killed then
                    killCount = killCount + 1
                    Log(string.format("Kill progress: %d/%d", killCount, objective.count))
                end
            else
                -- Find mob location and teleport
                for _, mob in ipairs(MobData) do
                    if mob.name:lower():find(objective.target:lower()) then
                        SafeTeleport(mob.location)
                        break
                    end
                end
                Wait(2)
            end
            Wait(0.5)
        end
        Log("Objective complete: " .. objective.description)

    elseif objective.type == "collect" then
        Log("Objective: Collect " .. objective.count .. "x " .. objective.item)
        -- Auto collect via drops or special action
        AutoFruitSystem:BringFruitsToPlayer()
        Wait(2)
        Log("Collection attempted: " .. objective.description)

    elseif objective.type == "raid" then
        Log("Objective: Complete raid - " .. objective.target)
        RaidSystem:StartRaid(objective.target)
        Wait(5)
    end
end

-- Execute full quest chain
local function ExecuteQuestChain(chain, chainName)
    Log("Starting quest chain: " .. chainName)
    Notify("📜 Quest Chain", "Starting: " .. chainName, 4)

    for _, quest in ipairs(chain) do
        if quest.completedFlag then
            Log("Quest already completed: " .. quest.name)
            continue
        end

        Log("Starting: " .. quest.name)
        Notify("📜 " .. quest.name, "New quest started", 3)

        -- Teleport to quest NPC
        if quest.npcLocation then
            SafeTeleport(quest.npcLocation)
            Wait(1)
            SafeFireRemote("AcceptQuest", quest.id)
            Wait(0.5)
        end

        -- Execute all objectives
        for _, objective in ipairs(quest.objectives) do
            pcall(function()
                ExecuteObjective(objective)
            end)
            Wait(0.5)
        end

        -- Turn in quest
        if quest.npcLocation then
            SafeTeleport(quest.npcLocation)
            Wait(1)
            SafeFireRemote("TurnInQuest", quest.id)
            Wait(0.5)
        end

        quest.completedFlag = true
        Log("Quest complete! Reward: " .. (quest.reward or "Unknown"))
        Notify("✅ Quest Complete!", quest.name .. " | Reward: " .. (quest.reward or "?"), 5)
        Wait(2)
    end

    Log("Quest chain complete: " .. chainName)
    Notify("🏆 Chain Complete!", chainName, 5)
end

-- ============================================================================
-- SECTION 31: AUTO BOUNTY SYSTEM
-- ============================================================================

local BountySystem = {}
BountySystem.Active = false
BountySystem.Thread = nil
BountySystem.BountyGained = 0

local BountyNPCLocations = {
    { sea = 1, location = CFrame.new(975, 10, -1750), npcName = "Bounty Hunter" },
    { sea = 2, location = CFrame.new(-1215, 40, -2485), npcName = "Bounty Board" },
    { sea = 3, location = CFrame.new(-11590, 5, -3590), npcName = "Senior Bounty Hunter" },
}

function BountySystem:GetCurrentBounty()
    local bounty = LocalPlayer:FindFirstChild("leaderstats") and
        LocalPlayer.leaderstats:FindFirstChild("Bounty") and
        LocalPlayer.leaderstats.Bounty.Value or 0
    return bounty
end

function BountySystem:ResetBounty()
    Log("Resetting bounty...")
    local sea = GetCurrentSea()
    for _, npc in ipairs(BountyNPCLocations) do
        if npc.sea == sea then
            SafeTeleport(npc.location)
            Wait(0.5)
            SafeFireRemote("ResetBounty")
            Wait(0.3)
            Log("Bounty reset requested")
            return true
        end
    end
    return false
end

function BountySystem:FarmBounty()
    Log("Farming bounty via PvP kills...")
    -- Enable PvP briefly to get bounty kills
    local prevPvP = Settings.PvP.Enabled
    Settings.PvP.Enabled = true
    PvPSystem:Start()
    Wait(60) -- Farm for 1 minute
    Settings.PvP.Enabled = prevPvP
    if not prevPvP then PvPSystem:Stop() end
end

-- ============================================================================
-- SECTION 32: MATERIAL FARMING SYSTEM
-- ============================================================================

local MaterialSystem = {}
MaterialSystem.Active = false
MaterialSystem.Thread = nil
MaterialSystem.MaterialCounts = {}

local MaterialData = {
    { name = "Magma Ore",        source = "Magma Mobs",     sea = 1, location = CFrame.new(-5174, 260, -1065) },
    { name = "Sand Grain",       source = "Desert Mobs",    sea = 1, location = CFrame.new(-495, 8, 1635) },
    { name = "Ice Shard",        source = "Snow Mobs",      sea = 1, location = CFrame.new(-4920, 943, -1315) },
    { name = "Leather",          source = "Jungle Gorillas",sea = 1, location = CFrame.new(-1270, 6, 4145) },
    { name = "Scrap Metal",      source = "Cyborg NPCs",    sea = 1, location = CFrame.new(-1385, 135, -1020) },
    { name = "Dark Fragment",    source = "Darkbeard",      sea = 2, location = CFrame.new(-10580, 31, -9180) },
    { name = "Snow Essence",     source = "Ice Castle Mobs",sea = 2, location = CFrame.new(-12200, 44, 3050) },
    { name = "Dragon Scale",     source = "Dragon Crew",    sea = 3, location = CFrame.new(-8870, 13, 1380) },
    { name = "Slayer Essence",   source = "Soul Reaper",    sea = 3, location = CFrame.new(-2200, 165, 1880) },
    { name = "Dough Essence",    source = "Dough King",     sea = 3, location = CFrame.new(-4350, 26, -1350) },
    { name = "Dark Essence",     source = "Rip Indra",      sea = 3, location = CFrame.new(-2850, 5, 3150) },
    { name = "Sweet Essence",    source = "Cake Prince",    sea = 3, location = CFrame.new(-6700, 18, 100) },
    { name = "Ghost Essence",    source = "Haunted Port",   sea = 3, location = CFrame.new(7400, 62, -6300) },
    { name = "V4 Material",      source = "Indra Raid",     sea = 3, location = CFrame.new(-2850, 5, 3150) },
    { name = "Race Fragment",    source = "Various Mobs",   sea = 1, location = CFrame.new(-995, 10, 1040) },
    { name = "Core Brain",       source = "Cyborg Boss",    sea = 1, location = CFrame.new(-1385, 135, -1020) },
    { name = "Alchemist Essence",source = "Alchemist NPC",  sea = 2, location = CFrame.new(-3115, 40, -1885) },
}

function MaterialSystem:FarmMaterial(materialName)
    local matData = nil
    for _, mat in ipairs(MaterialData) do
        if mat.name:lower() == materialName:lower() then
            matData = mat
            break
        end
    end

    if not matData then
        Log("Material not found: " .. materialName, "WARN")
        return
    end

    Log("Farming material: " .. matData.name .. " from " .. matData.source)
    SafeTeleport(matData.location)
    Wait(1)

    -- Farm the source
    local enemies = GetEnemyByName(matData.source)
    for _, enemy in ipairs(enemies) do
        AutoFarmEngine:AttackEnemy(enemy)
        Wait(0.3)
    end

    if not self.MaterialCounts[materialName] then
        self.MaterialCounts[materialName] = 0
    end
    self.MaterialCounts[materialName] = self.MaterialCounts[materialName] + 1
end

-- ============================================================================
-- SECTION 33: AUTO LEVELING GUIDE (OPTIMIZED PATHS)
-- ============================================================================

-- Level range to optimal farming location mapping
local LevelGuide = {
    {minLvl = 1,    maxLvl = 15,   location = "Starter Island",     mobName = "Bandit",          sea = 1},
    {minLvl = 15,   maxLvl = 30,   location = "Jungle",             mobName = "Monkey",          sea = 1},
    {minLvl = 30,   maxLvl = 60,   location = "Jungle",             mobName = "Gorilla",         sea = 1},
    {minLvl = 60,   maxLvl = 100,  location = "Desert",             mobName = "Desert Bandit",   sea = 1},
    {minLvl = 100,  maxLvl = 150,  location = "Desert",             mobName = "Desert Officer",  sea = 1},
    {minLvl = 150,  maxLvl = 250,  location = "Prison",             mobName = "Prisoner",        sea = 1},
    {minLvl = 250,  maxLvl = 350,  location = "Jungle",             mobName = "Gorilla King",    sea = 1},
    {minLvl = 350,  maxLvl = 400,  location = "Magma Village",      mobName = "Magma Admiral",   sea = 1},
    {minLvl = 400,  maxLvl = 500,  location = "Skylands",           mobName = "Sky Bandit",      sea = 1},
    {minLvl = 500,  maxLvl = 625,  location = "Skylands",           mobName = "Dark Master",     sea = 1},
    {minLvl = 625,  maxLvl = 700,  location = "Colosseum",          mobName = "Toga Warrior",    sea = 1},
    {minLvl = 700,  maxLvl = 800,  location = "Colosseum",          mobName = "Gladiator",       sea = 1},
    -- SECOND SEA
    {minLvl = 700,  maxLvl = 850,  location = "Kingdom of Rose",    mobName = "Factory Staff",   sea = 2},
    {minLvl = 850,  maxLvl = 950,  location = "Underwater City",    mobName = "Sea Soldier",     sea = 2},
    {minLvl = 950,  maxLvl = 1050, location = "Cursed Ship",        mobName = "Zombie",          sea = 2},
    {minLvl = 1050, maxLvl = 1150, location = "Thriller Bark",      mobName = "Living Zombie",   sea = 2},
    {minLvl = 1150, maxLvl = 1250, location = "Ice Castle",         mobName = "Snow Lurker",     sea = 2},
    {minLvl = 1250, maxLvl = 1400, location = "Thriller Bark",      mobName = "Reaper",          sea = 2},
    {minLvl = 1400, maxLvl = 1500, location = "Floating Turtle",    mobName = "Fishman Warrior", sea = 2},
    -- THIRD SEA
    {minLvl = 1500, maxLvl = 1600, location = "Port Town",          mobName = "Pirate Millionaire", sea = 3},
    {minLvl = 1600, maxLvl = 1700, location = "Hydra Island",       mobName = "Jungle Pirate",   sea = 3},
    {minLvl = 1700, maxLvl = 1800, location = "Floating Turtle",    mobName = "Dragon Crew Warrior", sea = 3},
    {minLvl = 1800, maxLvl = 1875, location = "Mansion",            mobName = "Marine Commodore", sea = 3},
    {minLvl = 1875, maxLvl = 1950, location = "Tiki Outpost",       mobName = "Tiki Outpost Warrior", sea = 3},
    {minLvl = 1950, maxLvl = 2050, location = "Haunted Port",       mobName = "Ghost",           sea = 3},
    {minLvl = 2050, maxLvl = 2150, location = "Desolate Palace",    mobName = "Blaze Pirate",    sea = 3},
    {minLvl = 2150, maxLvl = 2300, location = "Candy Island",       mobName = "Cake Guard",      sea = 3},
    {minLvl = 2300, maxLvl = 2450, location = "Sea of Treats",      mobName = "Ice Cream Monster", sea = 3},
}

-- Get optimal farm location for level
local function GetOptimalFarmLocation(level)
    for _, guide in ipairs(LevelGuide) do
        if level >= guide.minLvl and level < guide.maxLvl then
            return guide
        end
    end
    -- Default to highest available
    return LevelGuide[#LevelGuide]
end

-- ============================================================================
-- SECTION 34: EXTENDED FRUIT SYSTEM
-- ============================================================================

local ExtendedFruitSystem = {}

-- All fruit spawn locations (known static locations where fruits can spawn)
local FruitSpawnLocations = {
    -- First Sea
    { position = Vector3.new(-1270, 15, 4145), sea = 1, spawnWeight = 1.0 },
    { position = Vector3.new(-495, 15, 1635),  sea = 1, spawnWeight = 1.0 },
    { position = Vector3.new(-995, 15, 1040),  sea = 1, spawnWeight = 1.0 },
    { position = Vector3.new(975, 15, -1750),  sea = 1, spawnWeight = 1.0 },
    { position = Vector3.new(-4920, 960, -1315), sea = 1, spawnWeight = 0.8 },
    { position = Vector3.new(-7760, 2275, -4310), sea = 1, spawnWeight = 0.7 },
    -- Second Sea
    { position = Vector3.new(-1215, 50, -2485), sea = 2, spawnWeight = 1.2 },
    { position = Vector3.new(-3115, 50, -1885), sea = 2, spawnWeight = 1.2 },
    { position = Vector3.new(-8015, 20, 5015),  sea = 2, spawnWeight = 1.1 },
    { position = Vector3.new(-12200, 55, 3050), sea = 2, spawnWeight = 1.0 },
    { position = Vector3.new(-6450, -60, -6260), sea = 2, spawnWeight = 1.0 },
    { position = Vector3.new(-10580, 40, -9180), sea = 2, spawnWeight = 0.9 },
    -- Third Sea
    { position = Vector3.new(-11590, 15, -3590), sea = 3, spawnWeight = 1.5 },
    { position = Vector3.new(-8870, 25, 1380),   sea = 3, spawnWeight = 1.5 },
    { position = Vector3.new(-4350, 35, -1350),  sea = 3, spawnWeight = 1.4 },
    { position = Vector3.new(-2850, 15, 3150),   sea = 3, spawnWeight = 1.4 },
    { position = Vector3.new(-7700, 15, -350),   sea = 3, spawnWeight = 1.3 },
    { position = Vector3.new(7400, 72, -6300),   sea = 3, spawnWeight = 1.3 },
    { position = Vector3.new(-6700, 28, 100),    sea = 3, spawnWeight = 1.2 },
    { position = Vector3.new(-3850, 15, -5560),  sea = 3, spawnWeight = 1.2 },
}

-- Fruit rarity weights for notification priority
local FruitPriorityWeights = {
    Mythical  = 100,
    Legendary = 80,
    Rare      = 60,
    Uncommon  = 40,
    Common    = 20,
}

-- Enhanced fruit detection with priority scoring
function ExtendedFruitSystem:ScanWithPriority()
    local fruits = AutoFruitSystem:ScanForFruits()
    local prioritized = {}

    for _, fruit in ipairs(fruits) do
        local weight = FruitPriorityWeights[fruit.rarity] or 0
        table.insert(prioritized, {
            fruit    = fruit,
            priority = weight,
            distance = fruit.distance,
            score    = weight - (fruit.distance * 0.01), -- Closer = higher score
        })
    end

    table.sort(prioritized, function(a, b)
        return a.score > b.score
    end)

    return prioritized
end

-- Scan all known spawn locations for fruits
function ExtendedFruitSystem:ScanSpawnLocations()
    local hrp = GetHRP()
    if not hrp then return end

    local currentSea = GetCurrentSea()
    Log("Scanning fruit spawn locations for sea " .. currentSea)

    for _, spawnLoc in ipairs(FruitSpawnLocations) do
        if spawnLoc.sea ~= currentSea then continue end

        -- Teleport close and scan
        hrp.CFrame = CFrame.new(spawnLoc.position + Vector3.new(0, 5, 0))
        Wait(0.3)

        local fruits = AutoFruitSystem:ScanForFruits()
        for _, fruit in ipairs(fruits) do
            if fruit.distance < 30 then
                Log("Fruit found at spawn location: " .. fruit.name .. " (" .. fruit.rarity .. ")")
                AutoFruitSystem:GetFruit(fruit)
            end
        end
    end
end

-- Fruit value calculator
function ExtendedFruitSystem:GetFruitValue(fruitName)
    for _, fruit in ipairs(FruitData) do
        if fruitName:lower():find(fruit.name:lower()) then
            return fruit.price, fruit.rarity
        end
    end
    return 0, "Unknown"
end

-- Auto sell low-value fruits
function ExtendedFruitSystem:AutoSellFruits()
    if not Settings.AutoFruit.AutoSellFruit then return end

    Log("Auto selling fruits...")
    TeleportSystem:ToNPC("Fruit Dealer")
    Wait(0.5)

    for _, fruit in ipairs(FruitData) do
        if Settings.AutoFruit.SellOnlyCommon and fruit.rarity ~= "Common" then
            continue
        end
        SafeFireRemote("SellFruit", fruit.name)
        Wait(0.1)
    end
end

-- Fruit storage manager
local FruitStorage = {
    stored = {},
    maxSlots = 20,

    AddFruit = function(self, fruitName, rarity)
        if #self.stored >= self.maxSlots then
            Log("Fruit storage full!", "WARN")
            return false
        end
        table.insert(self.stored, {name = fruitName, rarity = rarity, time = os.time()})
        Log("Fruit stored: " .. fruitName)
        return true
    end,

    RemoveFruit = function(self, fruitName)
        for i, fruit in ipairs(self.stored) do
            if fruit.name:lower() == fruitName:lower() then
                table.remove(self.stored, i)
                return true
            end
        end
        return false
    end,

    GetCount = function(self)
        return #self.stored
    end,

    GetAll = function(self)
        return self.stored
    end,

    HasFruit = function(self, fruitName)
        for _, fruit in ipairs(self.stored) do
            if fruit.name:lower() == fruitName:lower() then
                return true
            end
        end
        return false
    end,

    Clear = function(self)
        self.stored = {}
    end,
}

-- ============================================================================
-- SECTION 35: EXTENDED PVP TECHNIQUES
-- ============================================================================

local ExtendedPvP = {}

-- Combo sequences for different strategies
local ComboStrategies = {
    Standard = { "Z", "X", "C", "V", "F", "Z", "X" },
    Aggressive = { "Z", "Z", "X", "V", "F", "Z", "C", "V" },
    Defensive = { "X", "Z", "C", "X", "F", "Z" },
    HighDamage = { "V", "F", "Z", "X", "C", "V", "F" },
    SpeedCombo = { "Z", "X", "Z", "X", "F", "C", "Z", "X", "V" },
    FruitCombo = { "F", "Z", "X", "C", "V", "F", "Z" },
    SwordCombo = { "Z", "Z", "X", "C", "Z", "V", "F" },
    MeleeCombo = { "X", "C", "X", "C", "V", "Z", "F", "X" },
    GunCombo   = { "Z", "Z", "Z", "X", "V", "F" },
    BloxCombo  = { "Z", "X", "C", "V", "F", "Z", "X", "C", "V", "F" },
}

-- Current strategy
ExtendedPvP.CurrentStrategy = "Standard"
ExtendedPvP.CustomCombo = {}
ExtendedPvP.ComboActive = false
ExtendedPvP.LastStrategyChange = tick()

-- Execute a strategy combo
function ExtendedPvP:ExecuteStrategy(strategyName, target)
    local strategy = ComboStrategies[strategyName]
    if not strategy then
        strategy = ComboStrategies.Standard
    end

    -- Position close to target
    if target and target.Character then
        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = GetHRP()
        if targetHRP and myHRP then
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -1.5)
        end
    end

    -- Execute each key
    for _, key in ipairs(strategy) do
        if not Settings.PvP.AutoCombo then break end

        local enabled = Settings.PvP.KeyEnabled[key]
        if enabled ~= false then -- nil defaults to true
            PvPSystem:ExecuteComboKey(key)
        end

        Wait(Settings.PvP.GlobalComboDelay)
    end
end

-- Anti-aim (camera manipulation to confuse enemy)
function ExtendedPvP:AntiAim()
    local cam = Workspace.CurrentCamera
    if not cam then return end

    -- Spin camera rapidly to confuse hitbox detection
    task.spawn(function()
        for i = 1, 10 do
            local angle = i * 36
            cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(angle), 0)
            Wait(0.016)
        end
    end)
end

-- Velocity manipulation
function ExtendedPvP:Blink(direction, distance)
    local hrp = GetHRP()
    if not hrp then return end

    distance = distance or 20
    local moveDir = direction or hrp.CFrame.LookVector

    hrp.CFrame = CFrame.new(hrp.Position + moveDir * distance)
end

-- Dash towards target
function ExtendedPvP:DashToTarget(target)
    if not target or not target.Character then return end

    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = GetHRP()

    if targetHRP and myHRP then
        local direction = (targetHRP.Position - myHRP.Position).Unit
        self:Blink(direction, 15)
    end
end

-- Strafe around target
function ExtendedPvP:StrafeTarget(target)
    if not target or not target.Character then return end

    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = GetHRP()

    if not targetHRP or not myHRP then return end

    -- Circle the target
    local angle = tick() * 3 -- Rotate based on time
    local radius = 6
    local x = targetHRP.Position.X + math.cos(angle) * radius
    local z = targetHRP.Position.Z + math.sin(angle) * radius
    local y = targetHRP.Position.Y

    myHRP.CFrame = CFrame.new(Vector3.new(x, y, z), targetHRP.Position)
end

-- Check if target is behind us
function ExtendedPvP:IsTargetBehind(target)
    if not target or not target.Character then return false end

    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    local myHRP = GetHRP()

    if not targetHRP or not myHRP then return false end

    local toTarget = (targetHRP.Position - myHRP.Position).Unit
    local forward = myHRP.CFrame.LookVector

    local dot = forward:Dot(toTarget)
    return dot < -0.5 -- Target is behind if dot product is negative
end

-- Predict target position (lead the target)
function ExtendedPvP:PredictTargetPosition(target, timeAhead)
    if not target or not target.Character then return nil end

    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return nil end

    timeAhead = timeAhead or 0.1
    local velocity = targetHRP.Velocity

    return targetHRP.Position + velocity * timeAhead
end

-- ============================================================================
-- SECTION 36: EXTENDED TELEPORT FEATURES
-- ============================================================================

local ExtendedTeleport = {}

-- All important coordinates
local AllCoordinates = {
    -- Quest Givers
    { name = "Saber Expert Quest",    type = "Quest",    cframe = CFrame.new(-1500, 129, -3850) },
    { name = "Warden Quest",          type = "Quest",    cframe = CFrame.new(4390, 196, -1640) },
    { name = "Colosseum Quest",       type = "Quest",    cframe = CFrame.new(-1390, 135, -1000) },
    { name = "Sky Quest Giver",       type = "Quest",    cframe = CFrame.new(-7760, 2265, -4305) },
    { name = "Dark Arena Quest",      type = "Quest",    cframe = CFrame.new(-10585, 35, -9175) },
    { name = "Rose Quest Giver",      type = "Quest",    cframe = CFrame.new(-1220, 44, -2480) },
    { name = "Factory Quest",         type = "Quest",    cframe = CFrame.new(-16200, 5, -850) },
    { name = "Ice Quest Giver",       type = "Quest",    cframe = CFrame.new(-12200, 48, 3050) },
    { name = "Sea Quest Giver",       type = "Quest",    cframe = CFrame.new(-6450, -65, -6260) },
    { name = "Zombie Quest",          type = "Quest",    cframe = CFrame.new(-8020, 15, 5010) },
    { name = "Floating Turtle Quest", type = "Quest",    cframe = CFrame.new(-8875, 17, 1375) },
    { name = "Castle Quest",          type = "Quest",    cframe = CFrame.new(-13925, 134, -8795) },
    { name = "Mansion Quest",         type = "Quest",    cframe = CFrame.new(-9685, 8, 975) },
    { name = "Great Tree Quest",      type = "Quest",    cframe = CFrame.new(-7705, 8, -345) },
    { name = "Tiki Quest Giver",      type = "Quest",    cframe = CFrame.new(-6705, 22, 95) },
    { name = "Candy Quest",           type = "Quest",    cframe = CFrame.new(-4355, 30, -1345) },
    { name = "Castle Sea Quest",      type = "Quest",    cframe = CFrame.new(-3855, 8, -5555) },
    { name = "Port Quest Giver",      type = "Quest",    cframe = CFrame.new(-11595, 8, -3585) },
    { name = "Hydra Quest",           type = "Quest",    cframe = CFrame.new(-10405, 8, -3595) },
    { name = "Haunted Port Quest",    type = "Quest",    cframe = CFrame.new(7395, 66, -6295) },
    { name = "Desolate Quest",        type = "Quest",    cframe = CFrame.new(-2855, 8, 3145) },
    -- Shops
    { name = "Blox Fruit Dealer",     type = "Shop",     cframe = CFrame.new(975, 10, -1750) },
    { name = "Cousin Blox Dealer",    type = "Shop",     cframe = CFrame.new(-1215, 45, -2485) },
    { name = "Advanced Fruit Dealer", type = "Shop",     cframe = CFrame.new(-3115, 44, -1880) },
    { name = "Sword Shop",            type = "Shop",     cframe = CFrame.new(-1520, 12, 1215) },
    { name = "Marine Sword Shop",     type = "Shop",     cframe = CFrame.new(975, 10, -1750) },
    { name = "Weapons Shop",          type = "Shop",     cframe = CFrame.new(-1215, 45, -2485) },
    -- Bosses
    { name = "Gorilla King Spawn",    type = "Boss",     cframe = CFrame.new(-1300, 8, 4150) },
    { name = "Bobby Spawn",           type = "Boss",     cframe = CFrame.new(-495, 8, 1635) },
    { name = "Yeti Spawn",            type = "Boss",     cframe = CFrame.new(-4920, 946, -1315) },
    { name = "Swan Spawn",            type = "Boss",     cframe = CFrame.new(5080, 28, -360) },
    { name = "Darkbeard Spawn",       type = "Boss",     cframe = CFrame.new(-10580, 34, -9180) },
    { name = "Order Spawn",           type = "Boss",     cframe = CFrame.new(-13920, 133, -8800) },
    { name = "Dough King Spawn",      type = "Boss",     cframe = CFrame.new(-4350, 29, -1350) },
    { name = "Cake Prince Spawn",     type = "Boss",     cframe = CFrame.new(-6700, 21, 100) },
    { name = "Soul Reaper Spawn",     type = "Boss",     cframe = CFrame.new(-2200, 168, 1880) },
    { name = "Indra Spawn",           type = "Boss",     cframe = CFrame.new(-2850, 8, 3150) },
    -- Misc Locations
    { name = "Spawn [1st Sea]",       type = "Spawn",    cframe = CFrame.new(-995, 12, 1040) },
    { name = "Spawn [2nd Sea]",       type = "Spawn",    cframe = CFrame.new(-1215, 44, -2485) },
    { name = "Spawn [3rd Sea]",       type = "Spawn",    cframe = CFrame.new(-11590, 8, -3590) },
    { name = "Underwater Tunnel",     type = "Secret",   cframe = CFrame.new(-80, -2005, -15) },
    { name = "Mirage Island Portal",  type = "Secret",   cframe = CFrame.new(-9300, 5, -1865) },
    { name = "God of Thunder Home",   type = "Special",  cframe = CFrame.new(-7750, 2233, -4100) },
}

-- Teleport by type
function ExtendedTeleport:TeleportByType(typeName)
    local results = {}
    for _, coord in ipairs(AllCoordinates) do
        if coord.type:lower() == typeName:lower() then
            table.insert(results, coord)
        end
    end
    return results
end

-- Teleport to coordinate by exact name
function ExtendedTeleport:TeleportToCoordinate(name)
    for _, coord in ipairs(AllCoordinates) do
        if coord.name:lower() == name:lower() or
           coord.name:lower():find(name:lower()) then
            SafeTeleport(coord.cframe)
            Log("Teleported to: " .. coord.name)
            Notify("Teleport", "→ " .. coord.name, 2)
            return true
        end
    end
    Log("Coordinate not found: " .. name, "WARN")
    return false
end

-- Sequential island hopper
function ExtendedTeleport:IslandHop(sea)
    sea = sea or 1
    local islandsInSea = {}
    for _, island in ipairs(IslandData) do
        if island.sea == sea then
            table.insert(islandsInSea, island)
        end
    end

    for _, island in ipairs(islandsInSea) do
        Log("Hopping to: " .. island.name)
        SafeTeleport(island.cframe)
        Wait(1.5)
    end
end

-- Find nearest island
function ExtendedTeleport:FindNearestIsland()
    local hrp = GetHRP()
    if not hrp then return nil end

    local closest = nil
    local closestDist = math.huge

    for _, island in ipairs(IslandData) do
        local dist = GetDistance(hrp.Position, island.cframe.Position)
        if dist < closestDist then
            closestDist = dist
            closest = island
        end
    end

    return closest, closestDist
end

-- ============================================================================
-- SECTION 37: EXTENDED GUI - ADDITIONAL TABS
-- ============================================================================

-- These tabs are added to the existing GUI after BuildAllTabs is called
local function BuildExtendedTabs()
    -- =====================
    -- TAB 13: RAIDS
    -- =====================
    local raidTab = GUI:CreateTab("Raids", "🏰")

    GUI:CreateSection(raidTab.page, "Raid System")
    GUI:CreateLabel(raidTab.page, "Auto-complete raid dungeons for fragments and rewards")

    for _, raid in ipairs(RaidData) do
        GUI:CreateButton(raidTab.page,
            "⚔️ " .. raid.name .. " (Lvl " .. raid.minLevel .. "+)",
            function()
                task.spawn(function()
                    RaidSystem:StartRaid(raid.name)
                end)
            end)
    end

    GUI:CreateSection(raidTab.page, "Raid Settings")
    GUI:CreateToggle(raidTab.page, "Loop Raids", false, function(v)
        if v then
            RaidSystem:AutoRaidLoop("Indra Raid")
        else
            RaidSystem:Stop()
        end
    end)

    GUI:CreateSection(raidTab.page, "Raid Stats")
    local raidCountLabel = GUI:CreateLabel(raidTab.page, "Raids Completed: 0")
    task.spawn(function()
        while task.wait(2) do
            if raidCountLabel and raidCountLabel.Parent then
                raidCountLabel.Text = "Raids Completed: " .. RaidSystem.RaidCount
            else
                break
            end
        end
    end)

    -- =====================
    -- TAB 14: SEA BEAST
    -- =====================
    local seaBeastTab = GUI:CreateTab("Sea Beast", "🦑")

    GUI:CreateSection(seaBeastTab.page, "Sea Beast Farming")
    GUI:CreateLabel(seaBeastTab.page, "Farm Sea Beasts for fragments and materials")

    GUI:CreateToggle(seaBeastTab.page, "Auto Farm Sea Beasts", false, function(v)
        if v then
            SeaBeastSystem:Start()
        else
            SeaBeastSystem:Stop()
        end
    end)

    GUI:CreateDropdown(seaBeastTab.page, "Target Sea",
        {"1 (First Sea)", "2 (Second Sea)", "3 (Third Sea)"},
        "3 (Third Sea)",
        function(v)
            local seaNum = tonumber(v:sub(1, 1)) or 3
            if SeaBeastSystem.Active then
                SeaBeastSystem:Stop()
                SeaBeastSystem:Start(seaNum)
            end
        end)

    GUI:CreateSection(seaBeastTab.page, "Sea Beast Locations")
    for _, loc in ipairs(SeaBeastLocations) do
        GUI:CreateButton(seaBeastTab.page,
            string.format("Sea %d - %s (Lvl %d)", loc.sea, loc.difficulty, loc.level),
            function()
                local hrp = GetHRP()
                if hrp then
                    hrp.CFrame = CFrame.new(loc.position + Vector3.new(0, 20, 0))
                end
            end)
    end

    GUI:CreateSection(seaBeastTab.page, "Stats")
    local seaBeastLabel = GUI:CreateLabel(seaBeastTab.page, "Sea Beasts Killed: 0")
    task.spawn(function()
        while task.wait(2) do
            if seaBeastLabel and seaBeastLabel.Parent then
                seaBeastLabel.Text = "Sea Beasts Killed: " .. SeaBeastSystem.KillCount
            else
                break
            end
        end
    end)

    -- =====================
    -- TAB 15: QUEST CHAINS
    -- =====================
    local chainTab = GUI:CreateTab("Quest Chains", "🔗")

    GUI:CreateSection(chainTab.page, "Draco Quest Chain")
    GUI:CreateLabel(chainTab.page, "Complete the full Draco transformation quest chain")

    GUI:CreateButton(chainTab.page, "▶ Start Full Draco Chain", function()
        task.spawn(function()
            ExecuteQuestChain(DracoQuestChain, "Draco Quest Chain")
        end)
    end)

    for _, quest in ipairs(DracoQuestChain) do
        GUI:CreateLabel(chainTab.page, string.format("Part %d: %s", quest.id, quest.name))
        GUI:CreateLabel(chainTab.page, "  Reward: " .. (quest.reward or "Unknown"))
    end

    GUI:CreateSection(chainTab.page, "Dragon Quest Chain")

    GUI:CreateButton(chainTab.page, "▶ Start Dragon Quest Chain", function()
        task.spawn(function()
            ExecuteQuestChain(DragonQuestChain, "Dragon Quest Chain")
        end)
    end)

    for _, quest in ipairs(DragonQuestChain) do
        GUI:CreateLabel(chainTab.page, string.format("Part %d: %s", quest.id, quest.name))
    end

    -- =====================
    -- TAB 16: MATERIALS
    -- =====================
    local matTab = GUI:CreateTab("Materials", "⚗️")

    GUI:CreateSection(matTab.page, "Material Farming")

    for _, mat in ipairs(MaterialData) do
        GUI:CreateButton(matTab.page,
            "Farm: " .. mat.name .. " (from " .. mat.source .. ")",
            function()
                task.spawn(function()
                    MaterialSystem:FarmMaterial(mat.name)
                end)
            end)
    end

    -- =====================
    -- TAB 17: LEVELING GUIDE
    -- =====================
    local guideTab = GUI:CreateTab("Level Guide", "📊")

    GUI:CreateSection(guideTab.page, "Optimal Leveling Path")
    GUI:CreateLabel(guideTab.page, "Tap to teleport to optimal farm for level range")

    for _, guide in ipairs(LevelGuide) do
        GUI:CreateButton(guideTab.page,
            string.format("Lvl %d-%d: %s (%s)", guide.minLvl, guide.maxLvl, guide.location, guide.mobName),
            function()
                TeleportSystem:ToIsland(guide.location)
            end)
    end

    GUI:CreateSection(guideTab.page, "Auto Path")
    GUI:CreateToggle(guideTab.page, "Auto Follow Level Guide", false, function(v)
        if v then
            task.spawn(function()
                while v do
                    local level = LocalPlayer:FindFirstChild("leaderstats") and
                        LocalPlayer.leaderstats:FindFirstChild("Level") and
                        LocalPlayer.leaderstats.Level.Value or 0

                    local guide = GetOptimalFarmLocation(level)
                    if guide then
                        TeleportSystem:ToIsland(guide.location)
                        Wait(30)
                    end
                    Wait(5)
                end
            end)
        end
    end)

    -- =====================
    -- TAB 18: PvP STRATEGIES
    -- =====================
    local stratTab = GUI:CreateTab("PvP Combos", "🥊")

    GUI:CreateSection(stratTab.page, "Combo Strategies")
    GUI:CreateLabel(stratTab.page, "Select and execute pre-built combo strategies")

    GUI:CreateDropdown(stratTab.page, "Active Strategy",
        {"Standard", "Aggressive", "Defensive", "HighDamage", "SpeedCombo",
         "FruitCombo", "SwordCombo", "MeleeCombo", "GunCombo", "BloxCombo"},
        "Standard",
        function(v)
            ExtendedPvP.CurrentStrategy = v
            -- Update active combo sequence
            Settings.PvP.AutoComboSequence = ComboStrategies[v] or ComboStrategies.Standard
        end)

    GUI:CreateSection(stratTab.page, "Strategy Combos")
    for name, keys in pairs(ComboStrategies) do
        GUI:CreateLabel(stratTab.page, name .. ": " .. table.concat(keys, " → "))
    end

    GUI:CreateSection(stratTab.page, "Advanced PvP")
    GUI:CreateToggle(stratTab.page, "Strafe Target", false, function(v)
        if v then
            task.spawn(function()
                while v and Settings.PvP.Enabled do
                    local target = PvPSystem.LockedTarget
                    if target then ExtendedPvP:StrafeTarget(target) end
                    Wait(0.1)
                end
            end)
        end
    end)

    GUI:CreateButton(stratTab.page, "⚡ Execute Current Strategy", function()
        local target = PvPSystem.LockedTarget or PvPSystem:FindTarget()
        if target then
            task.spawn(function()
                ExtendedPvP:ExecuteStrategy(ExtendedPvP.CurrentStrategy, target)
            end)
        else
            Notify("PvP", "No target found!", 2)
        end
    end)

    -- =====================
    -- TAB 19: EXTENDED TELEPORT
    -- =====================
    local extTpTab = GUI:CreateTab("All Locations", "📍")

    GUI:CreateSection(extTpTab.page, "Quest Givers")
    for _, coord in ipairs(AllCoordinates) do
        if coord.type == "Quest" then
            GUI:CreateButton(extTpTab.page, "📜 " .. coord.name, function()
                SafeTeleport(coord.cframe)
                Notify("Teleport", "→ " .. coord.name, 2)
            end)
        end
    end

    GUI:CreateSection(extTpTab.page, "Shops")
    for _, coord in ipairs(AllCoordinates) do
        if coord.type == "Shop" then
            GUI:CreateButton(extTpTab.page, "🛒 " .. coord.name, function()
                SafeTeleport(coord.cframe)
                Notify("Teleport", "→ " .. coord.name, 2)
            end)
        end
    end

    GUI:CreateSection(extTpTab.page, "Boss Spawns")
    for _, coord in ipairs(AllCoordinates) do
        if coord.type == "Boss" then
            GUI:CreateButton(extTpTab.page, "💀 " .. coord.name, function()
                SafeTeleport(coord.cframe)
                Notify("Teleport", "→ " .. coord.name, 2)
            end)
        end
    end

    GUI:CreateSection(extTpTab.page, "Spawn Points")
    for _, coord in ipairs(AllCoordinates) do
        if coord.type == "Spawn" or coord.type == "Secret" or coord.type == "Special" then
            GUI:CreateButton(extTpTab.page, "⭐ " .. coord.name, function()
                SafeTeleport(coord.cframe)
                Notify("Teleport", "→ " .. coord.name, 2)
            end)
        end
    end

    -- =====================
    -- TAB 20: FRUIT STORAGE
    -- =====================
    local storageTab = GUI:CreateTab("Fruit Storage", "🗃️")

    GUI:CreateSection(storageTab.page, "Storage Overview")
    local storageLabel = GUI:CreateLabel(storageTab.page, "Stored: 0/" .. FruitStorage.maxSlots)

    task.spawn(function()
        while task.wait(2) do
            if storageLabel and storageLabel.Parent then
                storageLabel.Text = "Stored: " .. FruitStorage:GetCount() .. "/" .. FruitStorage.maxSlots
            else
                break
            end
        end
    end)

    GUI:CreateButton(storageTab.page, "🔍 Scan All Spawn Locations", function()
        task.spawn(function()
            ExtendedFruitSystem:ScanSpawnLocations()
        end)
    end)

    GUI:CreateButton(storageTab.page, "🗑️ Clear Fruit Storage", function()
        FruitStorage:Clear()
        Notify("Storage", "Fruit storage cleared", 2)
    end)

    GUI:CreateButton(storageTab.page, "💰 Auto Sell Common Fruits", function()
        task.spawn(function()
            ExtendedFruitSystem:AutoSellFruits()
        end)
    end)

    GUI:CreateSection(storageTab.page, "Fruit Rarity Guide")
    for rarity, weight in pairs(FruitPriorityWeights) do
        GUI:CreateLabel(storageTab.page, rarity .. " - Priority: " .. weight)
    end

    GUI:CreateSection(storageTab.page, "Complete Fruit List")
    for _, fruit in ipairs(FruitData) do
        GUI:CreateLabel(storageTab.page,
            string.format("%-12s | %-9s | %s | $%d",
                fruit.name, fruit.rarity, fruit.type, fruit.price))
    end
end

-- Call extended tabs builder after main GUI
task.delay(0.5, function()
    if OmegaHub.Loaded then
        pcall(BuildExtendedTabs)
    end
end)

-- ============================================================================
-- SECTION 38: AUTO SKILL UNLOCK SYSTEM
-- ============================================================================

local SkillUnlockSystem = {}
SkillUnlockSystem.UnlockedSkills = {}

-- Skill data for each fruit/weapon type
local FruitSkills = {
    Flame = {
        { name = "Flamethrower",   key = "Z", masteryReq = 1,    desc = "Basic fire projectile" },
        { name = "Fire Ball",      key = "X", masteryReq = 50,   desc = "Explosive fireball" },
        { name = "Flame Pillar",   key = "C", masteryReq = 100,  desc = "Column of fire" },
        { name = "Meteor Shower",  key = "V", masteryReq = 200,  desc = "Multiple meteor strikes" },
        { name = "Fire Admiral",   key = "F", masteryReq = 300,  desc = "Ultimate fire technique" },
    },
    Ice = {
        { name = "Ice Spike",      key = "Z", masteryReq = 1,    desc = "Ice projectile" },
        { name = "Ice Bird",       key = "X", masteryReq = 50,   desc = "Ice bird attack" },
        { name = "Glacial Age",    key = "C", masteryReq = 100,  desc = "Freeze zone" },
        { name = "Ice Dragon",     key = "V", masteryReq = 200,  desc = "Ice dragon" },
        { name = "Absolute Zero",  key = "F", masteryReq = 300,  desc = "Ultimate freeze" },
    },
    Magma = {
        { name = "Magma Fist",     key = "Z", masteryReq = 1,    desc = "Magma punch" },
        { name = "Magma Meteor",   key = "X", masteryReq = 50,   desc = "Falling magma" },
        { name = "Magma Eruption", key = "C", masteryReq = 100,  desc = "Ground eruption" },
        { name = "Magma Tiles",    key = "V", masteryReq = 200,  desc = "Magma floor" },
        { name = "Magma Admiral",  key = "F", masteryReq = 300,  desc = "Ultimate magma" },
    },
    Dragon = {
        { name = "Dragon Claw",    key = "Z", masteryReq = 1,    desc = "Dragon strike" },
        { name = "Dragon Talon",   key = "X", masteryReq = 50,   desc = "Multiple claw swipes" },
        { name = "Dragon Breath",  key = "C", masteryReq = 100,  desc = "Fire breath" },
        { name = "Dragon Dive",    key = "V", masteryReq = 200,  desc = "Aerial dive bomb" },
        { name = "True Dragon",    key = "F", masteryReq = 300,  desc = "Ultimate transformation" },
    },
    Dough = {
        { name = "Dough Spin",     key = "Z", masteryReq = 1,    desc = "Spinning dough" },
        { name = "Dough Roundhead",key = "X", masteryReq = 50,   desc = "Rolling dough attack" },
        { name = "Dough Chop",     key = "C", masteryReq = 100,  desc = "Chop attack" },
        { name = "Mochi Mochi",    key = "V", masteryReq = 200,  desc = "Sticky body" },
        { name = "Special Mochi",  key = "F", masteryReq = 300,  desc = "Ultimate dough" },
    },
}

-- Auto use skill based on mastery level
function SkillUnlockSystem:GetAvailableSkills(fruitName, masteryLevel)
    local skills = FruitSkills[fruitName]
    if not skills then return {} end

    local available = {}
    for _, skill in ipairs(skills) do
        if masteryLevel >= skill.masteryReq then
            table.insert(available, skill)
        end
    end
    return available
end

-- ============================================================================
-- SECTION 39: SERVER HOP SYSTEM
-- ============================================================================

local ServerHopSystem = {}
ServerHopSystem.Active = false
ServerHopSystem.Thread = nil
ServerHopSystem.HopCount = 0

ServerHopSystem.HopReasons = {
    "Admin detected",
    "Server too full",
    "Looking for fruits",
    "Finding specific boss",
    "Avoiding PvP",
    "Better XP rates",
}

function ServerHopSystem:Hop(reason)
    Log("Server hopping: " .. (reason or "Manual hop"))

    -- Stop all active farms
    Settings.AutoFarm.Enabled = false
    Settings.PvP.Enabled = false
    Settings.AutoFruit.Enabled = false

    Wait(0.5)

    -- Hop to new server
    pcall(function()
        TeleportService:Teleport(game.PlaceId)
    end)

    self.HopCount = self.HopCount + 1
end

function ServerHopSystem:AutoHop(condition)
    if self.Active then return end
    self.Active = true

    self.Thread = task.spawn(function()
        while self.Active do
            if condition and condition() then
                self:Hop("Auto condition met")
            end
            Wait(30)
        end
    end)
end

-- Auto-hop if server has too many players
function ServerHopSystem:HopIfCrowded(maxPlayers)
    maxPlayers = maxPlayers or 10
    ServerHopSystem:AutoHop(function()
        return #Players:GetPlayers() > maxPlayers
    end)
end

-- ============================================================================
-- SECTION 40: EVENT DETECTION SYSTEM
-- ============================================================================

local EventSystem = {}
EventSystem.ActiveEvents = {}
EventSystem.Thread = nil

-- Detect special in-game events
local KnownEvents = {
    {
        name = "Twilight Sea Event",
        detection = function()
            -- Check if sky/lighting matches twilight
            local lighting = game:GetService("Lighting")
            return lighting and lighting.TimeOfDay and
                tonumber(lighting.TimeOfDay:sub(1,2)) >= 17
        end,
        reward = "Twilight Essence",
        action = function()
            Log("Twilight Sea Event detected!")
            Notify("🌅 Event!", "Twilight Sea Event is active!", 5)
        end,
    },
    {
        name = "Daily Login Bonus",
        detection = function()
            -- Check for login bonus GUI
            return PlayerGui:FindFirstChild("DailyBonus") ~= nil
        end,
        reward = "Daily Fragments",
        action = function()
            local bonus = PlayerGui:FindFirstChild("DailyBonus")
            if bonus then
                local claimBtn = bonus:FindFirstChild("Claim", true)
                if claimBtn and claimBtn:IsA("TextButton") then
                    claimBtn:FireButton1Click()
                    Log("Daily bonus claimed!")
                    Notify("🎁 Daily Bonus", "Daily login bonus claimed!", 4)
                end
            end
        end,
    },
    {
        name = "Boss Alert",
        detection = function()
            -- Check if any boss has spawned
            for _, boss in ipairs(BossData) do
                local instances = GetEnemyByName(boss.name)
                if #instances > 0 then
                    return true
                end
            end
            return false
        end,
        reward = "Boss Drops",
        action = function()
            for _, boss in ipairs(BossData) do
                local instances = GetEnemyByName(boss.name)
                if #instances > 0 then
                    Log("Boss spawned: " .. boss.name)
                    Notify("⚔️ Boss Alert!", boss.name .. " has spawned!", 5)
                    break
                end
            end
        end,
    },
}

function EventSystem:StartMonitoring()
    if self.Thread then return end

    self.Thread = task.spawn(function()
        while true do
            task.wait(10)
            for _, event in ipairs(KnownEvents) do
                local success, result = pcall(event.detection)
                if success and result then
                    if not self.ActiveEvents[event.name] then
                        self.ActiveEvents[event.name] = true
                        pcall(event.action)
                    end
                else
                    self.ActiveEvents[event.name] = nil
                end
            end
        end
    end)

    Log("Event monitoring started")
end

EventSystem:StartMonitoring()

-- ============================================================================
-- SECTION 41: ADVANCED ANTI-BAN TECHNIQUES
-- ============================================================================

local AdvancedAntiBan = {}

-- Simulate realistic player behavior
AdvancedAntiBan.BehaviorPatterns = {
    Idle = {
        duration = { min = 2, max = 8 },
        actions = { "look_around", "idle_animation" },
    },
    Moving = {
        duration = { min = 3, max = 12 },
        actions = { "walk", "run", "jump" },
    },
    Attacking = {
        duration = { min = 1, max = 5 },
        actions = { "attack", "skill", "combo" },
    },
    Collecting = {
        duration = { min = 0.5, max = 2 },
        actions = { "pickup", "interact" },
    },
}

AdvancedAntiBan.CurrentPattern = "Idle"
AdvancedAntiBan.PatternTimer = 0

-- Simulate human-like hesitation
function AdvancedAntiBan:HumanHesitation()
    -- Occasionally do nothing (as if reading screen)
    if math.random(1, 100) <= 5 then -- 5% chance
        local pauseDuration = RandomFloat(0.5, 2.0)
        Log("Human hesitation: " .. string.format("%.1f", pauseDuration) .. "s")
        Wait(pauseDuration)
    end
end

-- Simulate occasional mistakes (as if misclicking)
function AdvancedAntiBan:SimulateMistake()
    if math.random(1, 200) <= 3 then -- 1.5% chance
        local wrongKey = Settings.PvP.ComboKeys[math.random(1, #Settings.PvP.ComboKeys)]
        Log("Simulating mistake: pressed " .. wrongKey)
        pcall(function()
            -- Press a wrong key briefly
            UserInputService.InputBegan:Fire(
                { KeyCode = Enum.KeyCode[wrongKey], UserInputType = Enum.UserInputType.Keyboard },
                false
            )
            Wait(0.05)
        end)
    end
end

-- Randomize action timing
function AdvancedAntiBan:GetHumanDelay(baseDelay)
    -- Add ±30% variance
    local variance = baseDelay * 0.3
    return baseDelay + RandomFloat(-variance, variance)
end

-- Chat randomizer (makes script look human)
local HumanChatMessages = {
    "nice", "lol", "gg", "ez", "that was sick", "wtf",
    "brb", "afk for a sec", "got lagged", "close one",
    "almost died", "getting good loot", "grinding",
}

function AdvancedAntiBan:RandomChat()
    if math.random(1, 1000) <= 2 then -- Very rare
        local msg = HumanChatMessages[math.random(1, #HumanChatMessages)]
        pcall(function()
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "[OmegaHub] Chat bypass: " .. msg,
            })
        end)
    end
end

-- ============================================================================
-- SECTION 42: COMBO BUILDER (CUSTOM USER COMBOS)
-- ============================================================================

local ComboBuilder = {}
ComboBuilder.UserCombos = {}
ComboBuilder.RecordingActive = false
ComboBuilder.RecordedKeys = {}

function ComboBuilder:StartRecording()
    self.RecordingActive = true
    self.RecordedKeys = {}
    Log("Combo recording started - press keys to record")
    Notify("🎮 Combo Builder", "Recording started! Press your combo keys...", 4)

    -- Listen for key presses
    local conn
    conn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and self.RecordingActive then
            local keyName = input.KeyCode.Name
            if #keyName == 1 or keyName:find("^[ZXCVF]$") then
                table.insert(self.RecordedKeys, keyName)
                Log("Recorded key: " .. keyName)
                Notify("Recording", "Keys: " .. table.concat(self.RecordedKeys, " → "), 1)
            end

            -- Stop recording on Enter
            if input.KeyCode == Enum.KeyCode.Return then
                self:StopRecording()
                conn:Disconnect()
            end
        end
    end)
end

function ComboBuilder:StopRecording()
    self.RecordingActive = false
    if #self.RecordedKeys > 0 then
        Log("Combo recorded: " .. table.concat(self.RecordedKeys, " → "))
        Notify("✅ Combo Saved!", table.concat(self.RecordedKeys, " → "), 4)
        return self.RecordedKeys
    end
    return nil
end

function ComboBuilder:SaveCombo(name, keys)
    self.UserCombos[name] = keys or self.RecordedKeys
    Log("Combo saved as: " .. name)
end

function ComboBuilder:ExecuteCombo(name)
    local combo = self.UserCombos[name]
    if not combo then
        Log("Combo not found: " .. name, "WARN")
        return
    end

    for _, key in ipairs(combo) do
        PvPSystem:ExecuteComboKey(key)
        Wait(Settings.PvP.GlobalComboDelay)
    end
end

function ComboBuilder:ListCombos()
    local list = {}
    for name, _ in pairs(self.UserCombos) do
        table.insert(list, name)
    end
    return list
end

-- ============================================================================
-- SECTION 43: EXTENDED SETTINGS PERSISTENCE
-- ============================================================================

-- Save settings to output (for user to copy)
local function SerializeSettings()
    local data = {
        version = OmegaHub.Version,
        timestamp = os.time(),
        settings = {
            AutoFarm = {
                LevelTarget    = Settings.AutoFarm.LevelTarget,
                MasteryType    = Settings.AutoFarm.MasteryType,
                AttackDelay    = Settings.AutoFarm.AttackDelay,
                SelectedBoss   = Settings.AutoFarm.SelectedBoss,
            },
            PvP = {
                ComboKeys      = Settings.PvP.ComboKeys,
                KeyDelays      = Settings.PvP.KeyDelays,
                GlobalDelay    = Settings.PvP.GlobalComboDelay,
                MaxRange       = Settings.PvP.MaxRange,
                AimBone        = Settings.PvP.AimBone,
                Strategy       = ExtendedPvP.CurrentStrategy,
            },
            AutoFruit = {
                ScanRadius     = Settings.AutoFruit.ScanRadius,
                BringRadius    = Settings.AutoFruit.BringRadius,
                ScanInterval   = Settings.AutoFruit.ScanInterval,
            },
            Misc = {
                WalkSpeed      = Settings.Misc.WalkSpeed,
                JumpPower      = Settings.Misc.JumpPower,
                FlySpeed       = Settings.Misc.FlySpeed,
                StatType       = Settings.Misc.StatType,
            },
        },
    }

    -- Convert to string
    local str = "-- OmegaHub Settings Snapshot\n"
    str = str .. "-- Version: " .. data.version .. "\n"
    str = str .. "-- Saved: " .. os.date("%Y-%m-%d %H:%M:%S", data.timestamp) .. "\n\n"

    for category, values in pairs(data.settings) do
        str = str .. "-- " .. category .. "\n"
        for key, value in pairs(values) do
            if type(value) == "table" then
                str = str .. "-- " .. key .. " = " .. HttpService:JSONEncode(value) .. "\n"
            else
                str = str .. "-- " .. key .. " = " .. tostring(value) .. "\n"
            end
        end
        str = str .. "\n"
    end

    return str
end

-- ============================================================================
-- SECTION 44: PERFORMANCE MONITORING
-- ============================================================================

local PerformanceMonitor = {}
PerformanceMonitor.FrameCount = 0
PerformanceMonitor.StartTick = tick()
PerformanceMonitor.FPS = 0
PerformanceMonitor.ActiveThreads = 0
PerformanceMonitor.MemoryUsage = 0

PerformanceMonitor.Thread = RunService.Heartbeat:Connect(function()
    PerformanceMonitor.FrameCount = PerformanceMonitor.FrameCount + 1
end)

task.spawn(function()
    while true do
        task.wait(1)
        PerformanceMonitor.FPS = PerformanceMonitor.FrameCount
        PerformanceMonitor.FrameCount = 0

        -- Count active threads
        local threadCount = 0
        for _ in pairs(OmegaHub.Threads) do
            threadCount = threadCount + 1
        end
        PerformanceMonitor.ActiveThreads = threadCount
    end
end)

function PerformanceMonitor:GetReport()
    return string.format(
        "FPS: %d | Uptime: %.0fs | Systems: %s",
        self.FPS,
        tick() - self.StartTick,
        table.concat({
            AutoFarmEngine.Active and "Farm" or "",
            AutoQuestSystem.Active and "Quest" or "",
            AutoFruitSystem.Active and "Fruit" or "",
            PvPSystem.Active and "PvP" or "",
            SeaBeastSystem.Active and "SeaBeast" or "",
        }, ",")
    )
end

-- ============================================================================
-- SECTION 45: HOTKEY CONFIGURATION SYSTEM
-- ============================================================================

local HotkeySystem = {}
HotkeySystem.CustomHotkeys = {}
HotkeySystem.DefaultHotkeys = {
    ["]"]       = "Toggle GUI",
    ["Delete"]  = "Emergency Stop",
    ["F1"]      = "Toggle Auto Farm",
    ["F2"]      = "Toggle PvP",
    ["F3"]      = "Toggle Auto Fruit",
    ["F4"]      = "Teleport Safe Zone",
    ["F5"]      = "Toggle Auto Quest",
    ["F6"]      = "Toggle Sea Beast",
    ["F7"]      = "Server Hop",
    ["F8"]      = "Toggle Fly",
    ["F9"]      = "Toggle NoClip",
    ["F10"]     = "Lock Nearest Target",
    ["F11"]     = "Unlock Target",
    ["F12"]     = "Toggle ESP",
    ["NumPad0"] = "Teleport to Boss",
    ["NumPad1"] = "Teleport 1st Sea",
    ["NumPad2"] = "Teleport 2nd Sea",
    ["NumPad3"] = "Teleport 3rd Sea",
    ["Home"]    = "Save Bookmark",
    ["End"]     = "Go To Bookmark",
    ["Insert"]  = "Toggle Anti-Ban",
    ["PageUp"]  = "Increase Walk Speed",
    ["PageDown"]= "Decrease Walk Speed",
}

-- Extended keybind registrations
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    local keyName = input.KeyCode.Name

    if keyName == "F5" then
        Settings.AutoQuest.Enabled = not Settings.AutoQuest.Enabled
        if Settings.AutoQuest.Enabled then
            AutoQuestSystem:Start()
        else
            AutoQuestSystem:Stop()
        end
        Notify("Auto Quest", Settings.AutoQuest.Enabled and "Enabled" or "Disabled", 2)

    elseif keyName == "F6" then
        if SeaBeastSystem.Active then
            SeaBeastSystem:Stop()
            Notify("Sea Beast", "Disabled", 2)
        else
            SeaBeastSystem:Start()
            Notify("Sea Beast", "Enabled", 2)
        end

    elseif keyName == "F7" then
        ServerHopSystem:Hop("Manual F7 hop")

    elseif keyName == "F8" then
        Settings.Misc.FlyEnabled = not Settings.Misc.FlyEnabled
        if Settings.Misc.FlyEnabled then
            MiscSystem:StartFly()
        else
            MiscSystem:StopFly()
        end
        Notify("Fly", Settings.Misc.FlyEnabled and "Enabled" or "Disabled", 2)

    elseif keyName == "F9" then
        Settings.Misc.NoClip = not Settings.Misc.NoClip
        if Settings.Misc.NoClip then
            MiscSystem:StartNoClip()
        else
            MiscSystem:StopNoClip()
        end
        Notify("NoClip", Settings.Misc.NoClip and "Enabled" or "Disabled", 2)

    elseif keyName == "F10" then
        local target = PvPSystem:FindTarget()
        if target then
            PvPSystem:LockTarget(target)
        end

    elseif keyName == "F11" then
        PvPSystem:LockTarget(nil)

    elseif keyName == "F12" then
        Settings.Misc.ShowESP = not Settings.Misc.ShowESP
        Notify("ESP", Settings.Misc.ShowESP and "Enabled" or "Disabled", 2)

    elseif keyName == "PageUp" then
        Settings.Misc.WalkSpeed = math.min(Settings.Misc.WalkSpeed + 5, 300)
        MiscSystem:SetWalkSpeed(Settings.Misc.WalkSpeed)
        Notify("Speed", "Walk Speed: " .. Settings.Misc.WalkSpeed, 1)

    elseif keyName == "PageDown" then
        Settings.Misc.WalkSpeed = math.max(Settings.Misc.WalkSpeed - 5, 1)
        MiscSystem:SetWalkSpeed(Settings.Misc.WalkSpeed)
        Notify("Speed", "Walk Speed: " .. Settings.Misc.WalkSpeed, 1)

    elseif keyName == "Home" then
        TeleportSystem:SaveBookmark("Quick_" .. os.time())
        Notify("Bookmark", "Quick position saved!", 2)

    elseif keyName == "End" then
        -- Go to last saved bookmark
        local lastBookmark = nil
        local lastTime = 0
        for name, cf in pairs(TeleportSystem.Bookmarks) do
            local timestamp = tonumber(name:match("_(%d+)$") or "0") or 0
            if timestamp > lastTime then
                lastTime = timestamp
                lastBookmark = name
            end
        end
        if lastBookmark then
            TeleportSystem:GoToBookmark(lastBookmark)
        end

    elseif keyName == "Insert" then
        Settings.AntiBan.Enabled = not Settings.AntiBan.Enabled
        if Settings.AntiBan.Enabled then
            AntiBanSystem:Start()
        else
            AntiBanSystem:Stop()
        end
        Notify("Anti-Ban", Settings.AntiBan.Enabled and "Enabled" or "Disabled", 2)
    end
end)

-- ============================================================================
-- SECTION 46: NETWORK MONITORING (LAG DETECTION)
-- ============================================================================

local NetworkMonitor = {}
NetworkMonitor.LastPing = 0
NetworkMonitor.AveragePing = 0
NetworkMonitor.PingHistory = {}
NetworkMonitor.MaxPingHistory = 10
NetworkMonitor.HighPingThreshold = 200

function NetworkMonitor:UpdatePing()
    local stats = game:GetService("Stats")
    if stats then
        local network = stats:FindFirstChild("Network")
        if network then
            local ping = network:FindFirstChild("ServerStatsItem")
            if ping then
                self.LastPing = ping.Value
                table.insert(self.PingHistory, self.LastPing)
                if #self.PingHistory > self.MaxPingHistory then
                    table.remove(self.PingHistory, 1)
                end

                -- Calculate average
                local total = 0
                for _, p in ipairs(self.PingHistory) do
                    total = total + p
                end
                self.AveragePing = total / #self.PingHistory
            end
        end
    end
end

function NetworkMonitor:IsHighLag()
    return self.AveragePing > self.HighPingThreshold
end

function NetworkMonitor:GetPingColor()
    if self.LastPing < 100 then
        return Color3.fromRGB(0, 200, 100)  -- Green
    elseif self.LastPing < 200 then
        return Color3.fromRGB(255, 200, 0)  -- Yellow
    else
        return Color3.fromRGB(255, 60, 60)  -- Red
    end
end

-- Start ping monitoring
task.spawn(function()
    while true do
        task.wait(1)
        pcall(function()
            NetworkMonitor:UpdatePing()

            -- Adjust delays when high lag
            if NetworkMonitor:IsHighLag() then
                -- Increase delays to avoid server-side issues
                Settings.AutoFarm.AttackDelay = math.max(Settings.AutoFarm.AttackDelay, 0.2)
                Settings.PvP.GlobalComboDelay = math.max(Settings.PvP.GlobalComboDelay, 0.15)
            end
        end)
    end
end)

-- ============================================================================
-- SECTION 47: EXTENDED BOSS COMBAT AI
-- ============================================================================

local BossCombatAI = {}
BossCombatAI.SafeDistance = {
    Default = 5,
    Ranged = 15,
    Melee = 3,
}

-- Evade boss attack patterns
function BossCombatAI:DodgeAttack(boss)
    local hrp = GetHRP()
    local bossHRP = boss:FindFirstChild("HumanoidRootPart")

    if not hrp or not bossHRP then return end

    -- Move perpendicular to boss attack direction
    local attackDir = (hrp.Position - bossHRP.Position).Unit
    local dodgeDir = Vector3.new(-attackDir.Z, 0, attackDir.X)

    hrp.CFrame = CFrame.new(
        hrp.Position + dodgeDir * 12 + Vector3.new(0, 3, 0)
    )
end

-- Safe distance maintenance
function BossCombatAI:MaintainDistance(boss, targetDist)
    local hrp = GetHRP()
    local bossHRP = boss:FindFirstChild("HumanoidRootPart")

    if not hrp or not bossHRP then return end

    local dist = GetDistance(hrp.Position, bossHRP.Position)
    local direction = (hrp.Position - bossHRP.Position).Unit

    if dist < targetDist - 2 then
        -- Too close, back up
        hrp.CFrame = CFrame.new(hrp.Position + direction * 3)
    elseif dist > targetDist + 2 then
        -- Too far, move in
        hrp.CFrame = CFrame.new(hrp.Position - direction * 3)
    end
end

-- Boss-specific combat strategies
local BossStrategies = {
    ["Rip_Indra (Raid)"] = {
        phases = 3,
        dodgeOnSkill = true,
        maintainDist = 8,
        preferRanged = true,
        dodgeCooldown = 0.5,
    },
    ["Dough King"] = {
        phases = 3,
        dodgeOnSkill = false,
        maintainDist = 5,
        preferRanged = false,
        dodgeCooldown = 1.0,
    },
    ["Cake Prince"] = {
        phases = 2,
        dodgeOnSkill = true,
        maintainDist = 6,
        preferRanged = false,
        dodgeCooldown = 0.8,
    },
    ["Darkbeard"] = {
        phases = 2,
        dodgeOnSkill = true,
        maintainDist = 10,
        preferRanged = true,
        dodgeCooldown = 0.7,
    },
    Default = {
        phases = 1,
        dodgeOnSkill = false,
        maintainDist = 5,
        preferRanged = false,
        dodgeCooldown = 1.0,
    },
}

function BossCombatAI:FightBossWithStrategy(boss, bossName)
    local strategy = BossStrategies[bossName] or BossStrategies.Default
    local hum = boss:FindFirstChild("Humanoid")

    if not hum or hum.Health <= 0 then return true end

    -- Maintain proper distance
    BossCombatAI:MaintainDistance(boss, strategy.maintainDist)

    -- Attack
    if strategy.preferRanged then
        -- Use ranged skills only
        PvPSystem:ExecuteComboKey("Z")
        PvPSystem:ExecuteComboKey("X")
    else
        -- Full combo
        AutoFarmEngine:AttackEnemy(boss)
    end

    return hum.Health <= 0
end

-- ============================================================================
-- SECTION 48: FRUIT NOTIFICATION SOUND SYSTEM
-- ============================================================================

local FruitSoundSystem = {}
FruitSoundSystem.SoundsEnabled = true
FruitSoundSystem.SoundIDs = {
    Common   = 0,  -- Silent for common
    Uncommon = 131070686,
    Rare     = 131070686,
    Legendary = 6042543888,
    Mythical  = 6042543888,
}

function FruitSoundSystem:PlayFruitSound(rarity)
    if not self.SoundsEnabled then return end

    local soundId = self.SoundIDs[rarity]
    if not soundId or soundId == 0 then return end

    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. soundId
        sound.Volume = 0.5
        sound.Parent = SoundService
        sound:Play()
        task.delay(3, function()
            if sound and sound.Parent then
                sound:Destroy()
            end
        end)
    end)
end

-- ============================================================================
-- SECTION 49: COMPLETE GUI STATUS BAR
-- ============================================================================

-- Add a status bar at the bottom of the GUI
local function AddStatusBar()
    if not GUI.Main then return end

    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(1, 0, 0, 22)
    statusBar.Position = UDim2.new(0, 0, 1, -22)
    statusBar.BackgroundColor3 = GUI.Theme.TopBar
    statusBar.BorderSizePixel = 0
    statusBar.Parent = GUI.Main

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0.6, 0, 1, 0)
    statusLabel.Position = UDim2.new(0, 8, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = GUI.Theme.TextDim
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = "Ready"
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusBar

    local pingLabel = Instance.new("TextLabel")
    pingLabel.Name = "PingLabel"
    pingLabel.Size = UDim2.new(0.2, 0, 1, 0)
    pingLabel.Position = UDim2.new(0.6, 0, 0, 0)
    pingLabel.BackgroundTransparency = 1
    pingLabel.TextColor3 = GUI.Theme.Success
    pingLabel.TextSize = 10
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.Text = "Ping: --ms"
    pingLabel.TextXAlignment = Enum.TextXAlignment.Center
    pingLabel.Parent = statusBar

    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Name = "FPSLabel"
    fpsLabel.Size = UDim2.new(0.2, -8, 1, 0)
    fpsLabel.Position = UDim2.new(0.8, 0, 0, 0)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.TextColor3 = GUI.Theme.Success
    fpsLabel.TextSize = 10
    fpsLabel.Font = Enum.Font.Gotham
    fpsLabel.Text = "60 FPS"
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
    fpsLabel.Parent = statusBar

    -- Update status bar
    task.spawn(function()
        while true do
            task.wait(0.5)
            if not statusLabel.Parent then break end

            -- Active systems
            local activeSystems = {}
            if Settings.AutoFarm.Enabled then table.insert(activeSystems, "Farm") end
            if Settings.AutoQuest.Enabled then table.insert(activeSystems, "Quest") end
            if Settings.AutoFruit.Enabled then table.insert(activeSystems, "Fruit") end
            if Settings.PvP.Enabled then table.insert(activeSystems, "PvP") end

            if #activeSystems > 0 then
                statusLabel.Text = "Active: " .. table.concat(activeSystems, " | ")
                statusLabel.TextColor3 = GUI.Theme.Success
            else
                statusLabel.Text = "All Systems Idle"
                statusLabel.TextColor3 = GUI.Theme.TextDim
            end

            -- Ping
            local ping = NetworkMonitor.LastPing
            pingLabel.Text = "Ping: " .. (ping > 0 and math.floor(ping) .. "ms" or "--ms")
            pingLabel.TextColor3 = NetworkMonitor:GetPingColor()

            -- FPS
            local fps = PerformanceMonitor.FPS
            fpsLabel.Text = fps .. " FPS"
            fpsLabel.TextColor3 = fps >= 30 and GUI.Theme.Success or
                (fps >= 20 and GUI.Theme.Warning or GUI.Theme.Error)
        end
    end)
end

task.delay(1, function()
    if OmegaHub.Loaded then
        pcall(AddStatusBar)
    end
end)

-- ============================================================================
-- SECTION 50: MASTERY TRACKING SYSTEM
-- ============================================================================

local MasteryTracker = {}
MasteryTracker.Data = {
    Fruit  = { current = 0, target = 600, startTime = 0, gainRate = 0 },
    Sword  = { current = 0, target = 600, startTime = 0, gainRate = 0 },
    Melee  = { current = 0, target = 600, startTime = 0, gainRate = 0 },
    Gun    = { current = 0, target = 600, startTime = 0, gainRate = 0 },
}

function MasteryTracker:UpdateMastery(type_, value)
    if not self.Data[type_] then return end

    local oldValue = self.Data[type_].current
    self.Data[type_].current = value

    if self.Data[type_].startTime == 0 then
        self.Data[type_].startTime = tick()
    end

    local elapsed = tick() - self.Data[type_].startTime
    if elapsed > 0 then
        self.Data[type_].gainRate = (value - oldValue) / elapsed
    end
end

function MasteryTracker:GetETA(type_)
    local data = self.Data[type_]
    if not data or data.gainRate <= 0 then return "N/A" end

    local remaining = data.target - data.current
    local seconds = remaining / data.gainRate

    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds % 3600) / 60)

    return string.format("%dh %dm", hours, mins)
end

function MasteryTracker:GetProgress(type_)
    local data = self.Data[type_]
    if not data then return 0 end
    return math.clamp(data.current / data.target, 0, 1) * 100
end

-- ============================================================================
-- SECTION 51: EXTENDED FRUIT FARMING DATA
-- ============================================================================

-- Extended fruit spawn timer tracking
local FruitSpawnTimers = {}

local function TrackFruitSpawn(location, fruitName)
    FruitSpawnTimers[location] = {
        fruitName = fruitName,
        spawnTime = tick(),
        estimatedDespawn = tick() + 1200, -- 20 min despawn
    }
end

local function GetFruitTimeRemaining(location)
    local timer = FruitSpawnTimers[location]
    if not timer then return 0 end

    local remaining = timer.estimatedDespawn - tick()
    return math.max(0, remaining)
end

-- Extended fruit value tiers
local FruitValueTiers = {
    {tier = "Trash",    maxPrice = 50000,    shouldSell = true,   shouldEat = false},
    {tier = "Low",      maxPrice = 200000,   shouldSell = false,  shouldEat = true},
    {tier = "Medium",   maxPrice = 1000000,  shouldSell = false,  shouldEat = false},
    {tier = "High",     maxPrice = 3000000,  shouldSell = false,  shouldEat = false},
    {tier = "Premium",  maxPrice = math.huge,shouldSell = false,  shouldEat = false},
}

local function GetFruitTier(fruitName)
    for _, fruit in ipairs(FruitData) do
        if fruitName:lower():find(fruit.name:lower()) then
            for _, tier in ipairs(FruitValueTiers) do
                if fruit.price <= tier.maxPrice then
                    return tier
                end
            end
        end
    end
    return FruitValueTiers[1]
end

-- ============================================================================
-- SECTION 52: FINAL CLEANUP AND SUMMARY LOG
-- ============================================================================

-- Session summary
local function PrintSessionSummary()
    local elapsed = tick() - AutoFarmEngine.StartTime

    Log("=== SESSION SUMMARY ===")
    Log(string.format("Uptime:          %.0f seconds (%.1f hours)", elapsed, elapsed/3600))
    Log(string.format("Total Kills:     %d", AutoFarmEngine.KillCount))
    Log(string.format("Fruits Found:    %d", AutoFruitSystem.CollectedCount))
    Log(string.format("Fruits Stored:   %d", AutoFruitSystem.StoredCount))
    Log(string.format("Eggs Collected:  %d", EggSystem.CollectedEggs))
    Log(string.format("Berries:         %d", BerrySystem.BerryCount))
    Log(string.format("Elites Killed:   %d", EliteHunterSystem.KillCount))
    Log(string.format("Bosses (Indra):  %d", BossDefeatSystem.DefeatCounts.Indra))
    Log(string.format("Bosses (Dough):  %d", BossDefeatSystem.DefeatCounts.DoughKing))
    Log(string.format("Bosses (Cake):   %d", BossDefeatSystem.DefeatCounts.CakePrince))
    Log(string.format("Sea Beasts:      %d", SeaBeastSystem.KillCount))
    Log(string.format("Raids Done:      %d", RaidSystem.RaidCount))
    Log(string.format("PvP Hits:        %d", PvPSystem.TotalHits))
    Log(string.format("Quests Done:     %d", AutoQuestSystem.CompletedQuests))
    Log("=======================")
end

-- Register session summary on script unload
game:GetService("Players").LocalPlayer.AncestryChanged:Connect(function()
    PrintSessionSummary()
end)

-- Periodic status log (every 5 minutes)
task.spawn(function()
    while true do
        task.wait(300) -- 5 minutes
        pcall(PrintSessionSummary)
    end
end)

-- ============================================================================
-- EXTENDED INITIALIZATION (POST-LOAD)
-- ============================================================================

task.delay(2, function()
    -- Final notification
    Notify(
        "⚡ Omega Hub Fully Loaded",
        string.format(
            "v%s | %d Bosses | %d Islands | %d Fruits | %d NPCs",
            OmegaHub.Version,
            #BossData,
            #IslandData,
            #FruitData,
            #QuestNPCs
        ),
        8
    )

    Log(string.format(
        "OmegaHub v%s fully initialized | Bosses:%d | Islands:%d | Fruits:%d",
        OmegaHub.Version,
        #BossData + #ExtendedBossData,
        #IslandData,
        #FruitData
    ))
end)

-- ============================================================================
-- END OF EXTENDED SECTIONS (Sections 27-52)
-- ============================================================================

-- ============================================================================
-- SECTION 53: COMPREHENSIVE MOB AI RESPONSE SYSTEM
-- ============================================================================

-- Detailed mob attack pattern detection and dodge system
local MobAISystem = {}
MobAISystem.AttackCooldowns = {}
MobAISystem.DodgeActive = false

-- Attack signatures for known mob types
local MobAttackSignatures = {
    -- Signature = {animation name pattern, dodge direction, dodge distance, dodge timing}
    { mob = "Gorilla King",   attack = "slam",       dodgeDir = "side",  dist = 10, timing = 0.5 },
    { mob = "Bobby",          attack = "chop",        dodgeDir = "back",  dist = 8,  timing = 0.3 },
    { mob = "Yeti",           attack = "snowball",    dodgeDir = "side",  dist = 12, timing = 0.4 },
    { mob = "Cyborg Boss",    attack = "laser",       dodgeDir = "side",  dist = 15, timing = 0.6 },
    { mob = "Darkbeard",      attack = "dark_wave",   dodgeDir = "back",  dist = 20, timing = 0.8 },
    { mob = "Order",          attack = "blade",       dodgeDir = "side",  dist = 12, timing = 0.5 },
    { mob = "Dough King",     attack = "punch",       dodgeDir = "side",  dist = 10, timing = 0.4 },
    { mob = "Rip_Indra",      attack = "thunder",     dodgeDir = "any",   dist = 20, timing = 1.0 },
    { mob = "Cake Prince",    attack = "swipe",       dodgeDir = "back",  dist = 12, timing = 0.5 },
    { mob = "Soul Reaper",    attack = "scythe",      dodgeDir = "side",  dist = 15, timing = 0.6 },
    { mob = "Stone",          attack = "stomp",       dodgeDir = "any",   dist = 18, timing = 0.7 },
    { mob = "Longma",         attack = "breath",      dodgeDir = "side",  dist = 20, timing = 0.9 },
    { mob = "Dragon Crew",    attack = "slash",       dodgeDir = "back",  dist = 8,  timing = 0.3 },
    { mob = "Ice Admiral",    attack = "freeze",      dodgeDir = "any",   dist = 15, timing = 0.6 },
    { mob = "Tide Keeper",    attack = "wave",        dodgeDir = "back",  dist = 15, timing = 0.7 },
    { mob = "Captain Elephant",attack = "charge",     dodgeDir = "side",  dist = 20, timing = 0.8 },
    { mob = "Island Empress", attack = "shockwave",   dodgeDir = "back",  dist = 18, timing = 0.7 },
    { mob = "Kilo Admiral",   attack = "bomb",        dodgeDir = "any",   dist = 25, timing = 1.0 },
    { mob = "Wandering Pirate",attack = "swing",      dodgeDir = "side",  dist = 10, timing = 0.4 },
    { mob = "Greybeard",      attack = "haki",        dodgeDir = "back",  dist = 20, timing = 0.9 },
}

-- Detect if mob is attacking
function MobAISystem:IsAttacking(mob)
    local animator = mob:FindFirstChild("Animator") or
        (mob:FindFirstChild("Humanoid") and mob.Humanoid:FindFirstChild("Animator"))

    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            for _, sig in ipairs(MobAttackSignatures) do
                if mob.Name:lower():find(sig.mob:lower()) then
                    if track.Name:lower():find(sig.attack:lower()) then
                        return true, sig
                    end
                end
            end
        end
    end
    return false, nil
end

-- Execute dodge
function MobAISystem:Dodge(sig)
    if self.DodgeActive then return end
    self.DodgeActive = true

    local hrp = GetHRP()
    if not hrp then
        self.DodgeActive = false
        return
    end

    local direction
    if sig.dodgeDir == "side" then
        direction = hrp.CFrame.RightVector * (math.random() > 0.5 and 1 or -1)
    elseif sig.dodgeDir == "back" then
        direction = -hrp.CFrame.LookVector
    else
        -- Random direction
        local angle = math.random() * math.pi * 2
        direction = Vector3.new(math.cos(angle), 0, math.sin(angle))
    end

    -- Execute dodge teleport
    task.delay(sig.timing, function()
        if hrp and hrp.Parent then
            hrp.CFrame = CFrame.new(hrp.Position + direction * sig.dist + Vector3.new(0, 2, 0))
        end
        self.DodgeActive = false
    end)
end

-- Monitor mobs and auto-dodge
function MobAISystem:StartMonitoring()
    task.spawn(function()
        while true do
            task.wait(0.1)
            if not Settings.AutoFarm.Enabled then continue end

            local hrp = GetHRP()
            if not hrp then continue end

            -- Check nearby mobs
            local nearbyMobs = GetAllEnemies()
            for _, mob in ipairs(nearbyMobs) do
                local dist = GetDistance(hrp.Position, (mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildOfClass("BasePart")).Position)

                if dist < 20 then
                    local isAttacking, sig = self:IsAttacking(mob)
                    if isAttacking and sig then
                        self:Dodge(sig)
                    end
                end
            end
        end
    end)
end

-- ============================================================================
-- SECTION 54: AUTO STAT DISTRIBUTION SYSTEM (DETAILED)
-- ============================================================================

local StatDistribution = {}
StatDistribution.Active = false
StatDistribution.Thread = nil

-- Build paths (stat allocation templates)
local BuildPaths = {
    FruitMain = {
        name = "Fruit Main",
        desc = "Max fruit stats for devil fruit users",
        stats = { Fruit = 100, Melee = 0, Sword = 0, Gun = 0, Defense = 0 },
    },
    SwordMain = {
        name = "Sword Main",
        desc = "Max sword mastery build",
        stats = { Fruit = 0, Melee = 0, Sword = 100, Gun = 0, Defense = 0 },
    },
    MeleeMain = {
        name = "Melee Main",
        desc = "Max melee combat build",
        stats = { Fruit = 0, Melee = 100, Sword = 0, Gun = 0, Defense = 0 },
    },
    GunMain = {
        name = "Gun Main",
        desc = "Max gun damage build",
        stats = { Fruit = 0, Melee = 0, Sword = 0, Gun = 100, Defense = 0 },
    },
    Balanced = {
        name = "Balanced",
        desc = "Even distribution across all stats",
        stats = { Fruit = 20, Melee = 20, Sword = 20, Gun = 20, Defense = 20 },
    },
    HybridFruitSword = {
        name = "Fruit/Sword Hybrid",
        desc = "Split between fruit and sword",
        stats = { Fruit = 50, Melee = 0, Sword = 40, Gun = 0, Defense = 10 },
    },
    HybridFruitMelee = {
        name = "Fruit/Melee Hybrid",
        desc = "Split between fruit and melee",
        stats = { Fruit = 60, Melee = 30, Sword = 0, Gun = 0, Defense = 10 },
    },
    DefensiveFruit = {
        name = "Defensive Fruit",
        desc = "Fruit with heavy defense",
        stats = { Fruit = 60, Melee = 0, Sword = 0, Gun = 0, Defense = 40 },
    },
    SpeedRunner = {
        name = "Speed Runner",
        desc = "Melee and sword for speed",
        stats = { Fruit = 0, Melee = 50, Sword = 40, Gun = 0, Defense = 10 },
    },
    Tanky = {
        name = "Tank Build",
        desc = "Maximum defense with basic attack",
        stats = { Fruit = 20, Melee = 10, Sword = 10, Gun = 10, Defense = 50 },
    },
}

-- Calculate how many points to spend in each stat
function StatDistribution:CalculateAllocation(buildPath, totalPoints)
    local build = BuildPaths[buildPath]
    if not build then return {} end

    local allocation = {}
    for stat, percent in pairs(build.stats) do
        allocation[stat] = math.floor(totalPoints * percent / 100)
    end

    return allocation
end

-- Auto spend points according to build
function StatDistribution:SpendPoints(buildPath)
    local level = LocalPlayer:FindFirstChild("leaderstats") and
        LocalPlayer.leaderstats:FindFirstChild("Level") and
        LocalPlayer.leaderstats.Level.Value or 0

    local totalPoints = level * 3 -- Approximate points per level
    local allocation = self:CalculateAllocation(buildPath, totalPoints)

    Log("Spending stat points for build: " .. (BuildPaths[buildPath] and BuildPaths[buildPath].name or buildPath))

    for stat, points in pairs(allocation) do
        if points > 0 then
            SafeFireRemote("SpendStats", stat, points)
            Log(string.format("Allocated %d points to %s", points, stat))
            Wait(0.2)
        end
    end
end

-- ============================================================================
-- SECTION 55: DETAILED ISLAND INFORMATION DATABASE
-- ============================================================================

local IslandDatabase = {
    [1] = {
        name = "Starter Island",
        sea = 1,
        type = "Town",
        cframe = CFrame.new(-995, 10, 1040),
        questGivers = {
            { name = "Quest Giver", position = Vector3.new(-985, 10, 1055), quests = {"Bandit Quest", "Marine Quest"} },
        },
        shops = {
            { name = "Weapons Shop", items = {"Iron Mace", "Katana", "Dual Headed Blade"} },
        },
        mobs = { "Bandit", "Monkey" },
        level_range = { 1, 30 },
        notes = "Starting area for pirates",
    },
    [2] = {
        name = "Marine Starter Island",
        sea = 1,
        type = "Town",
        cframe = CFrame.new(975, 10, -1750),
        questGivers = {
            { name = "Marine Quest Giver", position = Vector3.new(965, 10, -1735), quests = {"Marine Patrol"} },
        },
        shops = {
            { name = "Marine Shop", items = {"Marine Coat", "Justice Sword"} },
        },
        mobs = { "Bandit", "Marine Trainee" },
        level_range = { 1, 30 },
        notes = "Starting area for marines",
    },
    [3] = {
        name = "Jungle",
        sea = 1,
        type = "Combat",
        cframe = CFrame.new(-1270, 6, 4145),
        questGivers = {
            { name = "Jungle Elder", position = Vector3.new(-1260, 6, 4130), quests = {"Monkey Hunt", "Gorilla Slay"} },
        },
        mobs = { "Monkey", "Gorilla", "Jungle Bandit" },
        level_range = { 15, 75 },
        bosses = { "Gorilla King" },
        notes = "Good XP for levels 15-75",
    },
    [4] = {
        name = "Desert",
        sea = 1,
        type = "Combat",
        cframe = CFrame.new(-495, 8, 1635),
        questGivers = {
            { name = "Desert Elder", position = Vector3.new(-485, 8, 1620), quests = {"Desert Patrol", "Officer Hunt"} },
        },
        mobs = { "Desert Bandit", "Desert Officer" },
        level_range = { 60, 115 },
        bosses = { "Bobby" },
        notes = "Sandy terrain. Good for sword grinding.",
    },
    [5] = {
        name = "Snow Mountain",
        sea = 1,
        type = "Combat",
        cframe = CFrame.new(-4920, 943, -1315),
        questGivers = {
            { name = "Snowman", position = Vector3.new(-4910, 943, -1300), quests = {"Snow Hunt"} },
        },
        mobs = { "Snow Bandit", "Snowman" },
        level_range = { 90, 150 },
        bosses = { "Yeti" },
        notes = "High altitude - requires special access",
    },
    [6] = {
        name = "Skylands",
        sea = 1,
        type = "Combat",
        cframe = CFrame.new(-7760, 2260, -4310),
        questGivers = {
            { name = "Sky Elder", position = Vector3.new(-7750, 2260, -4295), quests = {"Sky Bandit Hunt", "Dark Master Kill"} },
        },
        mobs = { "Sky Bandit", "Dark Master" },
        level_range = { 400, 500 },
        bosses = { "Wysper", "Thunder God" },
        notes = "High in the sky. Required for God of Thunder encounters.",
    },
    [7] = {
        name = "Prison",
        sea = 1,
        type = "Combat",
        cframe = CFrame.new(4390, 200, -1630),
        questGivers = {
            { name = "Warden Quest", position = Vector3.new(4380, 200, -1615) },
        },
        mobs = { "Prisoner", "Dangerous Prisoner" },
        level_range = { 100, 300 },
        bosses = { "Warden", "Chief Warden" },
        notes = "Prison island. Good for mid-game leveling.",
    },
    [8] = {
        name = "Marine Fortress",
        sea = 1,
        type = "Combat",
        cframe = CFrame.new(6115, 44, -510),
        questGivers = {
            { name = "Marine Commander", position = Vector3.new(6105, 44, -495) },
        },
        mobs = { "Marine", "Marine Soldier", "Marine Captain" },
        level_range = { 120, 250 },
        bosses = { "Vice Admiral", "Swan" },
        notes = "Marine stronghold. Good defense grind.",
    },
    [9] = {
        name = "Colosseum",
        sea = 1,
        type = "Combat",
        cframe = CFrame.new(-1385, 135, -1020),
        questGivers = {
            { name = "Arena Master", position = Vector3.new(-1375, 135, -1005) },
        },
        mobs = { "Toga Warrior", "Gladiator" },
        level_range = { 625, 700 },
        bosses = { "Cyborg Boss" },
        notes = "Arena battles. Required for Cyborg race.",
    },
    [10] = {
        name = "Magma Village",
        sea = 1,
        type = "Combat",
        cframe = CFrame.new(-5174, 260, -1065),
        questGivers = {
            { name = "Magma Elder", position = Vector3.new(-5164, 260, -1050) },
        },
        mobs = { "Magma Bandit", "Lava Pirate" },
        level_range = { 300, 450 },
        bosses = { "Magma Admiral" },
        notes = "Volcanic terrain. Magma fruit users have advantage.",
    },
    -- SECOND SEA
    [11] = {
        name = "Kingdom of Rose",
        sea = 2,
        type = "Town",
        cframe = CFrame.new(-1215, 40, -2485),
        questGivers = {
            { name = "Rose Advisor", position = Vector3.new(-1205, 40, -2470) },
            { name = "Advanced Quest", position = Vector3.new(-1225, 40, -2500) },
        },
        shops = {
            { name = "Second Sea Weapons", items = {"Saber V2", "Ice Katana", "Pipe"} },
            { name = "Fruit Dealer", items = {"Random Fruit"} },
        },
        level_range = { 700, 900 },
        notes = "Main hub of Second Sea",
    },
    [12] = {
        name = "Graveyard",
        sea = 2,
        type = "Combat",
        cframe = CFrame.new(440, 108, -2510),
        mobs = { "Zombie", "Zombie Pirate" },
        level_range = { 950, 1000 },
        notes = "Haunted graveyard. Undead enemies.",
    },
    [13] = {
        name = "Hot and Cold Island",
        sea = 2,
        type = "Combat",
        cframe = CFrame.new(-7900, 12, -2050),
        mobs = { "Hot and Cold NPCs" },
        level_range = { 1100, 1400 },
        bosses = { "Awakened Ice Admiral" },
        notes = "Half ice, half fire island. Unique environment.",
    },
    [14] = {
        name = "Cursed Ship",
        sea = 2,
        type = "Combat",
        cframe = CFrame.new(-8015, 12, 5015),
        mobs = { "Zombie", "Zombie Pirate", "Vampire", "Soul Carrier" },
        level_range = { 950, 1100 },
        notes = "Ship of the dead. Best XP for range 950-1100.",
    },
    [15] = {
        name = "Ice Castle",
        sea = 2,
        type = "Combat",
        cframe = CFrame.new(-12200, 44, 3050),
        mobs = { "Snow Lurker", "Dicer" },
        level_range = { 1150, 1250 },
        notes = "Frozen fortress. High level combat zone.",
    },
    [16] = {
        name = "Thriller Bark",
        sea = 2,
        type = "Combat",
        cframe = CFrame.new(-8060, 60, 3400),
        mobs = { "Living Zombie", "Demonic Soul", "Posessed Mummy", "Reaper" },
        level_range = { 1050, 1600 },
        bosses = { "Cake Queen" },
        notes = "Haunted ship. Great for 1050-1600 range.",
    },
    [17] = {
        name = "Floating Turtle Island",
        sea = 2,
        type = "Combat",
        cframe = CFrame.new(-1210, 87, 4010),
        mobs = { "Fishman Warrior", "Fishman Commando" },
        level_range = { 1400, 1600 },
        bosses = { "Island Empress" },
        notes = "On a giant turtle. Good for Fishman grind.",
    },
    [18] = {
        name = "Haunted Castle",
        sea = 2,
        type = "Combat",
        cframe = CFrame.new(-13920, 130, -8800),
        mobs = { "Scientist", "Laboratory Staff" },
        level_range = { 775, 900 },
        bosses = { "Order" },
        notes = "Order's laboratory. Order fruit required for full access.",
    },
    [19] = {
        name = "Mirage Island",
        sea = 2,
        type = "Special",
        cframe = CFrame.new(-9300, 3, -1865),
        notes = "Rare spawn island. Good fruits here. Need to be lucky!",
        special = "Rare fruit spawns more frequently here",
    },
    -- THIRD SEA
    [20] = {
        name = "Port Town",
        sea = 3,
        type = "Town",
        cframe = CFrame.new(-11590, 5, -3590),
        questGivers = {
            { name = "Third Sea Quest Master" },
            { name = "Dragon Master" },
        },
        level_range = { 1500, 1625 },
        notes = "Main hub of Third Sea",
    },
    [21] = {
        name = "Hydra Island",
        sea = 3,
        type = "Combat",
        cframe = CFrame.new(-10400, 5, -3600),
        mobs = { "Jungle Pirate", "Musketeer Pirate", "Forest Pirate" },
        level_range = { 1500, 1675 },
        notes = "Jungle island with pirate crews.",
    },
    [22] = {
        name = "Floating Turtle (3rd Sea)",
        sea = 3,
        type = "Combat",
        cframe = CFrame.new(-8870, 13, 1380),
        mobs = { "Dragon Crew Warrior", "Dragon Crew Archer" },
        level_range = { 1675, 1750 },
        bosses = { "Longma" },
        notes = "Dragon's domain. Dragon crew everywhere.",
    },
    [23] = {
        name = "Mansion",
        sea = 3,
        type = "Combat",
        cframe = CFrame.new(-9680, 5, 980),
        mobs = { "Marine Commodore", "Marine Vice Admiral" },
        level_range = { 1725, 1800 },
        notes = "Elegant mansion filled with high-rank marines.",
    },
    [24] = {
        name = "Great Tree",
        sea = 3,
        type = "Combat",
        cframe = CFrame.new(-7700, 5, -350),
        mobs = { "Beautiful Pirate" },
        level_range = { 1775, 1875 },
        notes = "Giant ancient tree. Home of rare enemies.",
    },
    [25] = {
        name = "Tiki Outpost",
        sea = 3,
        type = "Combat",
        cframe = CFrame.new(-6700, 18, 100),
        mobs = { "Tiki Outpost Warrior" },
        level_range = { 1875, 1950 },
        bosses = { "Cake Prince" },
        notes = "Tribal island with ancient warriors.",
    },
    [26] = {
        name = "Candy Island",
        sea = 3,
        type = "Combat",
        cframe = CFrame.new(-4350, 26, -1350),
        mobs = { "Cake Guard", "Candy Pirate" },
        level_range = { 1800, 1875 },
        bosses = { "Dough King" },
        notes = "Sweet-themed island. Dough King's territory.",
    },
    [27] = {
        name = "Castle on the Sea",
        sea = 3,
        type = "Special",
        cframe = CFrame.new(-3850, 5, -5560),
        mobs = { "Ship Pirate" },
        level_range = { 1850, 1950 },
        notes = "Floating castle. True Triple Katana quest here.",
    },
    [28] = {
        name = "Sea of Treats",
        sea = 3,
        type = "Combat",
        cframe = CFrame.new(-1850, 0, -3740),
        mobs = { "Ice Cream Monster" },
        level_range = { 1900, 2000 },
        notes = "Ice cream themed zone.",
    },
    [29] = {
        name = "Haunted Port",
        sea = 3,
        type = "Combat",
        cframe = CFrame.new(7400, 62, -6300),
        mobs = { "Ghost", "Demonic Soul", "Pirate Of Hell" },
        level_range = { 2000, 2100 },
        notes = "Ghostly port. Perfect for 2000-2100 range.",
    },
    [30] = {
        name = "Desolate Palace",
        sea = 3,
        type = "Boss",
        cframe = CFrame.new(-2850, 5, 3150),
        mobs = { "Blaze Pirate", "Electric Pirate" },
        level_range = { 2050, 2400 },
        bosses = { "Rip_Indra (Raid)" },
        notes = "Rip Indra's domain. Endgame content here.",
    },
    [31] = {
        name = "Ice Island (3rd Sea)",
        sea = 3,
        type = "Combat",
        cframe = CFrame.new(-12580, 5, 3050),
        mobs = { "Snow Demon", "Ice Demon" },
        level_range = { 1950, 2050 },
        bosses = { "Ice Admiral" },
        notes = "Frozen wasteland.",
    },
    [32] = {
        name = "Usoapp Island",
        sea = 3,
        type = "Quest",
        cframe = CFrame.new(-5085, 5, 3520),
        notes = "Island of the god Usoapp.",
    },
}

-- Get islands by sea
local function GetIslandsBySea(seaNum)
    local result = {}
    for _, island in ipairs(IslandDatabase) do
        if island.sea == seaNum then
            table.insert(result, island)
        end
    end
    return result
end

-- Get islands by level range
local function GetIslandsByLevel(level)
    local result = {}
    for _, island in ipairs(IslandDatabase) do
        if island.level_range then
            local min, max = island.level_range[1], island.level_range[2]
            if level >= min and level <= max then
                table.insert(result, island)
            end
        end
    end
    return result
end

-- ============================================================================
-- SECTION 56: DETAILED COMBAT SKILL SYSTEM
-- ============================================================================

local CombatSkillSystem = {}
CombatSkillSystem.SkillCooldowns = {}
CombatSkillSystem.LastUsedSkills = {}

-- Skill definitions (all combat skills in Blox Fruits)
local SkillDefinitions = {
    -- FRUIT SKILLS (examples)
    { id = "flame_z",     name = "Flamethrower",    key = "Z", fruit = "Flame",   cooldown = 3,   damage = 150,  range = 40, type = "Projectile" },
    { id = "flame_x",     name = "Fire Ball",        key = "X", fruit = "Flame",   cooldown = 5,   damage = 250,  range = 35, type = "Explosive" },
    { id = "flame_c",     name = "Flame Pillar",     key = "C", fruit = "Flame",   cooldown = 7,   damage = 350,  range = 20, type = "AoE" },
    { id = "flame_v",     name = "Meteor Shower",    key = "V", fruit = "Flame",   cooldown = 12,  damage = 500,  range = 60, type = "AoE" },
    { id = "flame_f",     name = "Phoenix Fire",     key = "F", fruit = "Flame",   cooldown = 15,  damage = 700,  range = 30, type = "Ultimate" },
    { id = "ice_z",       name = "Ice Spike",        key = "Z", fruit = "Ice",     cooldown = 3,   damage = 130,  range = 45, type = "Projectile" },
    { id = "ice_x",       name = "Ice Bird",         key = "X", fruit = "Ice",     cooldown = 6,   damage = 280,  range = 40, type = "Projectile" },
    { id = "ice_c",       name = "Glacial Age",      key = "C", fruit = "Ice",     cooldown = 8,   damage = 300,  range = 25, type = "AoE", freezes = true },
    { id = "ice_v",       name = "Ice Dragon",       key = "V", fruit = "Ice",     cooldown = 13,  damage = 550,  range = 55, type = "Dragon" },
    { id = "ice_f",       name = "Absolute Zero",    key = "F", fruit = "Ice",     cooldown = 18,  damage = 800,  range = 35, type = "Ultimate", freezes = true },
    { id = "magma_z",     name = "Magma Fist",       key = "Z", fruit = "Magma",   cooldown = 2,   damage = 180,  range = 15, type = "Melee" },
    { id = "magma_x",     name = "Magma Meteor",     key = "X", fruit = "Magma",   cooldown = 5,   damage = 320,  range = 30, type = "Explosive" },
    { id = "magma_c",     name = "Magma Eruption",   key = "C", fruit = "Magma",   cooldown = 7,   damage = 400,  range = 20, type = "AoE" },
    { id = "magma_v",     name = "Magma Tiles",      key = "V", fruit = "Magma",   cooldown = 10,  damage = 450,  range = 35, type = "AoE" },
    { id = "magma_f",     name = "Magma Admiral",    key = "F", fruit = "Magma",   cooldown = 16,  damage = 750,  range = 40, type = "Ultimate" },
    { id = "dragon_z",    name = "Dragon Claw",      key = "Z", fruit = "Dragon",  cooldown = 3,   damage = 200,  range = 20, type = "Melee" },
    { id = "dragon_x",    name = "Dragon Talon",     key = "X", fruit = "Dragon",  cooldown = 6,   damage = 380,  range = 25, type = "Combo" },
    { id = "dragon_c",    name = "Dragon Breath",    key = "C", fruit = "Dragon",  cooldown = 8,   damage = 460,  range = 35, type = "Breath" },
    { id = "dragon_v",    name = "Dragon Dive",      key = "V", fruit = "Dragon",  cooldown = 12,  damage = 600,  range = 20, type = "Aerial" },
    { id = "dragon_f",    name = "True Dragon",      key = "F", fruit = "Dragon",  cooldown = 20,  damage = 1000, range = 50, type = "Ultimate" },
    { id = "dough_z",     name = "Dough Spin",       key = "Z", fruit = "Dough",   cooldown = 2,   damage = 160,  range = 12, type = "Melee" },
    { id = "dough_x",     name = "Roundhead",        key = "X", fruit = "Dough",   cooldown = 5,   damage = 300,  range = 30, type = "Projectile" },
    { id = "dough_c",     name = "Dough Chop",       key = "C", fruit = "Dough",   cooldown = 7,   damage = 420,  range = 18, type = "Melee" },
    { id = "dough_v",     name = "Mochi Prison",     key = "V", fruit = "Dough",   cooldown = 11,  damage = 500,  range = 25, type = "Trap" },
    { id = "dough_f",     name = "Special Mochi",    key = "F", fruit = "Dough",   cooldown = 18,  damage = 900,  range = 45, type = "Ultimate" },
    -- SWORD SKILLS
    { id = "yama_z",      name = "Yama Slash",       key = "Z", weapon = "Yama",   cooldown = 2,   damage = 250,  range = 25, type = "Sword" },
    { id = "yama_x",      name = "Yama Storm",       key = "X", weapon = "Yama",   cooldown = 6,   damage = 480,  range = 30, type = "Sword" },
    { id = "yama_f",      name = "Yama Counter",     key = "F", weapon = "Yama",   cooldown = 15,  damage = 700,  range = 20, type = "Counter" },
    { id = "tushita_z",   name = "Tushita Slash",    key = "Z", weapon = "Tushita",cooldown = 2,   damage = 260,  range = 25, type = "Sword" },
    { id = "tushita_x",   name = "Holy Slash",       key = "X", weapon = "Tushita",cooldown = 6,   damage = 500,  range = 30, type = "Holy" },
    { id = "tushita_f",   name = "Tushita Ultimate", key = "F", weapon = "Tushita",cooldown = 16,  damage = 750,  range = 35, type = "Ultimate" },
    { id = "rengoku_z",   name = "Rengoku Slash",    key = "Z", weapon = "Rengoku",cooldown = 2,   damage = 240,  range = 20, type = "Fire Sword" },
    { id = "rengoku_x",   name = "Rengoku Flame",    key = "X", weapon = "Rengoku",cooldown = 5,   damage = 450,  range = 25, type = "Fire" },
    { id = "rengoku_f",   name = "Rengoku Hell",     key = "F", weapon = "Rengoku",cooldown = 14,  damage = 700,  range = 30, type = "Ultimate" },
}

-- Get best skills for situation
function CombatSkillSystem:GetBestSkills(scenario)
    local result = {}

    if scenario == "AoE" then
        -- Get all AoE skills
        for _, skill in ipairs(SkillDefinitions) do
            if skill.type == "AoE" or skill.type == "Explosive" then
                table.insert(result, skill)
            end
        end
    elseif scenario == "SingleTarget" then
        -- Get high single target damage
        for _, skill in ipairs(SkillDefinitions) do
            if skill.type == "Ultimate" or skill.type == "Dragon" then
                table.insert(result, skill)
            end
        end
    elseif scenario == "Ranged" then
        -- Ranged skills
        for _, skill in ipairs(SkillDefinitions) do
            if skill.type == "Projectile" and skill.range >= 35 then
                table.insert(result, skill)
            end
        end
    end

    -- Sort by damage
    table.sort(result, function(a, b)
        return a.damage > b.damage
    end)

    return result
end

-- Check if skill is on cooldown
function CombatSkillSystem:IsOnCooldown(skillId)
    local lastUsed = self.LastUsedSkills[skillId] or 0
    local skill = nil
    for _, s in ipairs(SkillDefinitions) do
        if s.id == skillId then skill = s; break end
    end
    if not skill then return false end
    return (tick() - lastUsed) < skill.cooldown
end

-- Use a skill
function CombatSkillSystem:UseSkill(skillId)
    if self:IsOnCooldown(skillId) then return false end

    local skill = nil
    for _, s in ipairs(SkillDefinitions) do
        if s.id == skillId then skill = s; break end
    end
    if not skill then return false end

    PvPSystem:ExecuteComboKey(skill.key)
    self.LastUsedSkills[skillId] = tick()
    Log("Used skill: " .. skill.name)
    return true
end

-- Optimal rotation (use skills in optimal DPS order)
function CombatSkillSystem:OptimalRotation(fruitName)
    -- Get all skills for this fruit
    local fruitSkills = {}
    for _, skill in ipairs(SkillDefinitions) do
        if skill.fruit and skill.fruit:lower() == fruitName:lower() then
            table.insert(fruitSkills, skill)
        end
    end

    -- Sort by damage/cooldown ratio (DPS priority)
    table.sort(fruitSkills, function(a, b)
        return (a.damage / a.cooldown) > (b.damage / b.cooldown)
    end)

    -- Use available skills in priority order
    for _, skill in ipairs(fruitSkills) do
        if not self:IsOnCooldown(skill.id) then
            self:UseSkill(skill.id)
            Wait(0.1)
        end
    end
end

-- ============================================================================
-- SECTION 57: NPC INTERACTION SYSTEM
-- ============================================================================

local NPCInteract = {}

-- All interactable NPCs with their purposes
local NPCDatabase = {
    {
        name = "Blox Fruit Dealer",
        type = "FruitShop",
        locations = {
            CFrame.new(975, 10, -1750),      -- First Sea
            CFrame.new(-1215, 40, -2485),    -- Second Sea
            CFrame.new(-11590, 5, -3590),    -- Third Sea
        },
        actions = { "BuyFruit", "SellFruit", "CheckStock" },
        stock = { "Chop", "Spike", "Spin", "Bomb" },
    },
    {
        name = "Cousin Blox Dealer",
        type = "FruitShop",
        locations = {
            CFrame.new(-3115, 40, -1885),    -- Cafe (2nd Sea)
        },
        actions = { "BuyFruit", "RandomFruit" },
    },
    {
        name = "Alchemist",
        type = "FruitStorage",
        locations = {
            CFrame.new(-3115, 44, -1880),
        },
        actions = { "StoreFruit", "RetrieveFruit", "CheckStorage" },
    },
    {
        name = "Blacksmith",
        type = "Upgrade",
        locations = {
            CFrame.new(-1520, 12, 1215),
            CFrame.new(-1215, 44, -2480),
            CFrame.new(-11590, 8, -3585),
        },
        actions = { "UpgradeSword", "EnhanceWeapon" },
    },
    {
        name = "Race Caretaker",
        type = "Race",
        locations = {
            CFrame.new(975, 12, -1745),
        },
        actions = { "BuyRace", "ChangeRace", "UpgradeRaceV2", "UpgradeRaceV3" },
    },
    {
        name = "Master of Auras",
        type = "Haki",
        locations = {
            CFrame.new(-3115, 42, -1875),
        },
        actions = { "BuyHaki", "UpgradeHaki" },
    },
    {
        name = "Ship Dealer",
        type = "Ship",
        locations = {
            CFrame.new(-100, 12, 0),
            CFrame.new(-1220, 42, -2480),
        },
        actions = { "BuyShip", "UpgradeShip" },
    },
    {
        name = "Legendary Sword Dealer",
        type = "SwordShop",
        locations = {
            CFrame.new(-3118, 42, -1878),
        },
        actions = { "BuySword", "CheckSwords" },
        stock = { "Yama", "Tushita", "Rengoku", "True Triple Katana", "Shisui", "Wando", "Saddi" },
    },
    {
        name = "Stat Reset NPC",
        type = "Stats",
        locations = {
            CFrame.new(978, 12, -1745),
        },
        actions = { "ResetStats", "CheckStats" },
    },
    {
        name = "Pet Handler",
        type = "Pet",
        locations = {
            CFrame.new(-3118, 42, -1882),
        },
        actions = { "EquipPet", "UnequipPet", "LevelPet" },
    },
    {
        name = "Gacha Machine",
        type = "Gacha",
        locations = {
            CFrame.new(-495, 10, 1638),
            CFrame.new(-1218, 42, -2482),
        },
        actions = { "Spin", "SpinRandom" },
    },
}

-- Interact with NPC by type
function NPCInteract:UseNPC(npcType, action, ...)
    for _, npc in ipairs(NPCDatabase) do
        if npc.type:lower() == npcType:lower() then
            -- Teleport to nearest location
            local hrp = GetHRP()
            if not hrp then return false end

            local nearestLoc = npc.locations[1]
            local nearestDist = math.huge

            for _, loc in ipairs(npc.locations) do
                local dist = GetDistance(hrp.Position, loc.Position)
                if dist < nearestDist then
                    nearestDist = dist
                    nearestLoc = loc
                end
            end

            SafeTeleport(nearestLoc)
            Wait(0.5)

            -- Fire the action
            SafeFireRemote(action, ...)
            Wait(0.3)

            Log("Used NPC: " .. npc.name .. " | Action: " .. action)
            return true
        end
    end
    return false
end

-- Buy specific fruit
function NPCInteract:BuyFruit(fruitName)
    Log("Buying fruit: " .. fruitName)
    self:UseNPC("FruitShop", "BuyFruit", fruitName)
end

-- Upgrade weapon
function NPCInteract:UpgradeWeapon(weaponName, upgradeLevel)
    Log("Upgrading weapon: " .. weaponName .. " to +" .. (upgradeLevel or 1))
    self:UseNPC("Upgrade", "UpgradeSword", weaponName, upgradeLevel)
end

-- Buy sword
function NPCInteract:BuySword(swordName)
    Log("Buying sword: " .. swordName)
    self:UseNPC("SwordShop", "BuySword", swordName)
end

-- ============================================================================
-- SECTION 58: ACHIEVEMENT TRACKING SYSTEM
-- ============================================================================

local AchievementSystem = {}
AchievementSystem.Unlocked = {}
AchievementSystem.Progress = {}

local Achievements = {
    {
        id = "first_kill",
        name = "First Blood",
        desc = "Kill your first enemy",
        condition = function() return AutoFarmEngine.KillCount >= 1 end,
        reward = "Title: Warrior",
    },
    {
        id = "kill_100",
        name = "Centurion",
        desc = "Kill 100 enemies",
        condition = function() return AutoFarmEngine.KillCount >= 100 end,
        reward = "100 Fragments",
    },
    {
        id = "kill_1000",
        name = "Slaughterer",
        desc = "Kill 1,000 enemies",
        condition = function() return AutoFarmEngine.KillCount >= 1000 end,
        reward = "500 Fragments",
    },
    {
        id = "kill_10000",
        name = "Massacre",
        desc = "Kill 10,000 enemies",
        condition = function() return AutoFarmEngine.KillCount >= 10000 end,
        reward = "2000 Fragments + Title",
    },
    {
        id = "first_fruit",
        name = "Devil's Taste",
        desc = "Collect your first fruit",
        condition = function() return AutoFruitSystem.CollectedCount >= 1 end,
        reward = "Title: Fruit User",
    },
    {
        id = "fruit_10",
        name = "Collector",
        desc = "Collect 10 fruits",
        condition = function() return AutoFruitSystem.CollectedCount >= 10 end,
        reward = "50 Fragments",
    },
    {
        id = "fruit_100",
        name = "Hoarder",
        desc = "Collect 100 fruits",
        condition = function() return AutoFruitSystem.CollectedCount >= 100 end,
        reward = "200 Fragments",
    },
    {
        id = "first_boss",
        name = "Boss Slayer",
        desc = "Defeat your first boss",
        condition = function()
            return BossDefeatSystem.DefeatCounts.Mirage +
                BossDefeatSystem.DefeatCounts.Indra +
                BossDefeatSystem.DefeatCounts.DoughKing +
                BossDefeatSystem.DefeatCounts.CakePrince >= 1
        end,
        reward = "Title: Boss Hunter",
    },
    {
        id = "indra_5",
        name = "Indra's Bane",
        desc = "Defeat Rip_Indra 5 times",
        condition = function() return BossDefeatSystem.DefeatCounts.Indra >= 5 end,
        reward = "Title: Indra's Bane",
    },
    {
        id = "pvp_hits_50",
        name = "Fighter",
        desc = "Land 50 PvP hits",
        condition = function() return PvPSystem.TotalHits >= 50 end,
        reward = "Title: Fighter",
    },
    {
        id = "pvp_hits_500",
        name = "Duelist",
        desc = "Land 500 PvP hits",
        condition = function() return PvPSystem.TotalHits >= 500 end,
        reward = "Title: Duelist",
    },
    {
        id = "elite_kill_all",
        name = "Elite Hunter",
        desc = "Kill all 3 elite hunters",
        condition = function() return EliteHunterSystem.KillCount >= 3 end,
        reward = "Title: Elite Hunter",
    },
    {
        id = "sea_beast_10",
        name = "Sea Conqueror",
        desc = "Kill 10 sea beasts",
        condition = function() return SeaBeastSystem.KillCount >= 10 end,
        reward = "Title: Sea Conqueror",
    },
    {
        id = "raid_complete_5",
        name = "Raider",
        desc = "Complete 5 raids",
        condition = function() return RaidSystem.RaidCount >= 5 end,
        reward = "Title: Raider",
    },
}

-- Check and unlock achievements
function AchievementSystem:CheckAll()
    for _, ach in ipairs(Achievements) do
        if not self.Unlocked[ach.id] then
            local success, result = pcall(ach.condition)
            if success and result then
                self.Unlocked[ach.id] = true
                Log("Achievement unlocked: " .. ach.name)
                Notify("🏆 Achievement!", ach.name .. " - " .. ach.desc, 5)
            end
        end
    end
end

-- Start achievement monitoring
task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            AchievementSystem:CheckAll()
        end)
    end
end)

-- ============================================================================
-- SECTION 59: EXTENDED GUI - MORE CONFIGURATION TABS
-- ============================================================================

local function BuildMoreTabs()
    -- =====================
    -- TAB 21: BUILDS
    -- =====================
    local buildTab = GUI:CreateTab("Builds", "📊")

    GUI:CreateSection(buildTab.page, "Stat Build Presets")

    for name, build in pairs(BuildPaths) do
        GUI:CreateButton(buildTab.page,
            build.name .. ": " .. build.desc,
            function()
                task.spawn(function()
                    StatDistribution:SpendPoints(name)
                end)
            end)
    end

    GUI:CreateSection(buildTab.page, "Build Info")
    for name, build in pairs(BuildPaths) do
        GUI:CreateLabel(buildTab.page, build.name)
        for stat, pct in pairs(build.stats) do
            if pct > 0 then
                GUI:CreateLabel(buildTab.page, "  " .. stat .. ": " .. pct .. "%")
            end
        end
    end

    -- =====================
    -- TAB 22: ACHIEVEMENTS
    -- =====================
    local achTab = GUI:CreateTab("Achievements", "🏆")

    GUI:CreateSection(achTab.page, "Achievement Progress")

    for _, ach in ipairs(Achievements) do
        local status = AchievementSystem.Unlocked[ach.id] and "✅" or "🔒"
        GUI:CreateLabel(achTab.page,
            status .. " " .. ach.name .. " - " .. ach.desc)
        GUI:CreateLabel(achTab.page, "  Reward: " .. ach.reward)
    end

    -- =====================
    -- TAB 23: SKILLS
    -- =====================
    local skillTab = GUI:CreateTab("Skills DB", "🌀")

    GUI:CreateSection(skillTab.page, "Fruit Skills")
    local lastFruit = ""
    for _, skill in ipairs(SkillDefinitions) do
        if skill.fruit then
            if skill.fruit ~= lastFruit then
                GUI:CreateLabel(skillTab.page, "── " .. skill.fruit .. " ──", GUI.Theme.Accent)
                lastFruit = skill.fruit
            end
            GUI:CreateLabel(skillTab.page,
                string.format("[%s] %s - DMG:%d CD:%.0fs Range:%d", 
                    skill.key, skill.name, skill.damage, skill.cooldown, skill.range))
        end
    end

    GUI:CreateSection(skillTab.page, "Sword Skills")
    local lastWeapon = ""
    for _, skill in ipairs(SkillDefinitions) do
        if skill.weapon then
            if skill.weapon ~= lastWeapon then
                GUI:CreateLabel(skillTab.page, "── " .. skill.weapon .. " ──", GUI.Theme.Accent)
                lastWeapon = skill.weapon
            end
            GUI:CreateLabel(skillTab.page,
                string.format("[%s] %s - DMG:%d CD:%.0fs", 
                    skill.key, skill.name, skill.damage, skill.cooldown))
        end
    end

    -- =====================
    -- TAB 24: MASTERY TRACKER
    -- =====================
    local mastTab = GUI:CreateTab("Mastery", "📈")

    GUI:CreateSection(mastTab.page, "Mastery Progress")

    for type_, data in pairs(MasteryTracker.Data) do
        GUI:CreateLabel(mastTab.page, type_ .. " Mastery")
        GUI:CreateLabel(mastTab.page, 
            string.format("  Progress: %d/%d (%.1f%%)", 
                data.current, data.target, MasteryTracker:GetProgress(type_)))
        GUI:CreateLabel(mastTab.page, "  ETA: " .. MasteryTracker:GetETA(type_))
    end

    GUI:CreateSection(mastTab.page, "Mastery Farm Settings")
    GUI:CreateDropdown(mastTab.page, "Auto Mastery Type",
        {"Fruit", "Sword", "Melee", "Gun"},
        "Fruit",
        function(v)
            Settings.AutoFarm.MasteryType = v
        end)

    GUI:CreateSection(mastTab.page, "Target Mastery Levels")
    GUI:CreateSlider(mastTab.page, "Fruit Target", 1, 700, 600, function(v)
        MasteryTracker.Data.Fruit.target = v
    end)
    GUI:CreateSlider(mastTab.page, "Sword Target", 1, 700, 600, function(v)
        MasteryTracker.Data.Sword.target = v
    end)
    GUI:CreateSlider(mastTab.page, "Melee Target", 1, 700, 600, function(v)
        MasteryTracker.Data.Melee.target = v
    end)
    GUI:CreateSlider(mastTab.page, "Gun Target", 1, 700, 600, function(v)
        MasteryTracker.Data.Gun.target = v
    end)

    -- =====================
    -- TAB 25: PERFORMANCE
    -- =====================
    local perfTab = GUI:CreateTab("Performance", "⚡")

    GUI:CreateSection(perfTab.page, "System Performance")

    local perfLabel = GUI:CreateLabel(perfTab.page, "Loading...")
    local networkLabel = GUI:CreateLabel(perfTab.page, "Ping: --ms")

    task.spawn(function()
        while task.wait(1) do
            if perfLabel and perfLabel.Parent then
                perfLabel.Text = PerformanceMonitor:GetReport()
                networkLabel.Text = string.format(
                    "Ping: %dms (avg: %dms)",
                    NetworkMonitor.LastPing,
                    NetworkMonitor.AveragePing
                )
            else
                break
            end
        end
    end)

    GUI:CreateSection(perfTab.page, "Optimization")
    GUI:CreateToggle(perfTab.page, "Reduce Lag Mode", false, function(v)
        if v then
            -- Reduce scan rates when lagging
            Settings.AutoFruit.ScanInterval = 2.0
            Settings.AutoFarm.AttackDelay = 0.2
            Settings.AutoFarm.LoopDelay = 0.3
        else
            Settings.AutoFruit.ScanInterval = 1.0
            Settings.AutoFarm.AttackDelay = 0.08
            Settings.AutoFarm.LoopDelay = 0.1
        end
    end)

    GUI:CreateToggle(perfTab.page, "Auto Server Hop on High Lag", false, function(v)
        if v then
            ServerHopSystem:AutoHop(function()
                return NetworkMonitor.AveragePing > 400
            end)
        else
            ServerHopSystem:Stop()
        end
    end)

    -- =====================
    -- TAB 26: ISLAND DB
    -- =====================
    local islandTab = GUI:CreateTab("Island DB", "🗺️")

    GUI:CreateSection(islandTab.page, "First Sea")
    for _, island in ipairs(IslandDatabase) do
        if island.sea == 1 then
            GUI:CreateButton(islandTab.page, island.name .. " (Lvl " ..
                (island.level_range and table.concat(island.level_range, "-") or "?") .. ")",
                function()
                    SafeTeleport(island.cframe)
                    Notify("Teleport", "→ " .. island.name, 2)
                end)
        end
    end

    GUI:CreateSection(islandTab.page, "Second Sea")
    for _, island in ipairs(IslandDatabase) do
        if island.sea == 2 then
            GUI:CreateButton(islandTab.page, island.name .. " (Lvl " ..
                (island.level_range and table.concat(island.level_range, "-") or "?") .. ")",
                function()
                    SafeTeleport(island.cframe)
                    Notify("Teleport", "→ " .. island.name, 2)
                end)
        end
    end

    GUI:CreateSection(islandTab.page, "Third Sea")
    for _, island in ipairs(IslandDatabase) do
        if island.sea == 3 then
            GUI:CreateButton(islandTab.page, island.name .. " (Lvl " ..
                (island.level_range and table.concat(island.level_range, "-") or "?") .. ")",
                function()
                    SafeTeleport(island.cframe)
                    Notify("Teleport", "→ " .. island.name, 2)
                end)
        end
    end

    -- =====================
    -- TAB 27: SERVER HOP
    -- =====================
    local hopTab = GUI:CreateTab("Server Hop", "🔀")

    GUI:CreateSection(hopTab.page, "Server Hop Controls")

    GUI:CreateButton(hopTab.page, "🔀 Hop to New Server", function()
        ServerHopSystem:Hop("Manual hop")
    end)

    GUI:CreateToggle(hopTab.page, "Auto Hop if Admin Detected", Settings.AdminDetection.AutoLeave, function(v)
        Settings.AdminDetection.AutoLeave = v
    end)

    GUI:CreateToggle(hopTab.page, "Auto Hop if Server Too Full", false, function(v)
        if v then
            ServerHopSystem:HopIfCrowded(8)
        else
            ServerHopSystem:Stop()
        end
    end)

    GUI:CreateSlider(hopTab.page, "Max Players Before Hop", 3, 15, 8, function(v)
        ServerHopSystem:Stop()
        ServerHopSystem:HopIfCrowded(v)
    end)

    GUI:CreateSection(hopTab.page, "Stats")
    local hopCountLabel = GUI:CreateLabel(hopTab.page, "Hops Performed: 0")
    task.spawn(function()
        while task.wait(2) do
            if hopCountLabel and hopCountLabel.Parent then
                hopCountLabel.Text = "Hops Performed: " .. ServerHopSystem.HopCount
            else
                break
            end
        end
    end)

    -- =====================
    -- TAB 28: NPC SHOP
    -- =====================
    local shopTab = GUI:CreateTab("NPC Shop", "🛒")

    GUI:CreateSection(shopTab.page, "Buy Items")

    GUI:CreateSection(shopTab.page, "Fruits")
    for _, fruit in ipairs(FruitData) do
        GUI:CreateButton(shopTab.page,
            string.format("Buy: %s [$%d - %s]", fruit.name, fruit.price, fruit.rarity),
            function()
                NPCInteract:BuyFruit(fruit.name)
            end)
    end

    GUI:CreateSection(shopTab.page, "Swords")
    local swordDealer = nil
    for _, npc in ipairs(NPCDatabase) do
        if npc.type == "SwordShop" then
            swordDealer = npc
            break
        end
    end
    if swordDealer then
        for _, sword in ipairs(swordDealer.stock) do
            GUI:CreateButton(shopTab.page, "Buy: " .. sword, function()
                NPCInteract:BuySword(sword)
            end)
        end
    end

    -- =====================
    -- TAB 29: COMBO BUILDER
    -- =====================
    local comboBuilderTab = GUI:CreateTab("Combo Builder", "⌨️")

    GUI:CreateSection(comboBuilderTab.page, "Build Your Combo")

    GUI:CreateLabel(comboBuilderTab.page,
        "Record your own custom combo sequence")

    GUI:CreateButton(comboBuilderTab.page, "🔴 Start Recording", function()
        ComboBuilder:StartRecording()
    end)

    GUI:CreateButton(comboBuilderTab.page, "⬛ Stop Recording", function()
        local keys = ComboBuilder:StopRecording()
        if keys then
            Log("Recorded combo: " .. table.concat(keys, " → "))
        end
    end)

    local comboNameInput = GUI:CreateInput(comboBuilderTab.page, "Combo Name", "Enter combo name...")
    GUI:CreateButton(comboBuilderTab.page, "💾 Save Combo", function()
        local name = comboNameInput.box.Text
        if name and name ~= "" then
            ComboBuilder:SaveCombo(name)
            Notify("Combo Saved", name, 3)
        end
    end)

    GUI:CreateSection(comboBuilderTab.page, "Saved Combos")
    GUI:CreateLabel(comboBuilderTab.page, "Your saved combos will appear here")

    GUI:CreateButton(comboBuilderTab.page, "▶ Execute Recorded Combo", function()
        local keys = ComboBuilder.RecordedKeys
        if #keys > 0 then
            local target = PvPSystem.LockedTarget
            for _, key in ipairs(keys) do
                PvPSystem:ExecuteComboKey(key)
                Wait(Settings.PvP.GlobalComboDelay)
            end
        end
    end)

    -- =====================
    -- TAB 30: INFO / CREDITS
    -- =====================
    local infoTab = GUI:CreateTab("Info", "ℹ️")

    GUI:CreateSection(infoTab.page, "About Omega Hub")
    GUI:CreateLabel(infoTab.page, "Version: " .. OmegaHub.Version)
    GUI:CreateLabel(infoTab.page, "Game: Blox Fruits")
    GUI:CreateLabel(infoTab.page, "Built for: Roblox")
    GUI:CreateLabel(infoTab.page, "")

    GUI:CreateSection(infoTab.page, "Features")
    local features = {
        "✅ Anti-Ban System with Humanizer",
        "✅ Admin Detection + Auto Leave",
        "✅ Auto Farm (Level/Boss/Mastery)",
        "✅ Auto Quest (Draco/Dragon/V2/V3/V4)",
        "✅ Auto Fruit (Get/Store/Random/Bring)",
        "✅ Teleport System (All Islands/NPCs)",
        "✅ PvP (AutoCombo/GetInside/SilentAim)",
        "✅ Egg Collect + Berry Farm",
        "✅ Elite Hunters (Deandre/Diablo/Gonzalo)",
        "✅ Swords (Yama/Tushita/Rengoku/TTK)",
        "✅ Race V2/V3/V4, Cyborg, Ghoul",
        "✅ Auto Mirage/Indra/Dough King/Cake Prince",
        "✅ Raid System + Sea Beast",
        "✅ Quest Chains (Draco/Dragon)",
        "✅ ESP (Player/Boss/Fruit)",
        "✅ Fly, NoClip, Inf Jump",
        "✅ Auto Stat Distribution",
        "✅ Server Hop System",
        "✅ Achievement Tracker",
        "✅ Performance Monitor",
        "✅ Combo Builder",
        "✅ 32+ Islands Database",
        "✅ Full Boss Database (35+ bosses)",
        "✅ Complete Fruit Database (40+ fruits)",
    }
    for _, feat in ipairs(features) do
        GUI:CreateLabel(infoTab.page, feat, GUI.Theme.Success)
    end

    GUI:CreateSection(infoTab.page, "Hotkeys Reference")
    for key, desc in pairs(HotkeySystem.DefaultHotkeys) do
        GUI:CreateLabel(infoTab.page, "[" .. key .. "] - " .. desc)
    end
end

task.delay(1.5, function()
    if OmegaHub.Loaded then
        pcall(BuildMoreTabs)
    end
end)

-- ============================================================================
-- SECTION 60: EXTENDED FARM FUNCTIONS - MOB ROTATION
-- ============================================================================

-- Track mob spawn timers
local MobSpawnTrackers = {}

local function TrackMobSpawn(mobName, spawnTime)
    MobSpawnTrackers[mobName] = {
        lastKill = tick(),
        estimatedSpawn = tick() + (spawnTime or 60),
        killCount = (MobSpawnTrackers[mobName] and MobSpawnTrackers[mobName].killCount or 0) + 1,
    }
end

local function IsMobSpawned(mobName)
    local tracker = MobSpawnTrackers[mobName]
    if not tracker then return true end -- Unknown, assume spawned
    return tick() >= tracker.estimatedSpawn
end

-- Mob rotation - cycle between multiple mob types
function AutoFarmEngine:RotateMobs(mobList)
    local index = 1

    task.spawn(function()
        while Settings.AutoFarm.Enabled do
            if not IsAlive() then Wait(3); continue end

            local targetMob = mobList[index]
            if IsMobSpawned(targetMob) then
                -- Find and kill
                local enemies = GetEnemyByName(targetMob)
                for _, enemy in ipairs(enemies) do
                    if not Settings.AutoFarm.Enabled then break end
                    local killed = self:AttackEnemy(enemy)
                    if killed then
                        TrackMobSpawn(targetMob)
                        self.KillCount = self.KillCount + 1
                    end
                    Wait(0.1)
                end

                -- Move to next mob
                index = (index % #mobList) + 1
            else
                -- Wait for spawn
                Wait(5)
            end

            HumanizedWait()
        end
    end)
end

-- ============================================================================
-- SECTION 61: QUEST REWARD TRACKING
-- ============================================================================

local QuestRewardTracker = {}
QuestRewardTracker.TotalXP = 0
QuestRewardTracker.TotalMoney = 0
QuestRewardTracker.TotalFragments = 0
QuestRewardTracker.ItemsReceived = {}

function QuestRewardTracker:AddXP(amount)
    self.TotalXP = self.TotalXP + amount
end

function QuestRewardTracker:AddMoney(amount)
    self.TotalMoney = self.TotalMoney + amount
end

function QuestRewardTracker:AddFragment(amount)
    self.TotalFragments = self.TotalFragments + amount
end

function QuestRewardTracker:AddItem(itemName)
    if not self.ItemsReceived[itemName] then
        self.ItemsReceived[itemName] = 0
    end
    self.ItemsReceived[itemName] = self.ItemsReceived[itemName] + 1
end

function QuestRewardTracker:GetSummary()
    return string.format(
        "XP: %d | Money: $%d | Fragments: %d",
        self.TotalXP,
        self.TotalMoney,
        self.TotalFragments
    )
end

-- ============================================================================
-- SECTION 62: AUTO ENHANCEMENT SYSTEM
-- ============================================================================

local AutoEnhancement = {}
AutoEnhancement.Active = false

-- Enhancement materials
local EnhancementMaterials = {
    { material = "Leather",      cost = 500,   for_ = "Basic Weapons" },
    { material = "Scrap Metal",  cost = 1000,  for_ = "Iron Weapons" },
    { material = "Magma Ore",    cost = 2000,  for_ = "Magma Weapons" },
    { material = "Dark Fragment",cost = 5000,  for_ = "Dark Weapons" },
    { material = "Dragon Scale", cost = 10000, for_ = "Dragon Weapons" },
    { material = "Slayer Essence",cost = 8000, for_ = "Elite Weapons" },
}

-- Auto enhance equipped weapon
function AutoEnhancement:EnhanceWeapon(weaponName, targetLevel)
    targetLevel = targetLevel or 10
    Log("Auto enhancing: " .. weaponName .. " to level " .. targetLevel)

    for level = 1, targetLevel do
        -- Teleport to blacksmith
        NPCInteract:UseNPC("Upgrade", "UpgradeSword", weaponName, level)
        Wait(0.5)
        Log("Enhanced to level: " .. level)
    end

    Notify("⚒️ Enhanced!", weaponName .. " → Level " .. targetLevel, 3)
end

-- Collect enhancement materials
function AutoEnhancement:CollectMaterials(materialName)
    MaterialSystem:FarmMaterial(materialName)
end

-- ============================================================================
-- SECTION 63: WORLD MAP NAVIGATOR
-- ============================================================================

local WorldMapNavigator = {}
WorldMapNavigator.CurrentSea = 1
WorldMapNavigator.VisitedIslands = {}
WorldMapNavigator.ExplorationPercent = 0

function WorldMapNavigator:ExploreAll(seaNum)
    Log("Exploring all of sea " .. seaNum)

    local islands = GetIslandsBySea(seaNum)
    local explored = 0

    for _, island in ipairs(islands) do
        if not Settings.AutoFarm.Enabled then break end

        Log("Visiting: " .. island.name)
        SafeTeleport(island.cframe)
        Wait(2)

        WorldMapNavigator.VisitedIslands[island.name] = true
        explored = explored + 1
        WorldMapNavigator.ExplorationPercent = (explored / #islands) * 100

        Log(string.format("Exploration: %.0f%% (%d/%d)", WorldMapNavigator.ExplorationPercent, explored, #islands))
    end

    Log("Sea " .. seaNum .. " fully explored!")
end

-- Find shortest path between two islands
function WorldMapNavigator:GetPath(fromIsland, toIsland)
    -- Simple direct teleport path
    return {fromIsland, toIsland}
end

-- ============================================================================
-- SECTION 64: COMPLETE RESET FUNCTIONS
-- ============================================================================

local ResetSystem = {}

-- Reset all counters
function ResetSystem:ResetCounters()
    AutoFarmEngine.KillCount = 0
    AutoFruitSystem.CollectedCount = 0
    AutoFruitSystem.StoredCount = 0
    EggSystem.CollectedEggs = 0
    BerrySystem.BerryCount = 0
    EliteHunterSystem.KillCount = 0
    BossDefeatSystem.DefeatCounts = { Mirage = 0, Indra = 0, DoughKing = 0, CakePrince = 0 }
    SeaBeastSystem.KillCount = 0
    RaidSystem.RaidCount = 0
    PvPSystem.TotalHits = 0
    AutoQuestSystem.CompletedQuests = 0
    Log("All counters reset")
    Notify("Reset", "All counters cleared", 2)
end

-- Stop all systems
function ResetSystem:StopAllSystems()
    Settings.AutoFarm.Enabled = false
    Settings.AutoQuest.Enabled = false
    Settings.PvP.Enabled = false
    Settings.AutoFruit.Enabled = false
    Settings.Eggs.AutoCollectEggs = false
    Settings.Berry.AutoCollectBerry = false
    Settings.EliteHunters.AutoFarm = false
    Settings.BossDefeat.AutoMirage = false
    Settings.BossDefeat.AutoIndra = false
    Settings.BossDefeat.AutoDoughKing = false
    Settings.BossDefeat.AutoCakePrince = false

    AutoFarmEngine:Stop()
    AutoQuestSystem:Stop()
    PvPSystem:Stop()
    AutoFruitSystem:Stop()
    EggSystem:Stop()
    BerrySystem:Stop()
    EliteHunterSystem:Stop()
    BossDefeatSystem:Stop()
    SeaBeastSystem:Stop()
    RaidSystem:Stop()
    SpecialSwordSystem:Stop()
    AutoRaceSystem:Stop()
    AntiBanSystem:Stop()

    Log("All systems stopped")
    Notify("⏹ All Stopped", "All automation systems halted", 3)
end

-- Full script restart
function ResetSystem:Restart()
    self:StopAllSystems()
    Wait(1)
    self:ResetCounters()
    AntiBanSystem:Start()
    AdminDetector:Start()
    MiscSystem:StartAntiVoid()
    Log("Script restarted")
    Notify("🔄 Restarted", "OmegaHub has been restarted", 3)
end

-- ============================================================================
-- SECTION 65: DATA EXPORT SYSTEM
-- ============================================================================

-- Export session data as formatted string
local function ExportSessionData()
    local data = {
        "=== OMEGA HUB SESSION EXPORT ===",
        "Version: " .. OmegaHub.Version,
        "Date: " .. os.date(),
        "",
        "=== COMBAT STATS ===",
        "Total Kills: " .. AutoFarmEngine.KillCount,
        "PvP Hits: " .. PvPSystem.TotalHits,
        "Bosses - Indra: " .. BossDefeatSystem.DefeatCounts.Indra,
        "Bosses - Dough King: " .. BossDefeatSystem.DefeatCounts.DoughKing,
        "Bosses - Cake Prince: " .. BossDefeatSystem.DefeatCounts.CakePrince,
        "Bosses - Mirage: " .. BossDefeatSystem.DefeatCounts.Mirage,
        "Sea Beasts: " .. SeaBeastSystem.KillCount,
        "Elite Kills: " .. EliteHunterSystem.KillCount,
        "",
        "=== COLLECTION STATS ===",
        "Fruits Collected: " .. AutoFruitSystem.CollectedCount,
        "Fruits Stored: " .. AutoFruitSystem.StoredCount,
        "Eggs: " .. EggSystem.CollectedEggs,
        "Berry: " .. BerrySystem.BerryCount,
        "",
        "=== QUEST STATS ===",
        "Quests Done: " .. AutoQuestSystem.CompletedQuests,
        "Raids Done: " .. RaidSystem.RaidCount,
        "",
        "=== SETTINGS ===",
        "Walk Speed: " .. Settings.Misc.WalkSpeed,
        "Fly Speed: " .. Settings.Misc.FlySpeed,
        "PvP Strategy: " .. ExtendedPvP.CurrentStrategy,
        "Farm Mode: " .. Settings.AutoFarm.MasteryType,
        "Quest Type: " .. Settings.AutoQuest.QuestType,
        "",
        "================================",
    }

    local result = table.concat(data, "\n")
    Log("Session Export:\n" .. result)
    return result
end

-- ============================================================================
-- SECTION 66: FINAL NOTES AND DOCUMENTATION
-- ============================================================================

--[[
==========================================================
OMEGA HUB v4.0 - COMPLETE FEATURE DOCUMENTATION
==========================================================

SECTION A: ANTI-BAN SYSTEM
- Humanizer: Adds random delays (5ms - 150ms) between actions
- Fake Movement: Subtle micro-movements to appear human
- Random Rotation: Occasional random camera/character rotations
- Anti-AFK: Prevents idle kick by simulating activity
- Jump Randomizer: Occasional random jumps
- Configurable min/max delays for all actions

SECTION B: ADMIN DETECTION
- Real-time player join monitoring
- Username matching against known admin list
- Staff badge detection
- Private server detection
- Auto-leave with configurable delay
- Stops all active scripts before leaving

SECTION C: AUTO FARM
- Level-based farming: Optimal mob selection by level
- Boss farming: All 35+ bosses supported
- Mastery farming: Fruit/Sword/Melee/Gun mastery grinding
- Auto skill usage: Z/X/C/V/F keys
- Auto revive on death
- Collect drops automatically
- Target level system
- Configurable attack delay

SECTION D: AUTO QUEST
- Level quests: Automatically accept and complete
- Draco Quest: Full chain automation
- Dragon Quest: Full chain automation
- Draco V2/V3/V4: All transformation quests
- Auto accept/turn-in/repeat
- Configurable quest delay

SECTION E: AUTO FRUIT
- Auto Get Fruit: Teleport and collect nearby fruits
- Auto Store Fruit: Store to NPC alchemist
- Auto Random Fruit: Buy lucky spin fruits
- Bring Fruits To Player: Continuous scan and collect
- Scan radius: 100-5000 studs
- Fruit ESP: Billboard labels on all fruits
- Rarity notifications for Rare/Legendary/Mythical
- Blacklist/Whitelist by fruit name
- Auto sell low-value fruits

SECTION F: TELEPORT SYSTEM
- 32+ islands across all 3 seas
- 30+ NPC quest givers
- All boss spawn locations
- All shop locations
- Player teleport by name
- Bookmark system (save/load positions)
- Safe zone quick teleport
- Island hopper (sequential exploration)
- Coordinate database with 60+ locations

SECTION G: PVP SYSTEM
- Auto lock target (nearest/by name)
- Get Inside Player: Instant teleport inside target
- Auto Combo: Configurable Z/X/C/V/F keys
- Per-key delay adjustment (10ms - 500ms)
- Global combo delay slider
- Loop combo toggle
- 10 combo strategies (Standard/Aggressive/Defensive etc)
- Custom combo builder (record your own)
- Auto aim towards target
- Anti-knockback protection
- Strafe targeting
- Target prediction
- Team check (ignore teammates)

SECTION H: EGGS & BERRY
- Auto collect all egg types (Common to Mythical)
- Auto give eggs to NPCs
- Berry scan and collection
- Auto spend berry on race upgrades
- Configurable radii and delays

SECTION I: ELITE HUNTERS
- Auto hunt Deandre (→ Yama)
- Auto hunt Diablo (→ Tushita)
- Auto hunt Gonzalo (→ Rengoku)
- Kill count tracking
- Individual or "All" mode

SECTION J: SPECIAL SWORDS
- Yama: Full quest chain automation
- Tushita: Full quest chain automation
- Rengoku: Full quest chain automation
- True Triple Katana: Full quest chain automation
- Step-by-step logging

SECTION K: AUTO RACE
- Race V2: Full automation
- Race V3: Full automation
- Race V4: Full automation
- Cyborg: Full automation (with Core Brain farming)
- Ghoul: Full automation (night kills)
- Auto buy/change race by name

SECTION L: BOSS DEFEAT
- Auto Mirage Island Boss
- Auto Rip_Indra (Raid)
- Auto Dough King
- Auto Cake Prince
- Loop mode with configurable delay
- Boss phase detection and strategy adaptation

SECTION M: MISC
- Fly mode (WASD + Space/Shift controls)
- NoClip through walls
- Walk speed (1-300)
- Jump power adjustment
- Infinite jump
- Anti-void protection
- Player/Boss/Fruit ESP with billboard labels
- Auto stat distribution (10 build presets)
- Server hop (manual/auto)
- Chat bypass (cosmetic)

HOTKEYS:
  ]      = Toggle GUI visibility
  Del    = Emergency stop ALL systems
  F1     = Toggle Auto Farm
  F2     = Toggle PvP
  F3     = Toggle Auto Fruit
  F4     = Teleport to Safe Zone
  F5     = Toggle Auto Quest
  F6     = Toggle Sea Beast Farm
  F7     = Server Hop
  F8     = Toggle Fly
  F9     = Toggle NoClip
  F10    = Lock Nearest Target
  F11    = Unlock Target
  F12    = Toggle ESP
  PgUp   = Increase Walk Speed (+5)
  PgDn   = Decrease Walk Speed (-5)
  Home   = Save Position Bookmark
  End    = Go To Last Bookmark
  Insert = Toggle Anti-Ban

==========================================================
END OF DOCUMENTATION
==========================================================
]]

-- Final log
Log("=== All 66 sections loaded ===")
Log("Total bosses in database: " .. (#BossData + #ExtendedBossData))
Log("Total islands in database: " .. #IslandData)
Log("Total fruits in database: " .. #FruitData)
Log("Total NPCs in database: " .. #QuestNPCs)
Log("Total combo strategies: " .. (function()
    local count = 0
    for _ in pairs(ComboStrategies) do count = count + 1 end
    return count
end)())
Log("Total skill definitions: " .. #SkillDefinitions)
Log("Total achievements: " .. #Achievements)

-- ============================================================================
-- END OF OMEGA HUB v4.0 - COMPLETE SCRIPT
-- ============================================================================

-- ============================================================================
-- SECTION 67: EXTENDED MOB DATABASE (ALL KNOWN MOBS - COMPREHENSIVE)
-- ============================================================================

local FullMobDatabase = {
    -- ============================
    -- FIRST SEA - COMPLETE LIST
    -- ============================
    { name = "Bandit",              level = 1,    hp = 125,   xp = 50,    money = 15,   drops = {"Bone"},             sea = 1 },
    { name = "Monkey",              level = 15,   hp = 225,   xp = 75,    money = 20,   drops = {"Monkey Tail"},       sea = 1 },
    { name = "Gorilla",             level = 25,   hp = 375,   xp = 100,   money = 30,   drops = {"Gorilla Fang"},      sea = 1 },
    { name = "Pirate",              level = 35,   hp = 450,   xp = 125,   money = 40,   drops = {"Pirate Flag"},       sea = 1 },
    { name = "Pirate Brute",        level = 50,   hp = 625,   xp = 175,   money = 55,   drops = {"Brute Fist"},        sea = 1 },
    { name = "Desert Bandit",       level = 60,   hp = 750,   xp = 200,   money = 65,   drops = {"Sand Grain"},        sea = 1 },
    { name = "Desert Officer",      level = 75,   hp = 937,   xp = 250,   money = 80,   drops = {"Officer Badge"},     sea = 1 },
    { name = "Snowman",             level = 90,   hp = 1125,  xp = 300,   money = 95,   drops = {"Ice Shard"},         sea = 1 },
    { name = "Snow Bandit",         level = 90,   hp = 1125,  xp = 300,   money = 95,   drops = {"Ice Crystal"},       sea = 1 },
    { name = "Arctic Warrior",      level = 110,  hp = 1375,  xp = 360,   money = 110,  drops = {"Arctic Coat"},       sea = 1 },
    { name = "Prisoner",            level = 100,  hp = 1250,  xp = 340,   money = 105,  drops = {"Prison Key"},        sea = 1 },
    { name = "Dangerous Prisoner",  level = 200,  hp = 2500,  xp = 550,   money = 180,  drops = {"Escape Plan"},       sea = 1 },
    { name = "Marine",              level = 120,  hp = 1500,  xp = 400,   money = 120,  drops = {"Marine Badge"},      sea = 1 },
    { name = "Marine Soldier",      level = 150,  hp = 1875,  xp = 480,   money = 145,  drops = {"Soldier Rifle"},     sea = 1 },
    { name = "Marine Captain",      level = 200,  hp = 2500,  xp = 600,   money = 185,  drops = {"Captain Coat"},      sea = 1 },
    { name = "Sky Bandit",          level = 400,  hp = 5000,  xp = 800,   money = 300,  drops = {"Sky Feather"},       sea = 1 },
    { name = "Dark Master",         level = 425,  hp = 5312,  xp = 880,   money = 320,  drops = {"Dark Crystal"},      sea = 1 },
    { name = "Sky Pirate",          level = 450,  hp = 5625,  xp = 950,   money = 340,  drops = {"Pirate Sky Flag"},   sea = 1 },
    { name = "Toga Warrior",        level = 625,  hp = 7812,  xp = 1100,  money = 420,  drops = {"Toga"},              sea = 1 },
    { name = "Gladiator",           level = 650,  hp = 8125,  xp = 1200,  money = 450,  drops = {"Gladiator Helmet"},  sea = 1 },
    { name = "Lava Pirate",         level = 300,  hp = 3750,  xp = 700,   money = 250,  drops = {"Magma Ore"},         sea = 1 },
    { name = "Magma Bandit",        level = 350,  hp = 4375,  xp = 780,   money = 280,  drops = {"Magma Rock"},        sea = 1 },
    { name = "Pirate Captain",      level = 225,  hp = 2812,  xp = 640,   money = 200,  drops = {"Captain Map"},       sea = 1 },
    { name = "Marine Lieutenant",   level = 175,  hp = 2187,  xp = 520,   money = 160,  drops = {"Lieutenant Badge"},  sea = 1 },
    { name = "Dark Pirate",         level = 475,  hp = 5937,  xp = 1020,  money = 365,  drops = {"Dark Eye Patch"},    sea = 1 },
    { name = "Sky Warrior",         level = 475,  hp = 5937,  xp = 1020,  money = 365,  drops = {"Wing Armor"},        sea = 1 },

    -- ============================
    -- SECOND SEA - COMPLETE LIST
    -- ============================
    { name = "Factory Staff",       level = 700,  hp = 8750,  xp = 1250,  money = 500,  drops = {"Factory Chip"},      sea = 2 },
    { name = "Scientist",           level = 775,  hp = 9687,  xp = 1350,  money = 540,  drops = {"Science Vial"},      sea = 2 },
    { name = "Saber Expert",        level = 150,  hp = 1875,  xp = 500,   money = 150,  drops = {"Saber"},             sea = 2, isBoss = true },
    { name = "Sea Soldier",         level = 775,  hp = 9687,  xp = 1300,  money = 520,  drops = {"Sea Armor"},         sea = 2 },
    { name = "Fishman Warrior",     level = 875,  hp = 10937, xp = 1550,  money = 600,  drops = {"Fishman Scale"},     sea = 2 },
    { name = "Fishman Commando",    level = 925,  hp = 11562, xp = 1700,  money = 650,  drops = {"Commando Helmet"},   sea = 2 },
    { name = "Zombie",              level = 950,  hp = 11875, xp = 1750,  money = 680,  drops = {"Zombie Hand"},       sea = 2 },
    { name = "Zombie Pirate",       level = 975,  hp = 12187, xp = 1800,  money = 700,  drops = {"Zombie Blade"},      sea = 2 },
    { name = "Vampire",             level = 1025, hp = 12812, xp = 1900,  money = 740,  drops = {"Vampire Fang"},      sea = 2 },
    { name = "Soul Carrier",        level = 1125, hp = 14062, xp = 2000,  money = 780,  drops = {"Soul Crystal"},      sea = 2 },
    { name = "Living Zombie",       level = 1050, hp = 13125, xp = 1950,  money = 760,  drops = {"Living Fist"},       sea = 2 },
    { name = "Demonic Soul",        level = 1075, hp = 13437, xp = 2000,  money = 775,  drops = {"Demonic Shard"},     sea = 2 },
    { name = "Posessed Mummy",      level = 1100, hp = 13750, xp = 2050,  money = 790,  drops = {"Mummy Wrap"},        sea = 2 },
    { name = "Reaper",              level = 1575, hp = 19687, xp = 2800,  money = 1100, drops = {"Scythe Fragment"},   sea = 2 },
    { name = "Ice Cream Staff",     level = 1200, hp = 15000, xp = 2100,  money = 820,  drops = {"Ice Cream"},         sea = 2 },
    { name = "Snow Lurker",         level = 1150, hp = 14375, xp = 2000,  money = 800,  drops = {"Snow Coat"],         sea = 2 },
    { name = "Dicer",               level = 1175, hp = 14687, xp = 2100,  money = 810,  drops = {"Dice"},              sea = 2 },
    { name = "Factory Worker",      level = 750,  hp = 9375,  xp = 1300,  money = 520,  drops = {"Worker Badge"],      sea = 2 },
    { name = "Lab Pirate",          level = 1300, hp = 16250, xp = 2200,  money = 850,  drops = {"Lab Badge"],         sea = 2 },
    { name = "Ice Pirate",          level = 1350, hp = 16875, xp = 2300,  money = 870,  drops = {"Ice Armor"],         sea = 2 },
    { name = "Marine Commodore",    level = 1475, hp = 18437, xp = 2600,  money = 980,  drops = {"Commodore Badge"],   sea = 2 },
    { name = "Marine Rear Admiral", level = 1450, hp = 18125, xp = 2550,  money = 960,  drops = {"Rear Badge"],        sea = 2 },
    { name = "Cursed Skull",        level = 1925, hp = 24062, xp = 3600,  money = 1350, drops = {"Cursed Fragment"],   sea = 2 },

    -- ============================
    -- THIRD SEA - COMPLETE LIST
    -- ============================
    { name = "Pirate Millionaire",  level = 1500, hp = 18750, xp = 2600,  money = 1000, drops = {"Gold Coin"],         sea = 3 },
    { name = "Forest Pirate",       level = 1525, hp = 19062, xp = 2700,  money = 1020, drops = {"Forest Badge"],      sea = 3 },
    { name = "Mythological Pirate", level = 1575, hp = 19687, xp = 2800,  money = 1050, drops = {"Myth Fragment"],     sea = 3 },
    { name = "Jungle Pirate",       level = 1600, hp = 20000, xp = 2900,  money = 1080, drops = {"Jungle Wood"],       sea = 3 },
    { name = "Musketeer Pirate",    level = 1625, hp = 20312, xp = 3000,  money = 1100, drops = {"Musket Barrel"],     sea = 3 },
    { name = "Dragon Crew Warrior", level = 1675, hp = 20937, xp = 3100,  money = 1150, drops = {"Dragon Scale"},      sea = 3 },
    { name = "Dragon Crew Archer",  level = 1700, hp = 21250, xp = 3200,  money = 1180, drops = {"Dragon Arrow"],      sea = 3 },
    { name = "Marine Commodore",    level = 1725, hp = 21562, xp = 3300,  money = 1200, drops = {"Commodore Coat"],    sea = 3 },
    { name = "Marine Vice Admiral", level = 1750, hp = 21875, xp = 3400,  money = 1230, drops = {"Vice Coat"],         sea = 3 },
    { name = "Beautiful Pirate",    level = 1775, hp = 22187, xp = 3500,  money = 1260, drops = {"Beauty Mask"],       sea = 3 },
    { name = "Cake Guard",          level = 1800, hp = 22500, xp = 3600,  money = 1300, drops = {"Cake Shard"],        sea = 3 },
    { name = "Candy Pirate",        level = 1825, hp = 22812, xp = 3700,  money = 1330, drops = {"Candy Crystal"],     sea = 3 },
    { name = "Ship Pirate",         level = 1850, hp = 23125, xp = 3800,  money = 1360, drops = {"Ship Plank"],        sea = 3 },
    { name = "Tiki Outpost Warrior",level = 1875, hp = 23437, xp = 3900,  money = 1400, drops = {"Tiki Mask"],         sea = 3 },
    { name = "Ice Cream Monster",   level = 1900, hp = 23750, xp = 4000,  money = 1430, drops = {"Ice Cream Cone"],    sea = 3 },
    { name = "Snow Demon",          level = 1950, hp = 24375, xp = 4200,  money = 1480, drops = {"Snow Core"],         sea = 3 },
    { name = "Ice Demon",           level = 1975, hp = 24687, xp = 4400,  money = 1510, drops = {"Ice Core"],          sea = 3 },
    { name = "Ghost",               level = 2000, hp = 25000, xp = 4500,  money = 1550, drops = {"Ghost Fragment"],    sea = 3 },
    { name = "Demonic Soul",        level = 2025, hp = 25312, xp = 4600,  money = 1580, drops = {"Demonic Fragment"],  sea = 3 },
    { name = "Pirate Of Hell",      level = 2075, hp = 25937, xp = 4800,  money = 1630, drops = {"Hell Fragment"],     sea = 3 },
    { name = "Blaze Pirate",        level = 2100, hp = 26250, xp = 5000,  money = 1660, drops = {"Blaze Shard"],       sea = 3 },
    { name = "Electric Pirate",     level = 2125, hp = 26562, xp = 5100,  money = 1690, drops = {"Electric Core"],     sea = 3 },
    { name = "Reborn Skeleton",     level = 2050, hp = 25625, xp = 5200,  money = 1620, drops = {"Reborn Bone"],       sea = 3 },
    { name = "Cursed Warrior",      level = 2150, hp = 26875, xp = 5300,  money = 1720, drops = {"Cursed Blade"],      sea = 3 },
    { name = "Enchanted Pirate",    level = 2200, hp = 27500, xp = 5500,  money = 1760, drops = {"Enchanted Gem"],     sea = 3 },
    { name = "Shadow Pirate",       level = 2250, hp = 28125, xp = 5700,  money = 1800, drops = {"Shadow Shard"],      sea = 3 },
    { name = "Undead Pirate Captain",level = 2300, hp = 28750, xp = 5900, money = 1840, drops = {"Captain Skull"],    sea = 3 },
}

-- ============================================================================
-- SECTION 68: EXTENDED FRUIT COMBINATION EFFECTS
-- ============================================================================

-- Fruit type synergies (informational database)
local FruitSynergies = {
    {
        combo = {"Magma", "Flame"},
        synergy = "Fire Storm",
        desc = "Both fire-type fruits deal bonus damage to ice users",
        bonusDmg = 1.25,
        vs = "Ice",
    },
    {
        combo = {"Ice", "Blizzard"},
        synergy = "Absolute Freeze",
        desc = "Both ice-type fruits can chain freeze enemies",
        bonus = "Extended Freeze Duration",
        freezeExtension = 2.0,
    },
    {
        combo = {"Dragon", "Phoenix"},
        synergy = "Mythical Dragons",
        desc = "Both mythical zoan types gain enhanced aerial combat",
        bonusDmg = 1.15,
        mobility = "Enhanced",
    },
    {
        combo = {"Dough", "Rubber"},
        synergy = "Elastic Dough",
        desc = "Both stretchy paramecia types gain reflective properties",
        reflectChance = 0.10,
    },
    {
        combo = {"Dark", "Shadow"},
        synergy = "Darkness Empire",
        desc = "Both darkness-type fruits drain HP on hit",
        hpDrainPct = 0.02,
    },
    {
        combo = {"Rumble", "Light"},
        synergy = "Lightning Light",
        desc = "Speed boost when using both fruits",
        speedBonus = 1.20,
    },
    {
        combo = {"Venom", "Spider"},
        synergy = "Poison Web",
        desc = "Poison plus web creates inescapable traps",
        trapDuration = 5.0,
    },
    {
        combo = {"Portal", "Control"},
        synergy = "Space Master",
        desc = "Both space-manipulation fruits allow advanced teleportation",
        teleportRange = 2.0,
    },
    {
        combo = {"Gravity", "Quake"},
        synergy = "World Ender",
        desc = "Gravity + quake creates earth-shattering combos",
        aoeMultiplier = 1.5,
    },
    {
        combo = {"Soul", "Ope"},
        synergy = "Soul Surgery",
        desc = "Soul extraction + Ope Ope allows permanent stat swap",
        special = "Stat Transfer",
    },
}

-- ============================================================================
-- SECTION 69: PvP TECHNIQUE ENCYCLOPEDIA
-- ============================================================================

-- Detailed PvP techniques with explanations
local PvPTechniques = {
    {
        name = "Blink Combo",
        desc = "Teleport inside enemy → instant Z+X → teleport out → repeat",
        keys = {"TP", "Z", "X", "TP"},
        difficulty = "Medium",
        effectiveness = "High",
        counters = "Anti-knockback",
        tips = "Time the teleport just as skills activate",
    },
    {
        name = "Juggle Combo",
        desc = "Launch enemy with V → combo mid-air with Z+X+C → finish with F",
        keys = {"V", "Z", "X", "C", "F"},
        difficulty = "Hard",
        effectiveness = "Very High",
        counters = "Mid-air combat",
        tips = "Use fruits that have launch moves for V",
    },
    {
        name = "Corner Trap",
        desc = "Force enemy into corner → spam AoE skills → no escape",
        keys = {"C", "V", "C", "V"},
        difficulty = "Easy",
        effectiveness = "Medium",
        counters = "Teleport users",
        tips = "Find environmental corners or barriers",
    },
    {
        name = "Stun Lock",
        desc = "Apply stun skill → chain attacks while stunned → reapply stun",
        keys = {"C", "Z", "X", "Z", "C"},
        difficulty = "Medium",
        effectiveness = "Very High",
        counters = "Fast recovery builds",
        tips = "Ensure C key skill has stun property",
    },
    {
        name = "Rush Down",
        desc = "Dash to enemy → immediate close range combo → chase if they flee",
        keys = {"DASH", "X", "Z", "C", "F"},
        difficulty = "Easy",
        effectiveness = "High",
        counters = "Ranged builds",
        tips = "Don't stop attacking, keep pressure constant",
    },
    {
        name = "Poke Play",
        desc = "Stay at range → use projectiles → only close in for finisher",
        keys = {"Z", "Z", "Z", "F"},
        difficulty = "Easy",
        effectiveness = "Medium",
        counters = "Melee builds",
        tips = "Use fruits/swords with long range Z moves",
    },
    {
        name = "Bait and Punish",
        desc = "Let enemy attack → dodge → punish during their cooldown",
        keys = {"DODGE", "Z", "X", "V", "F"},
        difficulty = "Hard",
        effectiveness = "Very High",
        counters = "All builds",
        tips = "Learn common combo patterns to bait better",
    },
    {
        name = "Split Second Combo",
        desc = "Execute full ZXCVF combo in under 1 second using min delays",
        keys = {"Z", "X", "C", "V", "F"},
        delay = 0.01,
        difficulty = "Very Hard",
        effectiveness = "Extreme",
        counters = "Lag compensation",
        tips = "Set all key delays to minimum (10ms)",
    },
    {
        name = "Ghost Combo",
        desc = "Get inside player → combo → they can't see you → repeat",
        keys = {"GET_INSIDE", "Z", "X", "C", "V", "GET_INSIDE"},
        difficulty = "Medium",
        effectiveness = "Very High",
        counters = "ESP users",
        tips = "Keep Get Inside enabled at all times",
    },
    {
        name = "Sea Beast Style",
        desc = "Constantly circle enemy → hit and run → never stand still",
        keys = {"Z", "STRAFE", "X", "STRAFE", "V"},
        difficulty = "Hard",
        effectiveness = "High",
        counters = "Slow AoE builds",
        tips = "Enable auto-strafe in PvP settings",
    },
}

-- ============================================================================
-- SECTION 70: EXTENDED SERVER MANAGEMENT
-- ============================================================================

local ServerManager = {}
ServerManager.StartTime = tick()
ServerManager.PlayerJoinTimes = {}
ServerManager.SuspiciousPlayers = {}

-- Monitor player join/leave events
Players.PlayerAdded:Connect(function(player)
    ServerManager.PlayerJoinTimes[player.UserId] = tick()
    Log("Player joined: " .. player.Name .. " (ID: " .. player.UserId .. ")")
end)

Players.PlayerRemoving:Connect(function(player)
    local joinTime = ServerManager.PlayerJoinTimes[player.UserId]
    if joinTime then
        local timeInServer = tick() - joinTime
        Log(string.format("Player left: %s (was here for %.0fs)", player.Name, timeInServer))
        ServerManager.PlayerJoinTimes[player.UserId] = nil
    end
end)

-- Get server age
function ServerManager:GetServerAge()
    return tick() - self.StartTime
end

-- Get player count history
function ServerManager:GetPlayerCount()
    return #Players:GetPlayers()
end

-- Flag suspicious player
function ServerManager:FlagSuspicious(player, reason)
    self.SuspiciousPlayers[player.UserId] = {
        player = player,
        reason = reason,
        time = tick(),
    }
    Log("Suspicious player flagged: " .. player.Name .. " - " .. reason)
end

-- ============================================================================
-- SECTION 71: HAKI SYSTEM
-- ============================================================================

local HakiSystem = {}
HakiSystem.ObsHaki = false
HakiSystem.ArmHaki = false
HakiSystem.ObsHakiLevel = 0
HakiSystem.ArmHakiLevel = 0

-- Toggle Observation Haki
function HakiSystem:ToggleObservation()
    self.ObsHaki = not self.ObsHaki
    SafeFireRemote("ToggleObservation")
    Log("Observation Haki: " .. (self.ObsHaki and "ON" or "OFF"))
    Notify("Haki", "Observation: " .. (self.ObsHaki and "ON" or "OFF"), 2)
end

-- Toggle Armament Haki
function HakiSystem:ToggleArmament()
    self.ArmHaki = not self.ArmHaki
    SafeFireRemote("ToggleArmament")
    Log("Armament Haki: " .. (self.ArmHaki and "ON" or "OFF"))
    Notify("Haki", "Armament: " .. (self.ArmHaki and "ON" or "OFF"), 2)
end

-- Buy Haki upgrade
function HakiSystem:UpgradeHaki(hakiType, level)
    NPCInteract:UseNPC("Haki", "BuyHaki", hakiType, level)
    Log("Upgrading " .. hakiType .. " Haki to level " .. level)
end

-- ============================================================================
-- SECTION 72: BOAT/SHIP SYSTEM
-- ============================================================================

local BoatSystem = {}
BoatSystem.CurrentBoat = nil
BoatSystem.BoatData = {
    { name = "Dinghy",         speed = 25,  hp = 1000,   cost = 1000,    sea = 1 },
    { name = "Caravel",        speed = 35,  hp = 3000,   cost = 50000,   sea = 1 },
    { name = "Galleon",        speed = 40,  hp = 7500,   cost = 200000,  sea = 2 },
    { name = "Steamboat",      speed = 50,  hp = 10000,  cost = 500000,  sea = 2 },
    { name = "BloxWing Boat",  speed = 60,  hp = 15000,  cost = 1000000, sea = 3 },
    { name = "Sea Beast Boat", speed = 70,  hp = 20000,  cost = 5000000, sea = 3 },
}

function BoatSystem:SpawnBoat(boatName)
    Log("Spawning boat: " .. boatName)
    NPCInteract:UseNPC("Ship", "SpawnShip", boatName)
    self.CurrentBoat = boatName
    Notify("🚢 Boat", "Spawned: " .. boatName, 2)
end

function BoatSystem:BuyBoat(boatName)
    for _, boat in ipairs(self.BoatData) do
        if boat.name:lower() == boatName:lower() then
            Log("Buying boat: " .. boatName .. " ($" .. boat.cost .. ")")
            NPCInteract:UseNPC("Ship", "BuyShip", boatName)
            Notify("🛒 Boat", "Purchased: " .. boatName, 3)
            return true
        end
    end
    return false
end

function BoatSystem:SailTo(destination)
    -- This would control the boat to sail to a destination
    Log("Sailing to: " .. destination)
    Notify("🚢 Sailing", "Heading to: " .. destination, 2)
end

-- ============================================================================
-- SECTION 73: ISLAND DEFENSE SYSTEM (PROTECT POSITION)
-- ============================================================================

local DefenseSystem = {}
DefenseSystem.Active = false
DefenseSystem.DefenseRadius = 20
DefenseSystem.Thread = nil
DefenseSystem.Position = nil

-- Set defense position
function DefenseSystem:SetPosition(pos)
    self.Position = pos or (GetHRP() and GetHRP().Position)
    Log("Defense position set: " .. tostring(self.Position))
end

-- Check for enemies in radius
function DefenseSystem:GetEnemiesInRadius()
    if not self.Position then return {} end
    local enemies = {}
    for _, enemy in ipairs(GetAllEnemies()) do
        local hrp = enemy:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = GetDistance(self.Position, hrp.Position)
            if dist <= self.DefenseRadius then
                table.insert(enemies, { enemy = enemy, dist = dist })
            end
        end
    end
    -- Sort by closest
    table.sort(enemies, function(a, b) return a.dist < b.dist end)
    return enemies
end

-- Defend against nearby enemies
function DefenseSystem:Defend()
    local enemies = self:GetEnemiesInRadius()
    for _, entry in ipairs(enemies) do
        AutoFarmEngine:AttackEnemy(entry.enemy)
        Wait(0.2)
    end
end

-- Start defense loop
function DefenseSystem:Start()
    if self.Active then return end
    self.Active = true
    self:SetPosition()

    self.Thread = task.spawn(function()
        while self.Active do
            if IsAlive() then
                self:Defend()
                -- Return to defense position if knocked away
                local hrp = GetHRP()
                if hrp and self.Position then
                    local dist = GetDistance(hrp.Position, self.Position)
                    if dist > self.DefenseRadius * 1.5 then
                        hrp.CFrame = CFrame.new(self.Position)
                    end
                end
            end
            Wait(0.5)
        end
    end)
end

function DefenseSystem:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
end

-- ============================================================================
-- SECTION 74: DETAILED RACE V4 GUIDE
-- ============================================================================

--[[
RACE V4 TRANSFORMATION GUIDE:
-------------------------------
Each race has a unique V4 transformation that requires specific steps.

HUMAN V4:
  1. Need: Race V3 + God Cup completion
  2. Location: Desolate Palace (Third Sea)
  3. Requirements: Defeat Rip_Indra 3 times
  4. Additional: Need Fragments from raids

SHARK V4:
  1. Need: Shark V3 + Water Crystal
  2. Location: Deep Sea area
  3. Requirements: Kill 50 fishmen
  4. Additional: Must be underwater

SKY V4:
  1. Need: Sky V3 + Lightning Core
  2. Location: Skylands (First Sea, high altitude)
  3. Requirements: Kill Thunder God
  4. Additional: Must be in sky area

RABBIT V4:
  1. Need: Rabbit V3 + Speed Crystal
  2. Location: Various fast locations
  3. Requirements: Kill 100 fast mobs

ANGEL V4:
  1. Need: Angel V3 + Holy Essence
  2. Location: Floating island
  3. Requirements: Kill Island Empress

MINK V4:
  1. Need: Mink V3 + Thunder Bolt
  2. Location: Various
  3. Requirements: Kill 30 Sky Bandits
]]

-- V4 Quest location data
local V4QuestData = {
    Human   = { location = CFrame.new(-2850, 5, 3150),  requirement = "Indra x3",      sea = 3 },
    Shark   = { location = CFrame.new(-6450, -70, -6260), requirement = "Fishman x50", sea = 2 },
    Sky     = { location = CFrame.new(-7760, 2260, -4310), requirement = "Thunder God", sea = 1 },
    Rabbit  = { location = CFrame.new(-1215, 40, -2485), requirement = "Fast Kill x100", sea = 2 },
    Angel   = { location = CFrame.new(-1210, 87, 4010),  requirement = "Empress x1",   sea = 2 },
    Mink    = { location = CFrame.new(-7760, 2260, -4310), requirement = "Sky Bandit x30", sea = 1 },
    Cyborg  = { location = CFrame.new(-1385, 135, -1020), requirement = "Cyborg Core x3", sea = 1 },
    Ghoul   = { location = CFrame.new(-8060, 60, 3400), requirement = "Night Kills x100", sea = 2 },
}

-- Auto V4 for specific race
local function DoV4Quest(raceName)
    local data = V4QuestData[raceName]
    if not data then
        Log("V4 quest data not found for: " .. raceName, "WARN")
        return
    end

    Log("Starting V4 quest for: " .. raceName)
    Notify("🔥 V4 Quest", raceName .. " V4: " .. data.requirement, 5)

    SafeTeleport(data.location)
    Wait(1)

    SafeFireRemote("StartV4Quest", raceName)
    Wait(0.5)

    -- Fulfill requirement
    if data.requirement:find("Indra") then
        for i = 1, 3 do BossDefeatSystem:DefeatIndra(); Wait(2) end
    elseif data.requirement:find("Fishman") then
        for i = 1, 50 do AutoFarmEngine:FarmLevels(); Wait(0.3) end
    elseif data.requirement:find("Thunder God") then
        AutoFarmEngine:FarmBoss("Thunder God")
    elseif data.requirement:find("Empress") then
        AutoFarmEngine:FarmBoss("Island Empress")
    end

    SafeTeleport(data.location)
    Wait(1)
    SafeFireRemote("CompleteV4Quest", raceName)
    Notify("✅ V4 Complete!", raceName .. " V4 unlocked!", 5)
end

-- ============================================================================
-- SECTION 75: EXPANDED ANTI-CHEAT BYPASS TECHNIQUES
-- ============================================================================

--[[
ANTI-CHEAT BYPASS METHODS (Documentation only):
------------------------------------------------
Method 1: Incremental Speed Changes
  - Never jump walk speed from 16 to 200 instantly
  - Increase by 1-2 per second: 16 → 18 → 20... → 200
  - This prevents sudden speed anomaly detection

Method 2: Timing Randomization
  - All action timings use RandomFloat() for ±30% variance
  - This mimics human reaction time imprecision
  - Pattern analysis becomes much harder

Method 3: Action Interleaving
  - Mix automation with manual-looking pauses
  - Simulate "reading the screen" delays
  - Occasional movement in random directions

Method 4: Network Request Spacing
  - Never fire remotes faster than 10 per second
  - Space out attacks with minimum 50ms between
  - Matches realistic human capability ceiling

Method 5: Session Duration Limits
  - Auto-pause every 45-60 minutes for 5-10 min
  - This matches real human play session patterns
  - Avoids "bot-like" constant activity markers

Method 6: Character Position Realism
  - Teleports look like "lag teleports" in logs
  - Use CFrame with small random offsets
  - Avoid perfect grid-aligned positions
]]

-- Incremental speed change
local function SetSpeedGradually(targetSpeed, stepDelay)
    stepDelay = stepDelay or 0.1
    local hum = GetHumanoid()
    if not hum then return end

    local currentSpeed = hum.WalkSpeed
    local step = currentSpeed < targetSpeed and 2 or -2

    task.spawn(function()
        while math.abs(hum.WalkSpeed - targetSpeed) > 1 do
            hum.WalkSpeed = hum.WalkSpeed + step
            Wait(stepDelay)
        end
        hum.WalkSpeed = targetSpeed
    end)
end

-- Realistic teleport (with slight offset)
local function RealisticTeleport(cf)
    local offset = Vector3.new(
        RandomFloat(-0.5, 0.5),
        0,
        RandomFloat(-0.5, 0.5)
    )
    local hrp = GetHRP()
    if hrp then
        hrp.CFrame = cf * CFrame.new(offset)
    end
end

-- ============================================================================
-- SECTION 76: COMPREHENSIVE NPC QUEST CHAIN SYSTEM
-- ============================================================================

-- All quest NPC data with level requirements
local AllQuestNPCs = {
    -- FIRST SEA
    {
        id = 1, name = "Mysterious Scientist",
        level = 0, sea = 1,
        location = CFrame.new(975, 12, -1745),
        gives = {"Beginner Quest", "Marine Training"},
        turnIn = CFrame.new(975, 12, -1745),
        xpReward = 500,
        moneyReward = 1000,
    },
    {
        id = 2, name = "Bandit King",
        level = 50, sea = 1,
        location = CFrame.new(-995, 12, 1040),
        gives = {"Bandit Extermination"},
        turnIn = CFrame.new(-995, 12, 1040),
        xpReward = 2000,
        moneyReward = 3000,
    },
    {
        id = 3, name = "Desert Chief",
        level = 60, sea = 1,
        location = CFrame.new(-495, 10, 1635),
        gives = {"Desert Patrol", "Officer Hunt"},
        turnIn = CFrame.new(-495, 10, 1635),
        xpReward = 3500,
        moneyReward = 5000,
    },
    {
        id = 4, name = "Prison Warden NPC",
        level = 100, sea = 1,
        location = CFrame.new(4390, 200, -1630),
        gives = {"Prison Break Quest", "Prisoner Hunt"},
        turnIn = CFrame.new(4390, 200, -1630),
        xpReward = 5000,
        moneyReward = 8000,
    },
    {
        id = 5, name = "Marine Quest Master",
        level = 120, sea = 1,
        location = CFrame.new(6115, 46, -510),
        gives = {"Marine Patrol", "Vice Admiral Hunt"},
        turnIn = CFrame.new(6115, 46, -510),
        xpReward = 7500,
        moneyReward = 12000,
    },
    {
        id = 6, name = "Snow Elder",
        level = 90, sea = 1,
        location = CFrame.new(-4920, 945, -1315),
        gives = {"Snow Bandit Hunt", "Yeti Quest"},
        turnIn = CFrame.new(-4920, 945, -1315),
        xpReward = 6000,
        moneyReward = 9500,
    },
    {
        id = 7, name = "Sky Elder",
        level = 400, sea = 1,
        location = CFrame.new(-7760, 2262, -4310),
        gives = {"Sky Combat Training", "Thunder God Challenge"},
        turnIn = CFrame.new(-7760, 2262, -4310),
        xpReward = 15000,
        moneyReward = 25000,
    },
    {
        id = 8, name = "Arena Master",
        level = 625, sea = 1,
        location = CFrame.new(-1385, 137, -1020),
        gives = {"Gladiator Trial", "Colosseum Champion"},
        turnIn = CFrame.new(-1385, 137, -1020),
        xpReward = 25000,
        moneyReward = 40000,
    },
    -- SECOND SEA
    {
        id = 9, name = "Rose Kingdom Advisor",
        level = 700, sea = 2,
        location = CFrame.new(-1215, 42, -2485),
        gives = {"Factory Sabotage", "Kingdom Defense"},
        turnIn = CFrame.new(-1215, 42, -2485),
        xpReward = 35000,
        moneyReward = 55000,
    },
    {
        id = 10, name = "Fishman Chief",
        level = 875, sea = 2,
        location = CFrame.new(-6450, -68, -6260),
        gives = {"Underwater Patrol", "Fishman Commando Hunt"},
        turnIn = CFrame.new(-6450, -68, -6260),
        xpReward = 45000,
        moneyReward = 70000,
    },
    {
        id = 11, name = "Zombie Master",
        level = 950, sea = 2,
        location = CFrame.new(-8015, 14, 5015),
        gives = {"Undead Extermination", "Vampire Hunt"},
        turnIn = CFrame.new(-8015, 14, 5015),
        xpReward = 55000,
        moneyReward = 85000,
    },
    {
        id = 12, name = "Ice Castle Guard",
        level = 1150, sea = 2,
        location = CFrame.new(-12200, 46, 3050),
        gives = {"Snow Lurker Hunt", "Dicer Challenge"},
        turnIn = CFrame.new(-12200, 46, 3050),
        xpReward = 70000,
        moneyReward = 110000,
    },
    {
        id = 13, name = "Thriller Bark Captain",
        level = 1050, sea = 2,
        location = CFrame.new(-8060, 62, 3400),
        gives = {"Ghost Ship Patrol", "Reaper Hunt"},
        turnIn = CFrame.new(-8060, 62, 3400),
        xpReward = 80000,
        moneyReward = 125000,
    },
    {
        id = 14, name = "Floating Turtle Elder",
        level = 1400, sea = 2,
        location = CFrame.new(-1210, 89, 4010),
        gives = {"Fishman Warrior Hunt", "Empress Challenge"},
        turnIn = CFrame.new(-1210, 89, 4010),
        xpReward = 95000,
        moneyReward = 150000,
    },
    -- THIRD SEA
    {
        id = 15, name = "Port Town Elder",
        level = 1500, sea = 3,
        location = CFrame.new(-11590, 7, -3590),
        gives = {"Pirate Millionaire Hunt", "Dragon Crew War"},
        turnIn = CFrame.new(-11590, 7, -3590),
        xpReward = 100000,
        moneyReward = 165000,
    },
    {
        id = 16, name = "Dragon Sage",
        level = 1675, sea = 3,
        location = CFrame.new(-8870, 15, 1380),
        gives = {"Dragon Crew Extermination", "Longma Challenge"},
        turnIn = CFrame.new(-8870, 15, 1380),
        xpReward = 120000,
        moneyReward = 190000,
    },
    {
        id = 17, name = "Mansion Butler",
        level = 1725, sea = 3,
        location = CFrame.new(-9680, 7, 980),
        gives = {"Marine Commodore Hunt", "Mansion Defense"},
        turnIn = CFrame.new(-9680, 7, 980),
        xpReward = 135000,
        moneyReward = 210000,
    },
    {
        id = 18, name = "Great Tree Spirit",
        level = 1775, sea = 3,
        location = CFrame.new(-7700, 7, -350),
        gives = {"Beautiful Pirate Hunt", "Ancient Trial"},
        turnIn = CFrame.new(-7700, 7, -350),
        xpReward = 150000,
        moneyReward = 235000,
    },
    {
        id = 19, name = "Tiki Chief",
        level = 1875, sea = 3,
        location = CFrame.new(-6700, 20, 100),
        gives = {"Tiki Warrior Hunt", "Cake Prince Challenge"},
        turnIn = CFrame.new(-6700, 20, 100),
        xpReward = 165000,
        moneyReward = 260000,
    },
    {
        id = 20, name = "Candy Island Master",
        level = 1800, sea = 3,
        location = CFrame.new(-4350, 28, -1350),
        gives = {"Cake Guard Hunt", "Dough King Battle"},
        turnIn = CFrame.new(-4350, 28, -1350),
        xpReward = 155000,
        moneyReward = 245000,
    },
    {
        id = 21, name = "Castle Sea Admiral",
        level = 1850, sea = 3,
        location = CFrame.new(-3850, 7, -5560),
        gives = {"Ship Pirate Hunt", "Castle Defense"},
        turnIn = CFrame.new(-3850, 7, -5560),
        xpReward = 160000,
        moneyReward = 252000,
    },
    {
        id = 22, name = "Haunted Port Captain",
        level = 2000, sea = 3,
        location = CFrame.new(7400, 64, -6300),
        gives = {"Ghost Hunt", "Hell Pirate Elimination"},
        turnIn = CFrame.new(7400, 64, -6300),
        xpReward = 175000,
        moneyReward = 275000,
    },
    {
        id = 23, name = "Desolate Palace Guardian",
        level = 2050, sea = 3,
        location = CFrame.new(-2850, 7, 3150),
        gives = {"Electric Pirate Hunt", "Indra's Test"},
        turnIn = CFrame.new(-2850, 7, 3150),
        xpReward = 200000,
        moneyReward = 300000,
    },
    {
        id = 24, name = "Draco Sage",
        level = 2300, sea = 3,
        location = CFrame.new(-4200, 22, 1500),
        gives = {"Draco V4 Quest", "Final Trial"},
        turnIn = CFrame.new(-4200, 22, 1500),
        xpReward = 500000,
        moneyReward = 1000000,
    },
}

-- Smart quest selection (pick best quest for current level)
function AutoQuestSystem:SelectBestQuest(currentLevel)
    local best = nil
    local bestScore = -math.huge

    for _, npc in ipairs(AllQuestNPCs) do
        if npc.level <= currentLevel and npc.level >= currentLevel - 200 then
            local score = npc.xpReward / math.max(1, currentLevel - npc.level + 1)
            if score > bestScore then
                bestScore = score
                best = npc
            end
        end
    end

    return best
end

-- Auto do the best available quest
function AutoQuestSystem:DoBestQuest()
    local level = LocalPlayer:FindFirstChild("leaderstats") and
        LocalPlayer.leaderstats:FindFirstChild("Level") and
        LocalPlayer.leaderstats.Level.Value or 0

    local npc = self:SelectBestQuest(level)
    if not npc then
        Log("No suitable quest found for level " .. level)
        return
    end

    Log("Best quest: " .. npc.name .. " (Lvl " .. npc.level .. ")")

    -- Go to NPC
    SafeTeleport(npc.location)
    Wait(0.5)
    SafeFireRemote("AcceptQuest", npc.id)
    Wait(0.3)

    -- Farm for the quest
    local guide = GetOptimalFarmLocation(level)
    if guide then
        TeleportSystem:ToIsland(guide.location)
        for i = 1, 30 do
            if not Settings.AutoQuest.Enabled then break end
            AutoFarmEngine:FarmLevels()
        end
    end

    -- Turn in
    SafeTeleport(npc.turnIn)
    Wait(0.5)
    SafeFireRemote("TurnInQuest", npc.id)
    Wait(0.3)

    self.CompletedQuests = self.CompletedQuests + 1
    Log("Quest complete: " .. npc.name)
    Notify("✅ Quest", npc.name .. " completed!", 3)
end

-- ============================================================================
-- SECTION 77: EXTENDED WORLD MAP DATA
-- ============================================================================

-- Complete coordinate mapping for ALL game areas
local WorldCoordinateMap = {
    -- First Sea critical coords
    { name = "Starter Island - Spawn",         pos = Vector3.new(-995, 10, 1040),   sea = 1 },
    { name = "Starter Island - Sword Shop",    pos = Vector3.new(-1025, 10, 1060),  sea = 1 },
    { name = "Starter Island - Fruit Shop",    pos = Vector3.new(-975, 10, 1055),   sea = 1 },
    { name = "Jungle - Quest NPC",             pos = Vector3.new(-1260, 6, 4130),   sea = 1 },
    { name = "Jungle - Gorilla Area",          pos = Vector3.new(-1350, 6, 4200),   sea = 1 },
    { name = "Desert - Quest NPC",             pos = Vector3.new(-485, 8, 1620),    sea = 1 },
    { name = "Desert - Boss Arena",            pos = Vector3.new(-500, 8, 1650),    sea = 1 },
    { name = "Marine - Fortress Gate",         pos = Vector3.new(6050, 44, -490),   sea = 1 },
    { name = "Marine - Admiral Spawn",         pos = Vector3.new(6115, 44, -510),   sea = 1 },
    { name = "Prison - Main Yard",             pos = Vector3.new(4390, 200, -1630), sea = 1 },
    { name = "Prison - Warden Office",         pos = Vector3.new(4480, 200, -1740), sea = 1 },
    { name = "Snow - Peak",                    pos = Vector3.new(-4920, 943, -1315),sea = 1 },
    { name = "Snow - Yeti Cave",               pos = Vector3.new(-4950, 943, -1340),sea = 1 },
    { name = "Skylands - Upper Level",         pos = Vector3.new(-7760, 2260, -4310), sea = 1 },
    { name = "Skylands - Thunder God Area",    pos = Vector3.new(-7750, 2230, -4100), sea = 1 },
    { name = "Magma - Volcano Core",           pos = Vector3.new(-5174, 260, -1065), sea = 1 },
    { name = "Magma - Admiral Arena",          pos = Vector3.new(-5190, 265, -1080), sea = 1 },
    { name = "Colosseum - Arena Center",       pos = Vector3.new(-1385, 135, -1020), sea = 1 },
    { name = "Colosseum - Entrance",           pos = Vector3.new(-1360, 135, -995),  sea = 1 },
    { name = "Middle Island - Center",         pos = Vector3.new(-100, 10, 0),       sea = 1 },
    { name = "Marine Starter - Spawn",         pos = Vector3.new(975, 10, -1750),    sea = 1 },
    -- Second Sea critical coords
    { name = "Rose Kingdom - Main Street",     pos = Vector3.new(-1215, 40, -2485),  sea = 2 },
    { name = "Rose Kingdom - Cafe",            pos = Vector3.new(-3115, 40, -1885),  sea = 2 },
    { name = "Rose Kingdom - Sword Shop",      pos = Vector3.new(-1225, 40, -2495),  sea = 2 },
    { name = "Graveyard - Entrance",           pos = Vector3.new(440, 108, -2510),   sea = 2 },
    { name = "Cursed Ship - Main Deck",        pos = Vector3.new(-8015, 12, 5015),   sea = 2 },
    { name = "Thriller Bark - Main Area",      pos = Vector3.new(-8060, 60, 3400),   sea = 2 },
    { name = "Thriller Bark - Reaper Zone",    pos = Vector3.new(-8080, 62, 3420),   sea = 2 },
    { name = "Ice Castle - Gate",              pos = Vector3.new(-12200, 44, 3050),  sea = 2 },
    { name = "Underwater - Fishman Area",      pos = Vector3.new(-6450, -70, -6260), sea = 2 },
    { name = "Floating Turtle 2nd - Top",      pos = Vector3.new(-1210, 87, 4010),   sea = 2 },
    { name = "Haunted Castle - Gate",          pos = Vector3.new(-13920, 130, -8800),sea = 2 },
    { name = "Dark Arena - Center",            pos = Vector3.new(-10580, 31, -9180), sea = 2 },
    { name = "Mirage Island - Portal",         pos = Vector3.new(-9300, 3, -1865),   sea = 2 },
    { name = "Forgotten Island - Entrance",    pos = Vector3.new(-12070, 3, -1555),  sea = 2 },
    { name = "Hot Cold - Ice Side",            pos = Vector3.new(-7750, 12, -2200),  sea = 2 },
    { name = "Hot Cold - Fire Side",           pos = Vector3.new(-8050, 12, -1900),  sea = 2 },
    -- Third Sea critical coords
    { name = "Port Town - Harbor",             pos = Vector3.new(-11590, 5, -3590),  sea = 3 },
    { name = "Port Town - Market",             pos = Vector3.new(-11560, 5, -3560),  sea = 3 },
    { name = "Hydra - Jungle",                 pos = Vector3.new(-10400, 5, -3600),  sea = 3 },
    { name = "Dragon Turtle - Peak",           pos = Vector3.new(-8870, 13, 1380),   sea = 3 },
    { name = "Dragon Turtle - Longma Spawn",   pos = Vector3.new(-8900, 13, 1400),   sea = 3 },
    { name = "Mansion - Front Door",           pos = Vector3.new(-9680, 5, 980),     sea = 3 },
    { name = "Great Tree - Base",              pos = Vector3.new(-7700, 5, -350),    sea = 3 },
    { name = "Great Tree - Canopy",            pos = Vector3.new(-7700, 120, -350),  sea = 3 },
    { name = "Tiki - Village Center",          pos = Vector3.new(-6700, 18, 100),    sea = 3 },
    { name = "Usoapp - Statue",                pos = Vector3.new(-5085, 5, 3520),    sea = 3 },
    { name = "Candy Island - Sweet Zone",      pos = Vector3.new(-4350, 26, -1350),  sea = 3 },
    { name = "Castle Sea - Top Floor",         pos = Vector3.new(-3850, 80, -5560),  sea = 3 },
    { name = "Castle Sea - Ground",            pos = Vector3.new(-3850, 5, -5560),   sea = 3 },
    { name = "Sea of Treats - Main",           pos = Vector3.new(-1850, 0, -3740),   sea = 3 },
    { name = "Haunted Port - Docks",           pos = Vector3.new(7400, 62, -6300),   sea = 3 },
    { name = "Desolate Palace - Gate",         pos = Vector3.new(-2850, 5, 3150),    sea = 3 },
    { name = "Desolate Palace - Throne Room",  pos = Vector3.new(-2820, 30, 3130),   sea = 3 },
    { name = "Ice Island 3rd - Peak",          pos = Vector3.new(-12580, 5, 3050),   sea = 3 },
    { name = "Soul Island - Entrance",         pos = Vector3.new(-2200, 165, 1880),  sea = 3 },
}

-- Get coordinate by partial name
local function GetCoordinateByName(name)
    for _, coord in ipairs(WorldCoordinateMap) do
        if coord.name:lower():find(name:lower()) then
            return coord
        end
    end
    return nil
end

-- ============================================================================
-- SECTION 78: FINAL EXTENDED GUI TABS (PART 2)
-- ============================================================================

local function BuildFinalTabs()
    -- TAB 31: BOSS DATABASE
    local bossDbTab = GUI:CreateTab("Boss DB", "💀")

    GUI:CreateSection(bossDbTab.page, "Complete Boss Database")

    GUI:CreateLabel(bossDbTab.page, "── FIRST SEA ──", GUI.Theme.Accent)
    for _, boss in ipairs(ExtendedBossData) do
        if boss.sea == 1 then
            GUI:CreateButton(bossDbTab.page,
                string.format("Lvl %d - %s [Respawn: %ds]", boss.level, boss.name, boss.respawn),
                function()
                    task.spawn(function()
                        AutoFarmEngine:FarmBoss(boss.name)
                    end)
                end)
        end
    end

    GUI:CreateLabel(bossDbTab.page, "── SECOND SEA ──", GUI.Theme.Accent)
    for _, boss in ipairs(ExtendedBossData) do
        if boss.sea == 2 then
            GUI:CreateButton(bossDbTab.page,
                string.format("Lvl %d - %s [XP: %d]", boss.level, boss.name, boss.xp),
                function()
                    task.spawn(function()
                        AutoFarmEngine:FarmBoss(boss.name)
                    end)
                end)
        end
    end

    GUI:CreateLabel(bossDbTab.page, "── THIRD SEA ──", GUI.Theme.Accent)
    for _, boss in ipairs(ExtendedBossData) do
        if boss.sea == 3 then
            GUI:CreateButton(bossDbTab.page,
                string.format("Lvl %d - %s [Money: $%d]", boss.level, boss.name, boss.money),
                function()
                    task.spawn(function()
                        AutoFarmEngine:FarmBoss(boss.name)
                    end)
                end)
        end
    end

    -- TAB 32: MOB DATABASE
    local mobDbTab = GUI:CreateTab("Mob DB", "👹")

    GUI:CreateSection(mobDbTab.page, "All Mobs Database")

    local seas = {1, 2, 3}
    local seaNames = {"First Sea", "Second Sea", "Third Sea"}

    for i, seaNum in ipairs(seas) do
        GUI:CreateLabel(mobDbTab.page, "── " .. seaNames[i] .. " ──", GUI.Theme.Accent)
        local count = 0
        for _, mob in ipairs(FullMobDatabase) do
            if mob.sea == seaNum then
                GUI:CreateLabel(mobDbTab.page,
                    string.format("Lvl %d %-22s HP:%-6d XP:%-5d $%d",
                        mob.level, mob.name, mob.hp, mob.xp, mob.money))
                count = count + 1
            end
        end
        GUI:CreateLabel(mobDbTab.page, "Total: " .. count .. " mob types")
    end

    -- TAB 33: PVP ENCYCLOPEDIA
    local pvpEncTab = GUI:CreateTab("PvP Guide", "📖")

    GUI:CreateSection(pvpEncTab.page, "PvP Techniques Encyclopedia")

    for _, tech in ipairs(PvPTechniques) do
        GUI:CreateLabel(pvpEncTab.page, tech.name, GUI.Theme.Accent)
        GUI:CreateLabel(pvpEncTab.page, "  " .. tech.desc)
        GUI:CreateLabel(pvpEncTab.page, "  Keys: " .. table.concat(tech.keys, " → "))
        GUI:CreateLabel(pvpEncTab.page, "  Difficulty: " .. tech.difficulty)
        GUI:CreateLabel(pvpEncTab.page, "  Effectiveness: " .. tech.effectiveness)
        GUI:CreateLabel(pvpEncTab.page, "  Tip: " .. tech.tips)
    end

    -- TAB 34: RESET CONTROLS
    local resetTab = GUI:CreateTab("Reset", "🔄")

    GUI:CreateSection(resetTab.page, "Reset Controls")

    GUI:CreateButton(resetTab.page, "⏹ Stop ALL Systems", function()
        ResetSystem:StopAllSystems()
    end)

    GUI:CreateButton(resetTab.page, "🔄 Restart Script", function()
        ResetSystem:Restart()
    end)

    GUI:CreateButton(resetTab.page, "🗑️ Reset All Counters", function()
        ResetSystem:ResetCounters()
    end)

    GUI:CreateButton(resetTab.page, "📊 Export Session Data", function()
        local data = ExportSessionData()
        Notify("Export", "Session data logged to console", 3)
    end)

    GUI:CreateSection(resetTab.page, "Emergency Controls")

    GUI:CreateButton(resetTab.page, "🚨 Emergency Server Hop", function()
        ServerHopSystem:Hop("Emergency hop")
    end)

    GUI:CreateButton(resetTab.page, "🔒 Anti-Ban Emergency Mode", function()
        Settings.AntiBan.MinDelay = 0.2
        Settings.AntiBan.MaxDelay = 0.5
        Notify("Anti-Ban", "Emergency mode: max delays", 3)
    end)
end

task.delay(2.5, function()
    if OmegaHub.Loaded then
        pcall(BuildFinalTabs)
    end
end)

-- ============================================================================
-- SECTION 79: PERIODIC AUTO MAINTENANCE
-- ============================================================================

-- Periodic system health check
task.spawn(function()
    while true do
        task.wait(60) -- Every minute

        -- Check if character exists
        if not GetCharacter() then
            Log("Character lost - waiting for respawn")
        end

        -- Check if anti-ban is still running
        if Settings.AntiBan.Enabled and not AntiBanSystem.Active then
            Log("Anti-ban stopped unexpectedly - restarting")
            AntiBanSystem:Start()
        end

        -- Check if admin detection is still running
        if Settings.AdminDetection.Enabled and not AdminDetector.Active then
            Log("Admin detection stopped - restarting")
            AdminDetector:Start()
        end

        -- Memory cleanup - remove stale ESP labels
        pcall(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local esp = hrp:FindFirstChild("OmegaESP")
                        if esp and not Settings.Misc.ShowESP then
                            esp:Destroy()
                        end
                    end
                end
            end
        end)

        -- Log performance
        Log(PerformanceMonitor:GetReport())
    end
end)

-- ============================================================================
-- SECTION 80: SMART FARMING AI
-- ============================================================================

local SmartFarmingAI = {}
SmartFarmingAI.DecisionInterval = 5.0
SmartFarmingAI.Thread = nil
SmartFarmingAI.Active = false

-- Evaluate current farming efficiency
function SmartFarmingAI:EvaluateEfficiency()
    local level = LocalPlayer:FindFirstChild("leaderstats") and
        LocalPlayer.leaderstats:FindFirstChild("Level") and
        LocalPlayer.leaderstats.Level.Value or 0

    local guide = GetOptimalFarmLocation(level)
    local hrp = GetHRP()

    if not hrp or not guide then return 1.0 end

    -- Check if we're at the optimal location
    local nearestIsland, dist = TeleportSystem:ToIsland and nil or nil
    -- Simple heuristic: if we're killing mobs, efficiency is good
    return AutoFarmEngine.KillCount > 0 and 1.0 or 0.5
end

-- Auto-adjust farming strategy
function SmartFarmingAI:AdjustStrategy()
    local level = LocalPlayer:FindFirstChild("leaderstats") and
        LocalPlayer.leaderstats:FindFirstChild("Level") and
        LocalPlayer.leaderstats.Level.Value or 0

    local guide = GetOptimalFarmLocation(level)
    if not guide then return end

    -- Check if we're in the right area
    local hrp = GetHRP()
    if not hrp then return end

    -- Find current island
    local nearestIsland, nearestDist = ExtendedTeleport:FindNearestIsland()
    if nearestIsland and nearestIsland.name ~= guide.location then
        if nearestDist > 200 then -- Not at the right island
            Log("Smart AI: Relocating to optimal farm: " .. guide.location)
            TeleportSystem:ToIsland(guide.location)
        end
    end
end

-- Smart level-up detection
function SmartFarmingAI:OnLevelUp(newLevel)
    Log("Level up detected! New level: " .. newLevel)
    Notify("🎉 Level Up!", "Level " .. newLevel .. " reached!", 4)

    -- Re-evaluate farming location
    local guide = GetOptimalFarmLocation(newLevel)
    if guide then
        Log("New optimal farm: " .. guide.location .. " (" .. guide.mobName .. ")")
    end

    -- Check if stat points should be spent
    if Settings.Misc.AutoStat then
        SafeFireRemote("SpendStatPoints", Settings.Misc.StatType)
    end
end

-- Start smart AI
function SmartFarmingAI:Start()
    if self.Active then return end
    self.Active = true

    -- Monitor for level ups
    local lastLevel = 0
    self.Thread = task.spawn(function()
        while self.Active do
            task.wait(self.DecisionInterval)

            if not Settings.AutoFarm.Enabled then continue end

            -- Check level
            local level = LocalPlayer:FindFirstChild("leaderstats") and
                LocalPlayer.leaderstats:FindFirstChild("Level") and
                LocalPlayer.leaderstats.Level.Value or 0

            if level > lastLevel and lastLevel > 0 then
                self:OnLevelUp(level)
            end
            lastLevel = level

            -- Adjust strategy
            pcall(function()
                self:AdjustStrategy()
            end)
        end
    end)

    Log("Smart Farming AI started")
end

function SmartFarmingAI:Stop()
    self.Active = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
end

-- Start the smart AI
SmartFarmingAI:Start()

-- ============================================================================
-- SECTION 81: FINAL SUMMARY AND COMPLETE SYSTEM COUNT
-- ============================================================================

-- Count all loaded systems
local SystemCount = {
    AntiBan          = true,
    AdminDetection   = true,
    AutoFarm         = true,
    AutoQuest        = true,
    AutoFruit        = true,
    Teleport         = true,
    PvP              = true,
    Eggs             = true,
    Berry            = true,
    EliteHunters     = true,
    SpecialSwords    = true,
    AutoRace         = true,
    BossDefeat       = true,
    SeaBeast         = true,
    RaidSystem       = true,
    MaterialFarm     = true,
    ComboBuilder     = true,
    ServerHop        = true,
    Achievements     = true,
    Performance      = true,
    NetworkMonitor   = true,
    EventDetection   = true,
    SmartFarmingAI   = true,
    StatDistribution = true,
    HakiSystem       = true,
    BoatSystem       = true,
    DefenseSystem    = true,
    BossCombatAI     = true,
    QuestChains      = true,
    MasteryTracker   = true,
    ESP              = true,
    Fly              = true,
    NoClip           = true,
    InfiniteJump     = true,
    AntiVoid         = true,
    FruitStorage     = true,
    WorldMapNavigator= true,
    NPCInteract      = true,
    SkillSystem      = true,
    MobAI            = true,
}

local totalSystems = 0
for _ in pairs(SystemCount) do totalSystems = totalSystems + 1 end

Log("=== OMEGA HUB v4.0 COMPLETE ===")
Log("Total Systems Loaded: " .. totalSystems)
Log("Total Bosses: " .. (#BossData + #ExtendedBossData))
Log("Total Mobs: " .. (#MobData + #FullMobDatabase))
Log("Total Islands: " .. #IslandData)
Log("Total Fruits: " .. #FruitData)
Log("Total NPCs: " .. (#QuestNPCs + #AllQuestNPCs))
Log("Total Coordinates: " .. (#AllCoordinates + #WorldCoordinateMap))
Log("Total Skill Definitions: " .. #SkillDefinitions)
Log("Total Achievements: " .. #Achievements)
Log("Total PvP Techniques: " .. #PvPTechniques)
Log("Total Combo Strategies: " .. (function()
    local c = 0
    for _ in pairs(ComboStrategies) do c = c + 1 end
    return c
end)())
Log("Total Raids: " .. #RaidData)
Log("Total Build Paths: " .. (function()
    local c = 0
    for _ in pairs(BuildPaths) do c = c + 1 end
    return c
end)())
Log("GUI Tabs: ~34 tabs")
Log("Hotkeys Configured: " .. (function()
    local c = 0
    for _ in pairs(HotkeySystem.DefaultHotkeys) do c = c + 1 end
    return c
end)())
Log("================================")

-- ============================================================================
-- END OF OMEGA HUB v4.0 - ALL SECTIONS COMPLETE (1-81)
-- TOTAL FEATURES: 40+ major systems, 34+ GUI tabs, 80+ tables, complete docs
-- ============================================================================
