-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local inventoryOpen = false
local chestOpen = false
local dropOpen = false
local shopOpen = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR INVENTÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("inventory", function()
    if not inventoryOpen then
        local inventario = vRP.getInventory()
        local maxWeight = vRP.getInventoryMaxWeight()
        local weight = vRP.getInventoryWeight()
        
        if inventario then
            inventoryOpen = true
            SetNuiFocus(true, true)
            
            -- Enviar dados no formato do LD Inventory
            SendNUIMessage({
                action = "open",
                type = "inventory",
                inventory = inventario,
                maxWeight = maxWeight,
                weight = weight,
                slots = 30
            })
        end
    end
end)

RegisterKeyMapping("inventory", "Abrir inventário", "keyboard", "F2")

-----------------------------------------------------------------------------------------------------------------------------------------
-- FECHAR INVENTÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close", function(data, cb)
    inventoryOpen = false
    chestOpen = false
    dropOpen = false
    shopOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close" })
    cb("ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGAR ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take", function(data, cb)
    vSERVER.takeItem(data.item, data.amount, data.slot, data.target)
    cb("ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GUARDAR ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store", function(data, cb)
    vSERVER.storeItem(data.item, data.amount, data.slot, data.target)
    cb("ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPAR ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Drop", function(data, cb)
    vSERVER.dropItem(data.item, data.amount, data.slot)
    cb("ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ENVIAR ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Send", function(data, cb)
    vSERVER.sendItem(data.item, data.amount, data.slot)
    cb("ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- USAR ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Use", function(data, cb)
    vSERVER.useItem(data.item, data.slot, data.amount)
    cb("ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ATUALIZAR INVENTÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update", function(data, cb)
    local inventario = vRP.getInventory()
    local maxWeight = vRP.getInventoryMaxWeight()
    local weight = vRP.getInventoryWeight()
    
    SendNUIMessage({
        action = "update",
        inventory = inventario,
        maxWeight = maxWeight,
        weight = weight
    })
    cb("ok")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PESO DO INVENTÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetWeight", function(data, cb)
    local weight = vRP.getInventoryWeight()
    local maxWeight = vRP.getInventoryMaxWeight()
    cb({ weight = weight, maxWeight = maxWeight })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- QUANTIDADE DE ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetAmount", function(data, cb)
    local amount = vRP.getItemAmount(data.item)
    cb({ amount = amount })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetWeapons", function(data, cb)
    local weapons = vRP.getWeapons()
    cb({ weapons = weapons })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR BAÚ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:openChest")
AddEventHandler("inventory:openChest", function(name, items, weight, maxWeight, slots)
    if not chestOpen then
        chestOpen = true
        SetNuiFocus(true, true)
        
        local inventario = vRP.getInventory()
        local myWeight = vRP.getInventoryWeight()
        local myMaxWeight = vRP.getInventoryMaxWeight()
        
        SendNUIMessage({
            action = "open",
            type = "chest",
            inventory = inventario,
            chest = {
                name = name,
                items = items,
                weight = weight,
                maxWeight = maxWeight,
                slots = slots or 30
            },
            weight = myWeight,
            maxWeight = myMaxWeight,
            slots = 30
        })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR DROP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:openDrop")
AddEventHandler("inventory:openDrop", function(items, weight, maxWeight)
    if not dropOpen then
        dropOpen = true
        SetNuiFocus(true, true)
        
        local inventario = vRP.getInventory()
        local myWeight = vRP.getInventoryWeight()
        local myMaxWeight = vRP.getInventoryMaxWeight()
        
        SendNUIMessage({
            action = "open",
            type = "drop",
            inventory = inventario,
            drop = {
                items = items,
                weight = weight,
                maxWeight = maxWeight
            },
            weight = myWeight,
            maxWeight = myMaxWeight,
            slots = 30
        })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ABRIR LOJA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:openShop")
AddEventHandler("inventory:openShop", function(name, items)
    if not shopOpen then
        shopOpen = true
        SetNuiFocus(true, true)
        
        local inventario = vRP.getInventory()
        local myWeight = vRP.getInventoryWeight()
        local myMaxWeight = vRP.getInventoryMaxWeight()
        
        SendNUIMessage({
            action = "open",
            type = "shop",
            inventory = inventario,
            shop = {
                name = name,
                items = items
            },
            weight = myWeight,
            maxWeight = myMaxWeight,
            slots = 30
        })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ATUALIZAR PESO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:updateWeight")
AddEventHandler("inventory:updateWeight", function()
    if inventoryOpen or chestOpen or dropOpen or shopOpen then
        local weight = vRP.getInventoryWeight()
        local maxWeight = vRP.getInventoryMaxWeight()
        
        SendNUIMessage({
            action = "updateWeight",
            weight = weight,
            maxWeight = maxWeight
        })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ATUALIZAR INVENTÁRIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:updateInventory")
AddEventHandler("inventory:updateInventory", function()
    if inventoryOpen or chestOpen or dropOpen or shopOpen then
        local inventario = vRP.getInventory()
        local weight = vRP.getInventoryWeight()
        local maxWeight = vRP.getInventoryMaxWeight()
        
        SendNUIMessage({
            action = "update",
            inventory = inventario,
            weight = weight,
            maxWeight = maxWeight
        })
    end
end)