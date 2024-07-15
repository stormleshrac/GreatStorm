--Rodo
local s,id=GetID()
function s.initial_effect(c)
    -- Activate effect when summoned
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e3)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.DiscardDeck(tp,5,REASON_EFFECT)~=0 then
        local g=Duel.GetOperatedGroup()
        if g:IsExists(Card.IsCode,1,nil,10103200) then
            Duel.BreakEffect()
            local c=e:GetHandler()
            if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
                local tg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,0,nil,10103200)
                if #tg>0 then
                    Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
    end
end
