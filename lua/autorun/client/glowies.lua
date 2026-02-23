// this script was meant to protect against people whom don't know what they're doing, this can easily be bypassed
// update: this is pretty much a shitpost honestly

// -- ====================================
// --       CIA :: Set up the tables
// -- ====================================

local Metas = {
    ["Player"] = FindMetaTable("Player") // i hope this isnt loaded before initialization
}


local CIA = {
    Glowies = {},

    GlowieGreen = Color(0, 255, 0),

    HiddenPlayers = { // the big dog glowies
        ["76561198078511998"] = true, // mkmholmes
        ["76561199443423944"] = true, // senkoopai
        ["76561197969721322"] = true, // data
        ["76561198866978554"] = true, // lenn
        ["76561199556569533"] = true, // leme
    },

    OriginalFunctions = {
        ["SteamID"] = Metas["Player"].SteamID, // i sure hope some hidemyass.lua file doesnt detour this before me!
        ["SteamID64"] = Metas["Player"].SteamID64,

        ["GetPlayerCount"] = player.GetCount,
        ["GetPlayerBySteamID"] = player.GetBySteamID,
        ["GetPlayerBySteamID64"] = player.GetBySteamID64,
        ["GetAllPlayers"] = player.GetAll,
        ["GetAllHumans"] = player.GetHumans,

        ["Player"] = Player,

        ["RemoveHook"] = hook.Remove,
    },

    ProtectedHooks = {
        ["CIA::HideVC"] = true,
        ["CIA::Glowies"] = true,
    }
}



// -- ====================================
// --       CIA :: Functions
// -- ====================================

function CIA:GetAllGlowies()
    local hidden = {}

    for ligma, eplayer in ipairs(self.OriginalFunctions["GetAllPlayers"]()) do
        if IsValid(eplayer) then
            local steamid64 = self.OriginalFunctions["SteamID64"](eplayer)

            if self.HiddenPlayers[steamid64] then
                table.insert(hidden, eplayer)
            end
        end
    end

    return hidden
end


function CIA:IsGlowie(eplayer)
    if !IsValid(eplayer) then return false end

    local steamid64 = self.OriginalFunctions["SteamID64"](eplayer)

    return self.HiddenPlayers[steamid64] == true
end


// -- ====================================
// --       CIA :: Detours
// -- ====================================

Metas["Player"].SteamID = function(self)
	local steamid = CIA.OriginalFunctions["SteamID"](self)

    local cacheme = LocalPlayer()

    if IsValid(cacheme) and steamid == CIA.OriginalFunctions["SteamID"](cacheme) then
        return steamid
    end

    local steamid64 = util.SteamIDTo64(steamid)

    if CIA.HiddenPlayers[steamid64] then
        return "STEAM_0:1:" .. math.random(100000, 9999999) // pulling an mkmholmes
    end

	return steamid
end


Metas["Player"].SteamID64 = function(self)
	local steamid64 = CIA.OriginalFunctions["SteamID64"](self)

    local cacheme = LocalPlayer()

    if IsValid(cacheme) and steamid64 == CIA.OriginalFunctions["SteamID64"](cacheme) then
        return steamid64
    end

    if CIA.HiddenPlayers[steamid64] then
        return tostring(math.random(100000, 9999999)) // pulling an mkmholmes
    end

	return steamid64
end


function player.GetCount()
    local count = CIA.OriginalFunctions["GetPlayerCount"]()

    local glowies = CIA:GetAllGlowies()
    local glowiecount = #glowies

    local cacheme = LocalPlayer()

    if IsValid(cacheme) then
        for ligma, eplayer in ipairs(glowies) do
            if eplayer == cacheme then
                glowiecount = glowiecount - 1
                break
            end
        end
    end

    return math.max(count - glowiecount, 0)
end


function player.GetBySteamID(steamid)
    local eplayer = CIA.OriginalFunctions["GetPlayerBySteamID"](steamid)

    if !IsValid(eplayer) then return eplayer end

    local cacheme = LocalPlayer()

    if IsValid(cacheme) and CIA.OriginalFunctions["SteamID64"](eplayer) == CIA.OriginalFunctions["SteamID64"](cacheme) then return eplayer end

    if CIA.HiddenPlayers[CIA.OriginalFunctions["SteamID64"](eplayer)] then
        return false // why does this have to return false? facepunch added NULL as a lua boolean for a reason..
    end

    return eplayer
end


function player.GetBySteamID64(steamid64)
    local eplayer = CIA.OriginalFunctions["GetPlayerBySteamID64"](steamid64)

    if !IsValid(eplayer) then return eplayer end

    local cacheme = LocalPlayer()

    if IsValid(cacheme) and CIA.OriginalFunctions["SteamID64"](eplayer) == CIA.OriginalFunctions["SteamID64"](cacheme) then return eplayer end

    if CIA.HiddenPlayers[CIA.OriginalFunctions["SteamID64"](eplayer)] then
        return false
    end

    return eplayer
end


function player.GetAll()
    local eplayers = CIA.OriginalFunctions["GetAllPlayers"]()

    local cacheme = LocalPlayer()

    for i = #eplayers, 1, -1 do
        local eplayer = eplayers[i]

        if IsValid(eplayer) then
            if IsValid(cacheme) and CIA.OriginalFunctions["SteamID64"](eplayer) == CIA.OriginalFunctions["SteamID64"](cacheme) then
                // glowie
            elseif CIA.HiddenPlayers[CIA.OriginalFunctions["SteamID64"](eplayer)] then
                table.remove(eplayers, i)
            end
        end
    end

    return eplayers
end


function player.GetHumans()
    local eplayers = CIA.OriginalFunctions["GetAllHumans"]()

    local cacheme = LocalPlayer()

    for i = #eplayers, 1, -1 do
        local eplayer = eplayers[i]

        if IsValid(eplayer) then
            if IsValid(cacheme) and CIA.OriginalFunctions["SteamID64"](eplayer) == CIA.OriginalFunctions["SteamID64"](cacheme) then
                // glowie
            elseif CIA.HiddenPlayers[CIA.OriginalFunctions["SteamID64"](eplayer)] then
                table.remove(eplayers, i)
            end
        end
    end

    return eplayers
end


function Player(id)
    local eplayer = CIA.OriginalFunctions["Player"](id)

    if !IsValid(eplayer) then return eplayer end

    local cacheme = LocalPlayer()

    if IsValid(cacheme) and CIA.OriginalFunctions["SteamID64"](eplayer) == CIA.OriginalFunctions["SteamID64"](cacheme) then return eplayer end

    if CIA.HiddenPlayers[CIA.OriginalFunctions["SteamID64"](eplayer)] then
        return NULL
    end

    return eplayer
end


function hook.Remove(event, id)
    if CIA.ProtectedHooks[id] then return end

    return CIA.OriginalFunctions["RemoveHook"](event, id) // i doubt hook.Remove will return anything but its nice to be on the safe side
end



// -- ====================================
// --       CIA :: Hooks
// -- ====================================

hook.Add("PlayerStartVoice", "CIA::HideVC", function(eplayer)
    if CIA.HiddenPlayers[CIA.OriginalFunctions["SteamID64"](eplayer)] then
        return true
    end
end)


hook.Add("OnPlayerChat", "CIA::ChatMsgs", function(eplayer, text, team, isdead)
    if IsValid(eplayer) then
        local cacheme = LocalPlayer(); if !IsValid(cacheme) then return end
    
        if CIA.HiddenPlayers[CIA.OriginalFunctions["SteamID64"](eplayer)] and CIA.HiddenPlayers[CIA.OriginalFunctions["SteamID64"](cacheme)] then
            local teamcolor = team.GetColor(eplayer:Team())

            chat.AddText(CIA.GlowieGreen, "[FELLOW GLOWIE] ", teamcolor, eplayer:Nick(), color_white, ": " .. tostring(text))

            return true
        end

        if CIA.HiddenPlayers[CIA.OriginalFunctions["SteamID64"](eplayer)] then
            chat.AddText(CIA.GlowieGreen, "GLOWIE", color_white, ": " .. tostring(text))
            return true
        end
    end
end)


/* too performance heavy
hook.Add("PreDrawOpaqueRenderables", "CIA::Glowies", function()
    render.SetStencilEnable(true)
    render.ClearStencil()
    render.SetStencilWriteMask(255)
    render.SetStencilTestMask(255)
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_REPLACE)

    for ligma, glowie in ipairs(CIA:GetAllGlowies()) do
        if glowie:GetObserverMode() == OBS_MODE_NONE and glowie:Alive() then
            glowie:DrawModel()
        end
    end

    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilPassOperation(STENCIL_KEEP)

    render.SetMaterial(Material("models/weapons/v_slam/new light2"))
    render.DrawScreenQuad()

    render.SetStencilEnable(false)
    render.SetStencilWriteMask(0)
    render.SetStencilTestMask(0)

    for ligma, glowie in ipairs(CIA:GetAllGlowies()) do
        if glowie:Alive() then
            local dlight = DynamicLight(glowie:EntIndex())
            if dlight then
                dlight.pos = glowie:GetPos()
                dlight.r = 0
                dlight.g = 255
                dlight.b = 0
                dlight.brightness = 5
                dlight.Decay = 1000
                dlight.Size = 556
                dlight.DieTime = CurTime() + 1
            end
        end
    end
end)
*/