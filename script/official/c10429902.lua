-- Wandawais
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_HANDES+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0,LOCATION_HAND,1,nil)
        and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,0,LOCATION_HAND,1,1,nil)
    if #g>0 and Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT)>0 and g:GetFirst():IsType(TYPE_MONSTER) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
        if #dg>0 then
            Duel.Destroy(dg,REASON_EFFECT)
        end
    end

    if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then return end
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
    local hg=Duel.SelectMatchingCard(1-tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil)
    Duel.ConfirmCards(tp,hg)
    if hg:GetFirst():IsType(TYPE_MONSTER) then
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
        local dg2=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
        if #dg2>0 then
            Duel.Destroy(dg2,REASON_EFFECT)
        end
    end
    Duel.ShuffleHand(tp)
end
