secured = {
    unk = "unknown",
    players = {},
    bannedPlayers = {},
    debugLog = true
}

secured.sendWebhook = function(embed,where)
    PerformHttpRequest(config.webhooks[where], function(err, text, headers) 
    end, 'POST', json.encode({embeds = {embed}}), { ['Content-Type'] = 'application/json' })
end

secured.checkPlayer = function(player)
    local i = secured.getIdentifiers(player)
    for k,v in pairs(i) do
        if k ~= "tokens" then
            if secured.bannedPlayers["bannedIdentifiers"][v] then
                return true
            end
        else
            for _,token in pairs(v) do
                if secured.bannedPlayers["bannedIdentifiers"][token] then
                    return true
                end
            end
        end
    end
    return false
end

secured.banPlayer = function(player)
    local i = secured.getIdentifiers(player)
    if not secured.bannedPlayers[i.license] then
        secured.bannedPlayers[i.license] = i
        for k,v in pairs(i) do
            if k ~= "tokens" then
                secured.bannedPlayers["bannedIdentifiers"][v] = true
            else
                for _,token in pairs(v) do
                    secured.bannedPlayers["bannedIdentifiers"][token] = true
                end
            end
        end
        DropPlayer(player, "[SECURED] > You has been banned from this server!")
    end
end

secured.getIdentifiers = function(player)
    local i = {
        steam = secured.unk,
        discord = secured.unk,
        license = secured.unk,
        ip = secured.unk,
        xbl = secured.unk,
        live = secured.unk,
        fivem = secured.unk,
        tokens = {}
    }

    local numTokens = GetNumPlayerTokens(player)
    for i = 1, numTokens do
        table.insert(i.tokens, GetPlayerToken(player, i))
    end

    for k,v in pairs(GetPlayerIdentifiers(player)) do
        for r in pairs(i) do
            if string.find(v, r) then
                identifiers[r] = string.gsub(v, ".*:", "")
            end
        end
    end
    return i
end

secured.randomString = function(count)
    math.randomseed(os.time() + math.random(11111, 99999))
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local rndmString = ""
    for i = 0,count do
        local rndm = math.random(1,#chars)
        local char = string.sub(chars,rndm,rndm)
        rndmString = rndmString..char
    end
    return rndmString
end

secured.debug = function(str)
    if secured.debugLog then
        print("^0[^5SECURED^0] ^1"..str)
    end
end

exports('handler', function(name,callback)
    secured.handler(name,callback)
end)

secured.getToken = function(player)
    return Player(player).state.token
end

secured.handler = function(name,callback)
    RegisterNetEvent(name)
    local tempCallback = callback
    callback = function(...)
        local args = {...}
        if #args < 1 then
            local identifiers = secured.getIdentifiers(source)
            identifiers.tokens = nil
            secured.sendWebhook({
                ["title"] = "> SECURED BAN PLAYER <",
                ["description"] = " ",
                ["fields"] = {
                    [1] = {
                        ["name"] = "Player called event without arguments!",
                        ["value"] = "**Event name:** `"..name.."`\n**Identifiers:** ```"..json.encode(identifiers).."```",
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "©SECURED by xariesnull "..os.date("%d/%m/%Y %H:%M:%S").."",
                    ["icon_url"] = ""
                },
                ["color"] = 59076
            },"ban")
            secured.banPlayer(source)
            return
        end
        local unpackedArgs = table.unpack(args)
        local token = unpackedArgs
        
        if token ~= secured.getToken(source) then
            local identifiers = secured.getIdentifiers(source)
            identifiers.tokens = nil
            secured.sendWebhook({
                ["title"] = "> SECURED BAN PLAYER <",
                ["description"] = " ",
                ["fields"] = {
                    [1] = {
                        ["name"] = "Player called event with incorrect token!",
                        ["value"] = "**Event name:** `"..name.."`\n**Player Token:** `"..tostring(secured.getToken(source)).."`\n**Incorrect token:** `"..token.."`\n**Identifiers:** ```"..json.encode(identifiers).."```",
                        ["inline"] = true
                    }
                },
                ["footer"] = {
                    ["text"] = "©SECURED by xariesnull "..os.date("%d/%m/%Y %H:%M:%S").."",
                    ["icon_url"] = ""
                },
                ["color"] = 59076
            },"ban")
            secured.banPlayer(source)
            return
        end

        Player(source).state.numToken = Player(source).state.numToken + 1
        Player(source).state.token = secured.randomString(4)
        table.remove(args,1)
        return tempCallback(table.unpack(args))
    end
    AddEventHandler(name,callback)
end

RegisterNetEvent("secured:get")
AddEventHandler("secured:get", function()
    local player = source
    if not secured.players[tostring(player)] then
        secured.players[tostring(player)] = true
        Player(player).state.token = secured.randomString(4)
        Player(player).state.numToken = 1
        return TriggerClientEvent("secured:allow", player)
    end
end)

AddEventHandler("playerConnecting", function(name,kickReason,def)
    local player = source
    local i = secured.getIdentifiers(player)
    def.defer()
    Wait(0)
    if secured.checkPlayer(player) then
        return def.done("[SECURED] > You has been banned from this server!")
    end
    if not i.license then
        return def.done("[SECURED] > No license")
    end
    def.done()
end)

CreateThread(function()
    Wait(1000)
    PerformHttpRequest("https://github.com/xariesnull/fivem-secured/blob/main/version", function(err, text, headers)
        if not text then
            return print("^0[^5SECURED^0] > ^1 Can't check for new version")
        if text ~= "1.0" then
            return print([[
            [^5SECURED^0] > New version of ^5SECURED^0 is available (^2]]..text..[[^0)
            Visit > https://github.com/xariesnull/fivem-secured to download new update!
            ]])
        end
    end, "GET")
end)