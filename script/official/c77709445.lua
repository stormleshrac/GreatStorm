-- Slifer the Borealis Guardian (Rango 10) - Script Corregido y Testeado
Duel.LoadScript("enums_cards.lua")
Debug.SetAIName("Borealis IA")

local s, id = GetID()

s.material = {3,10}
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
    
    -- Efecto Rápido: Destruir monstruos (Once por turno)
    local e6 = Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(id, 0))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1, id) -- ¡Clave! 1 vez por turno
    e6:SetCost(s.descost)
    e6:SetTarget(s.destg)
    e6:SetOperation(s.desop)
    c:RegisterEffect(e6)
    
    -- 3er Efecto Corregido: Negar y destruir carta/monstruo
    local e7 = Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(id, 1))
    e7:SetCategory(CATEGORY_NEGATE + CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_CHAINING)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1, id+1) -- ID único para este efecto
    e7:SetCondition(s.negcon)
    e7:SetCost(s.negtcost)
    e7:SetTarget(s.negtg)
    e7:SetOperation(s.negop)
    c:RegisterEffect(e7)
    
    -- Efecto al ser destruido (Corregido)
    local e8 = Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(id, 2))
    e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e8:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(s.spcon)
    e8:SetTarget(s.sptg)
    e8:SetOperation(s.spop)
    c:RegisterEffect(e8)
end

-- Funciones CORREGIDAS --

function s.atkval(e, c)
    return c:GetOverlayCount() * 1500
end

function s.protcon(e)
    return e:GetHandler():GetOverlayCount() > 0
end

-- Efecto Rápido (Destruir monstruos) --
function s.descost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

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

-- 3er Efecto Corregido (Negar y destruir) --
function s.negcon(e, tp, eg, ep, ev, re, r, rp)
    return rp == 1 - tp and Duel.IsChainNegatable(ev)
end

function s.negtcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
    if re:GetHandler():IsDestructable() then
        Duel.SetOperationInfo(0, CATEGORY_DESTROY, eg, 1, 0, 0)
    end
end

function s.negop(e, tp, eg, ep, ev, re, r, rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg, REASON_EFFECT)
    end
end

-- Efecto al ser destruido (Corregido) --
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end

function s.spfilter(c, e, tp)
    return c:IsType(TYPE_XYZ) and c:IsRankBelow(9) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_XYZ, tp, false, false)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_EXTRA, 0, 1, nil, e, tp) end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local sc = Duel.SelectMatchingCard(tp, s.spfilter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp):GetFirst()
    if sc and Duel.SpecialSummon(sc, SUMMON_TYPE_XYZ, tp, tp, false, false, POS_FACEUP) > 0 then
        sc:CompleteProcedure()
        if c:IsLocation(LOCATION_GRAVE) then
            Duel.Overlay(sc, c)
        end
    end
end
