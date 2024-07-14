-- Rodo
-- Scripted by [Tu nombre aquí]

local s,id=GetID()

function s.initial_effect(c)
    -- Efecto 1: Revelar y Invocar Especialmente a Super Rodo
    local e1=Effect.CreateEffect(c)
    e1:SetDescription("Revela las 5 cartas superiores de tu Deck y si una de ellas es 'Super Rodo', invócala especialmente al campo destruyendo a 'Rodo'")
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target1)
    e1:SetOperation(s.operation1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)
end

function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.operation1(e,tp,eg,ep,ev,re,r,rp)
    Duel.ConfirmDecktop(tp,5)
    local g=Duel.GetDecktopGroup(tp,5)
    local sg=g:Filter(Card.IsCode,nil,10103200)
    if sg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tc=sg:Select(tp,1,1,nil):GetFirst()
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        local c=e:GetHandler()
        if c:IsRelateToEffect(e) then
            Duel.Destroy(c,REASON_EFFECT)
        end
    end
    Duel.ShuffleDeck(tp)
end
