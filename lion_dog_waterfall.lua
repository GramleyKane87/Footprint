-- Carbon Footprint Monitoring Tool 

-- libs
local json = require("json")

-- constants
local WATER_CARBON_FOOTPRINT = 0.00553 -- kg CO2-e
local COAL_CARBON_FOOTPRINT = 0.9535  -- kg CO2-e
local GAS_CARBON_FOOTPRINT = 0.2024  -- kg CO2-e
local ELECTRICITY_CARBON_FOOTPRINT = 0.6194  -- kg CO2-e

-- config
local CONFIG_FILE_NAME = "carbon_footprint_config.json"

-- variables
local carbonFootprintData = {
    water = 0,
    coal = 0,
    gas = 0,
    electricity = 0
}

-- functions

-- load configuration
local function loadConfig()
    local file = assert(io.open(CONFIG_FILE_NAME, "r"))
    data = json.decode(file:read("*all"))
    file:close()
    return data
end

-- save configuration
local function saveConfig(data)
    local file = assert(io.open(CONFIG_FILE_NAME, "w"))
    file:write(json.encode(data))
    file:close()
end

-- calculate carbon footprint
local function calculateCarbonFootprint(type, amount)
    local carbonAmount = 0
    if type == "water" then
        carbonAmount = WATER_CARBON_FOOTPRINT * amount
    elseif type == "coal" then
        carbonAmount = COAL_CARBON_FOOTPRINT * amount
    elseif type == "gas" then
        carbonAmount = GAS_CARBON_FOOTPRINT * amount
    elseif type == "electricity" then
        carbonAmount = ELECTRICITY_CARBON_FOOTPRINT * amount
    end
    return carbonAmount
end

-- add data
local function addData(type, amount)
    carbonFootprintData[type] = carbonFootprintData[type] + calculateCarbonFootprint(type, amount)
end

-- remove data
local function removeData(type, amount)
    carbonFootprintData[type] = carbonFootprintData[type] - calculateCarbonFootprint(type, amount)
    if carbonFootprintData[type] < 0 then
        carbonFootprintData[type] = 0
    end
end

-- get carbon footprint
local function getCarbonFootprint()
    local totalCarbonFootprint = 0
    for type, amount in pairs(carbonFootprintData) do
        totalCarbonFootprint = totalCarbonFootprint + amount
    end
    return totalCarbonFootprint
end

-- init
local function init()
    local configData = loadConfig()
    carbonFootprintData = configData.carbonFootprintData
end

-- main
local function main()
    init()

    -- add data
    addData("water", 10)
    addData("coal", 5)

    -- get carbon foortprint
    local carbonFootprint = getCarbonFootprint()
    print("Total Carbon Footprint:", carbonFootprint)

    -- remove data
    removeData("coal", 3)

    -- get carbon foortprint
    local carbonFootprint = getCarbonFootprint()
    print("Total Carbon Footprint:", carbonFootprint)

    -- save configuration
    local configData = {
        carbonFootprintData = carbonFootprintData
    }
    saveConfig(configData)
end

-- execute main
main()