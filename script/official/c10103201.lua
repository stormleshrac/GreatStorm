-- Rodo
local s,id=GetID()
function s.initial_effect(c)
    -- Invocación normal o especial
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
end
s.listed_names={10103200}

function s.filter(c,e,tp)
    return c:IsCode(10103200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetDecktopGroup(tp,5)
        return g:IsExists(s.filter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,5)
    Duel.ConfirmCards(tp,g)
    if g:IsExists(s.filter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:FilterSelect(tp,s.filter,1,1,nil,e,tp)
        if #sg>0 then
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
            Duel.Destroy(e:GetHandler(),REASON_EFFECT)
        end
    end
    Duel.ShuffleDeck(tp)
end
