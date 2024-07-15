-- Mega Rodo Divino
local s,id=GetID()
function s.initial_effect(c)
    -- Condiciones especiales de invocación
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    -- Destruir monstruos del adversario
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(s.destg)
    e2:SetOperation(s.desop)
    c:RegisterEffect(e2)
end
s.listed_names={10103200}

function s.spfilter(c,tp)
    return c:IsCode(10103200) and c:IsControler(tp) and c:IsReleasable()
end

function s.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.CheckReleaseGroup(tp,s.spfilter,1,nil)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,s.spfilter,1,1,false,true,true,c,nil,nil,false,nil)
    Duel.Release(g,REASON_COST)
end

function s.desfilter(c,atk)
    return c:IsFaceup() and c:GetAttack()<=atk
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local atk=e:GetHandler():GetAttack()
    if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil,atk) end
    local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,atk)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local atk=e:GetHandler():GetAttack()
    local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,atk)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
