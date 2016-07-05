
local Overlay = Material("vgui/turok/topleft")

local CountTable = {
	TopLeft = 0,
	TopRight = 0,
	BottomRight = 0,
	BottomLeft = 0,
}

net.Receive("THM_HitLocation", function(len)

	local TopLeft = net.ReadBool()
	local TopRight = net.ReadBool()
	local BottomRight = net.ReadBool()
	local BottomLeft = net.ReadBool()

	if TopLeft then
		CountTable.TopLeft = math.Clamp(CountTable.TopLeft+1,0,3)
	end
		
	if TopRight then
		CountTable.TopRight = math.Clamp(CountTable.TopRight+1,0,3)
	end
	
	if BottomRight then
		CountTable.BottomRight = math.Clamp(CountTable.BottomRight+1,0,3)
	end
	
	if BottomLeft then
		CountTable.BottomLeft = math.Clamp(CountTable.BottomLeft+1,0,3)
	end
	
end)

function THM_HUDPaint()

	local ply = LocalPlayer()
	
	local x = ScrW()
	local y = ScrH() 
	local Size = 512

	-- Top left
	surface.SetMaterial( Overlay )
	surface.SetDrawColor( 255, 255, 255, math.Clamp(255*CountTable.TopLeft,0,255) )
	surface.DrawTexturedRectRotated( Size/2, Size/2, Size, Size, 0 )
	
	-- Top Right
	surface.SetMaterial( Overlay )
	surface.SetDrawColor( 255, 255, 255, math.Clamp(255*CountTable.TopRight,0,255) )
	surface.DrawTexturedRectRotated( x - Size/2, Size/2, Size, Size, -90 )
	
	-- Bottom Left
	surface.SetMaterial( Overlay )
	surface.SetDrawColor( 255, 255, 255, math.Clamp(255*CountTable.BottomLeft,0,255) )
	surface.DrawTexturedRectRotated( Size/2, y - Size/2, Size, Size,90 )
	
	-- Bottom Right
	surface.SetMaterial( Overlay )
	surface.SetDrawColor( 255, 255, 255, math.Clamp(255*CountTable.BottomRight,0,255) )
	surface.DrawTexturedRectRotated( x - Size/2, y - Size/2, Size, Size, 180 )
	
	CountTable.TopLeft = math.Clamp(CountTable.TopLeft - FrameTime(),0,3)
	CountTable.TopRight = math.Clamp(CountTable.TopRight - FrameTime(),0,3)
	CountTable.BottomLeft = math.Clamp(CountTable.BottomLeft - FrameTime(),0,3)
	CountTable.BottomRight = math.Clamp(CountTable.BottomRight - FrameTime(),0,3)

end

hook.Add("HUDPaint","THM_HUDPaint",THM_HUDPaint)

function THM_HUDShouldDraw(name)
	if name=="CHudDamageIndicator" then
		return false
	end
end

hook.Add( "HUDShouldDraw", "THM_HUDShouldDraw", THM_HUDShouldDraw)

