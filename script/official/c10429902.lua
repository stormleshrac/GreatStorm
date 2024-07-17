--Wandawais
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_HANDES+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0,LOCATION_HAND,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    -- Opponent discards a card from their hand
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
    local g1=Duel.SelectMatchingCard(1-tp,Card.IsDiscardable,1-tp,LOCATION_HAND,0,1,1,nil)
    if #g1>0 then
        Duel.SendtoGrave(g1,REASON_DISCARD+REASON_EFFECT)
        local dg=g1:GetFirst()
        if dg:IsType(TYPE_MONSTER) then
            if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
                local mg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
                if #mg>0 then
                    Duel.Destroy(mg,REASON_EFFECT)
                end
            end
        end
    end

    -- You discard a card from your hand, chosen by your opponent
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g2=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
    if #g2>0 then
        Duel.SendtoGrave(g2,REASON_DISCARD+REASON_EFFECT)
        local dg2=g2:GetFirst()
        if dg2:IsType(TYPE_MONSTER) then
            if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) then
                Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
                local mg2=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
                if #mg2>0 then
                    Duel.Destroy(mg2,REASON_EFFECT)
                end
            end
        end
    end
end
