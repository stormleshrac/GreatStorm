--Rey Sortija
local s,id=GetID()
function s.initial_effect(c)
	--Efecto: El adversario no puede invocar monstruos en posición de ataque
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e1:SetTarget(s.sumlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e2)
end

function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return sumpos&POS_FACEUP_ATTACK~=0
end
