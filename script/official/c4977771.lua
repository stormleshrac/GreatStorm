-- Conjurador Dual Desencadenado
-- Script by ChatGPT
local s,id=GetID()
function s.initial_effect(c)
    -- Set Unchained archetype
    c:SetSetCard(0x231)

    -- Special Summon Clones
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(s.spcon_hand)
    c:RegisterEffect(e2)

    -- Return from Graveyard
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(s.retcon)
    e3:SetOperation(s.retop)
    c:RegisterEffect(e3)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsAttribute,ATTRIBUTE_DARK),tp,LOCATION_GRAVE,0,1,nil)
end

function s.spcon_hand(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and s.spcon(e,tp,eg,ep,ev,re,r,rp)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_EFFECT+TYPE_MONSTER,0,0,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
    for i=1,2 do
        local token=Duel.CreateToken(tp,id)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
    end
    Duel.SpecialSummonComplete()
end

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function s.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,id),tp,LOCATION_MZONE,0,1,nil) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        e1:SetLabelObject(c)
        e1:SetOperation(s.retop2)
        Duel.RegisterEffect(e1,tp)
    end
end

function s.retop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,id),tp,LOCATION_MZONE,0,1,nil) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end