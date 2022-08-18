secured = {
    numEvents = 0,
    allow = false,
    lastToken = ""
}

secured.getToken = function()
    return LocalPlayer.state.token
end

secured.getNumToken = function()
    return LocalPlayer.state.numToken
end

secured.call = function(name,...)
    while not secured.allow do
        Wait(0)
    end
    secured.numEvents = secured.numEvents + 1
    while (secured.numEvents > secured.getNumToken()) do
        Wait(0)
    end
    return TriggerServerEvent(name,secured.getToken(),...)
end

exports('call', function(name,...)
    secured.call(name,...)
end)

RegisterNetEvent("secured:allow")
AddEventHandler("secured:allow", function()
    Wait(500)
    secured.allow = true
    secured.lastToken = secured.getToken()
    return print("^0[^5SECURED^0] Player loaded")
end)

CreateThread(function()
    Wait(50)
    return TriggerServerEvent("secured:get")
end)