--Rey Sortija
local s,id=GetID()
function s.initial_effect(c)
    --Efecto al invocar
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() then
        --El adversario no puede invocar en posición de ataque
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_SUMMON)
        e1:SetTargetRange(0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
        e1:SetTarget(s.sumlimit)
        e1:SetCondition(s.condition)
        Duel.RegisterEffect(e1,tp)
        
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e2:SetTargetRange(0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
        e2:SetTarget(s.sumlimit)
        e2:SetCondition(s.condition)
        Duel.RegisterEffect(e2,tp)
    end
end

function s.condition(e)
    return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,e:GetHandler():GetCode()),0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    if sumpos == nil then
        return false
    end
    return (sumpos & POS_FACEUP_ATTACK) == POS_FACEUP_ATTACK
end
