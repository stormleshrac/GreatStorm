-- Rodo
local s,id=GetID()
function s.initial_effect(c)
    -- Special summon
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end
s.listed_names={10103200}

function s.filter(c,e,tp)
    return c:IsCode(10103200) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local g=Duel.GetDecktopGroup(tp,5)
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
            and g:IsExists(s.filter,1,nil,e,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetDecktopGroup(tp,5)
    if #g>0 then
        Duel.ConfirmCards(tp,g)
        if g:IsExists(s.filter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local sg=g:FilterSelect(tp,s.filter,1,1,nil,e,tp)
            if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 and c:IsRelateToEffect(e) then
                Duel.SendtoGrave(c,REASON_EFFECT)
            end
        end
        Duel.ShuffleDeck(tp)
    end
end
