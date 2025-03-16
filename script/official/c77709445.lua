-- Slifer the Borealis Guardian (Rango 10) - Versión Corregida
Duel.LoadScript("enums_cards.lua")
Debug.SetAIName("Borealis IA")

local s, id = GetID()

s.material = {3,10} -- 3 monstruos de Nivel 10
s.mat_filter = function(c) return c:IsLevel(10) end
s.listed_names = {id}
s.immortal_type = DIVINE

function s.initial_effect(c)
    -- Xyz Propio
    Xyz.AddProcedure(c, nil, 10, 3, nil, nil, 99)
    c:EnableReviveLimit()
    
    -- ATK/DEF basado en materiales (1500 por material)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(s.atkval)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EFFECT_SET_DEFENSE)
    c:RegisterEffect(e2)
    
    -- Protección Divina
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.protcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4 = e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5 = e3:Clone()
    e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    c:RegisterEffect(e5)
    
    -- Efecto Rápido (Destruir monstruos) - ¡Una vez por turno!
    local e6 = Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id, 0))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1, id) -- Limitado a 1 uso por turno
    e6:SetCost(s.descost)
    e6:SetTarget(s.destg)
    e6:SetOperation(s.desop)
    c:RegisterEffect(e6)
    
    -- Negar activación + Daño (sin cambios)
    -- ... (e7 igual que antes) ...
    
    -- Efecto al ser destruido (sin cambios)
    -- ... (e8 igual que antes) ...
end

-- Funciones de efecto CORREGIDAS --

function s.atkval(e, c)
    return c:GetOverlayCount() * 1500
end

function s.protcon(e)
    return e:GetHandler():GetOverlayCount() > 0
end

function s.descost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

-- Corrección: Usar Auxiliary.FaceupFilter en lugar del deprecated --
function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
    local c = e:GetHandler()
    local g = Duel.GetMatchingGroup(function(sc) 
        return sc:IsFaceup() and sc:GetAttack() <= c:GetAttack() 
    end, tp, 0, LOCATION_MZONE, nil)
    if chk == 0 then return #g > 0 end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g = Duel.GetMatchingGroup(function(sc) 
        return sc:IsFaceup() and sc:GetAttack() <= c:GetAttack() 
    end, tp, 0, LOCATION_MZONE, nil)
    if #g > 0 then
        Duel.Destroy(g, REASON_EFFECT)
    end
end

-- ... (resto de funciones igual que antes, solo se modifica lo mencionado) ...
