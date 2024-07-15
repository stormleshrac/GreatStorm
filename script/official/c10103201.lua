-- Rodo
local s,id = GetID()
function s.initial_effect(c)
    -- Efecto de invocación
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end
s.listed_names={10103200}

function s.filter(c)
    return c:IsCode(10103200) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetDecktopGroup(tp,5):IsExists(s.filter,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,5)
    if #g>0 then
        Duel.ConfirmCards(tp,g)
        if g:IsExists(s.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            local sg=g:Filter(s.filter,nil)
            if #sg>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
                local tg=sg:Select(tp,1,1,nil)
                if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
                    Duel.ConfirmCards(1-tp,tg)
                    Duel.ShuffleHand(tp)
                    Duel.BreakEffect()
                    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
                end
            end
        end
        Duel.ShuffleDeck(tp)
    end
end
