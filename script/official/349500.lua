--Nueva Calma
local s,id=GetID(349500)
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function s.cfilter(c)
    return c:IsRace(RACE_WARRIOR) and c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:SetLabelObject(g:GetFirst())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_TOKEN_MONSTER,-2,0,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateAttack() then
        local tc=e:GetLabelObject()
        if not tc or not Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_TOKEN_MONSTER,-2,0,1,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
        local token=Duel.CreateToken(tp,id)
        Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_BASE_ATTACK)
        e1:SetValue(0)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        token:RegisterEffect(e1,true)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_BASE_DEFENSE)
        token:RegisterEffect(e2,true)
        Duel.SpecialSummonComplete()
    end
end
