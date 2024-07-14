-- Rodo
local s,id=GetID()
function s.initial_effect(c)
    -- Invocación normal o especial
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetOperation(s.sumop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
end
s.listed_names={10103200}

function s.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
    local g=Duel.GetDecktopGroup(tp,5)
    Duel.ConfirmCards(tp,g)
    if g:IsExists(Card.IsCode,1,nil,10103200) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:FilterSelect(tp,Card.IsCode,1,1,nil,10103200)
        local tc=sg:GetFirst()
        if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
            -- Destruir Rodo
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SELF_DESTROY)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            c:RegisterEffect(e1)
            Duel.SpecialSummonComplete()
        end
    end
    Duel.ShuffleDeck(tp)
end
