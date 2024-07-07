-- Este Bendecido
local s,id=GetID()
function s.initial_effect(c)
    -- Equip procedure
    aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,89987208))
    -- ATK/DEF increase
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(1500)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e2)
    -- Level increase
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_UPDATE_LEVEL)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    -- Double attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCondition(s.atcon)
    e4:SetOperation(s.atop)
    c:RegisterEffect(e4)
end

function s.eqlimit(e,c)
    return c:IsCode(89987208)
end

function s.atcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler():GetEquipTarget()
    return eg:IsContains(c) and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
end

function s.atop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChainAttack()
end