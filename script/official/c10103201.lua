-- Rodo
local s,id=GetID()
function s.initial_effect(c)
    -- Efecto de invocación especial
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
end
s.listed_names={10103200}

function s.thfilter(c)
    return c:IsCode(10103200) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetDecktopGroup(tp,5):IsExists(s.thfilter,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,5)
    if #g>0 then
        Duel.ConfirmCards(tp,g)
        if g:IsExists(s.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=g:FilterSelect(tp,s.thfilter,1,1,nil)
            if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
                Duel.ConfirmCards(1-tp,sg)
                Duel.BreakEffect()
                Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
            end
        end
        Duel.ShuffleDeck(tp)
    end
end