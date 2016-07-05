util.AddNetworkString("THM_HitLocation")

function THM_ScalePlayerDamage(victim,hitgroup,dmginfo)

	local VictimPos = victim:EyePos()
	local VictimAng = victim:EyeAngles()
	VictimAng:Normalize()
	
	local Attacker = dmginfo:GetAttacker()
	
	local TopLeft = false
	local TopRight = false
	local BottomRight = false
	local BottomLeft = false
	
	if Attacker and Attacker ~= NULL then
		local AttackerPos = Attacker:GetPos() + Attacker:OBBCenter()
		
		local HitAngles = (AttackerPos - VictimPos):Angle()
		HitAngles:Normalize()
		
		local AngDifference = VictimAng - HitAngles
		AngDifference:Normalize()
		
		local Yaw = AngDifference.y

		if math.inrange(Yaw,-135,45) then
			TopLeft = true
		end
		
		if math.inrange(Yaw,-45,135) then
			TopRight = true
		end
		
		if math.inrange(Yaw,90,180) or math.inrange(Yaw,-180,-135) then
			BottomRight = true
		end	
		
		if math.inrange(Yaw,-180,-90) or math.inrange(Yaw,135,180) then
			BottomLeft = true
		end	
	
	else
	
		TopLeft = true
		TopRight = true
		BottomRight = true
		BottomLeft = true
		
	end

	net.Start("THM_HitLocation")
		net.WriteBool(TopLeft)
		net.WriteBool(TopRight)
		net.WriteBool(BottomRight)
		net.WriteBool(BottomLeft)
	net.Send(victim)
		
end

hook.Add("ScalePlayerDamage","THM_ScalePlayerDamage",THM_ScalePlayerDamage)

function math.inrange(val, min, max)
	return val <= max and val >= min
end
