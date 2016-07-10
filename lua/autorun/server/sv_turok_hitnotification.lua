util.AddNetworkString("THM_HitLocation")

resource.AddFile( "vgui/turok/topleft" )

function THM_EntityTakeDamage( victim, dmginfo)

	if victim:IsPlayer() then

		local VictimPos = victim:EyePos()
		local VictimAng = victim:EyeAngles()
		VictimAng:Normalize()
		
		local Attacker = dmginfo:GetAttacker()
		local Inflictor = dmginfo:GetInflictor()
		
		local TopLeft = false
		local TopRight = false
		local BottomRight = false
		local BottomLeft = false
		
		if dmginfo:IsFallDamage() or dmginfo:GetDamageType() == DMG_DROWN then
		
			TopLeft = true
			TopRight = true
			BottomRight = true
			BottomLeft = true
		
		elseif (Attacker and Attacker ~= NULL) or (Inflictor and Inflictor ~= NULL) then
		
			local WeaponPos = Vector(0,0,0)
		
		
			if Inflictor and Inflictor ~= NULL then
				WeaponPos = Inflictor:GetPos()
			
			
			elseif Attacker and Attacker ~= NULL then
				WeaponPos = Attacker:GetPos() + Attacker:OBBCenter()
			end
			
			
			
			local HitAngles = (WeaponPos - VictimPos):Angle()
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
		
end

hook.Add("EntityTakeDamage","THM_EntityTakeDamage",THM_EntityTakeDamage)


function THM_PlayerSay(sender,text,teamChat)

	if text == "!burhit" then
		
		sender:ConCommand("cl_burhit_menu")
		
		
		
		return ""
	end


end

hook.Add("PlayerSay","THM_PlayerSay",THM_PlayerSay)




function math.inrange(val, min, max)
	return val <= max and val >= min
end




