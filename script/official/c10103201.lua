--Rodo
local s,id=GetID()
function s.initial_effect(c)
    -- Activate effect when summoned
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerCanDiscardDeck(tp,5) then
        Duel.ConfirmDecktop(tp,5)
        local g=Duel.GetDecktopGroup(tp,5)
        if g:IsExists(Card.IsCode,1,nil,10103200) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
            local sg=g:FilterSelect(tp,Card.IsCode,1,1,nil,10103200)
            if sg:GetCount()>0 then
                local c=e:GetHandler()
                if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
                    Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
                end
            end
        end
        Duel.ShuffleDeck(tp)
    end
end
