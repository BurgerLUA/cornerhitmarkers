
local Overlay = Material("vgui/turok/topleft")

CreateClientConVar("cl_burhit_enable",1)
CreateClientConVar("cl_burhit_color_r",255)
CreateClientConVar("cl_burhit_color_g",0)
CreateClientConVar("cl_burhit_color_b",0)

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
	
	THM_SendHit(TopLeft,TopRight,BottomRight,BottomLeft)
	
end)

function THM_SendHit(TopLeft,TopRight,BottomRight,BottomLeft)

	if GetConVar("cl_burhit_enable"):GetFloat() >= 1 then

		if TopLeft then
			CountTable.TopLeft = math.Clamp(CountTable.TopLeft+1,0,1)
		end
			
		if TopRight then
			CountTable.TopRight = math.Clamp(CountTable.TopRight+1,0,1)
		end
		
		if BottomRight then
			CountTable.BottomRight = math.Clamp(CountTable.BottomRight+1,0,1)
		end
		
		if BottomLeft then
			CountTable.BottomLeft = math.Clamp(CountTable.BottomLeft+1,0,1)
		end

	end
		
end




function THM_HUDPaint()

	local ply = LocalPlayer()
	
	local x = ScrW()
	local y = ScrH() 
	local Size = 512
	
	local r = math.Clamp(GetConVar("cl_burhit_color_r"):GetFloat(),0,255)
	local g = math.Clamp(GetConVar("cl_burhit_color_g"):GetFloat(),0,255)
	local b = math.Clamp(GetConVar("cl_burhit_color_b"):GetFloat(),0,255)
	
	local HitColor = Color(r,g,b)

	-- Top left
	surface.SetMaterial( Overlay )
	surface.SetDrawColor( HitColor.r, HitColor.g, HitColor.b, math.Clamp(255*CountTable.TopLeft,0,255) )
	surface.DrawTexturedRectRotated( Size/2, Size/2, Size, Size, 0 )
	
	-- Top Right
	surface.SetMaterial( Overlay )
	surface.SetDrawColor( HitColor.r, HitColor.g, HitColor.b, math.Clamp(255*CountTable.TopRight,0,255) )
	surface.DrawTexturedRectRotated( x - Size/2, Size/2, Size, Size, -90 )
	
	-- Bottom Left
	surface.SetMaterial( Overlay )
	surface.SetDrawColor( HitColor.r, HitColor.g, HitColor.b, math.Clamp(255*CountTable.BottomLeft,0,255) )
	surface.DrawTexturedRectRotated( Size/2, y - Size/2, Size, Size,90 )
	
	-- Bottom Right
	surface.SetMaterial( Overlay )
	surface.SetDrawColor( HitColor.r, HitColor.g, HitColor.b, math.Clamp(255*CountTable.BottomRight,0,255) )
	surface.DrawTexturedRectRotated( x - Size/2, y - Size/2, Size, Size, 180 )
	
	CountTable.TopLeft = math.Clamp(CountTable.TopLeft - FrameTime(),0,3)
	CountTable.TopRight = math.Clamp(CountTable.TopRight - FrameTime(),0,3)
	CountTable.BottomLeft = math.Clamp(CountTable.BottomLeft - FrameTime(),0,3)
	CountTable.BottomRight = math.Clamp(CountTable.BottomRight - FrameTime(),0,3)

end

hook.Add("HUDPaint","THM_HUDPaint",THM_HUDPaint)

surface.CreateFont( "THM_Small", {
	font = "Roboto-Medium",
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "THM_Large", {
	font = "Roboto-Medium",
	size = 36,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function THM_Paint(w,h,color)
	draw.RoundedBox( 4, 0, 0, w, h, color )
end

function THM_Menu()

	local x = ScrW()
	local y = ScrH()
	local ply = LocalPlayer()
	
	local r = math.Clamp(GetConVar("cl_burhit_color_r"):GetFloat(),0,255)
	local g = math.Clamp(GetConVar("cl_burhit_color_g"):GetFloat(),0,255)
	local b = math.Clamp(GetConVar("cl_burhit_color_b"):GetFloat(),0,255)
	
	local HitColor = Color(r,g,b)
	
	local Spacing = 10
	
	local LargeFont = 36
	
	local ButtonSize = LargeFont*1.25
	
	local BasePanel = vgui.Create("DFrame")
	BasePanel:SetSize(Spacing*11 + ButtonSize*13,ButtonSize*3 + Spacing*11 + LargeFont*2)
	BasePanel:ShowCloseButton(false)
	BasePanel:SetTitle("")
	BasePanel:SetDraggable(false)
	BasePanel:Center()
	BasePanel:MakePopup()
	function BasePanel:Paint(w,h)
		THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
	end
	
	local LW,LH = BasePanel:GetSize()
	
		local TitlePanel = vgui.Create("DPanel",BasePanel)
		TitlePanel:SetPos(Spacing,Spacing)
		TitlePanel:SetSize(LW - Spacing*3 - LargeFont,LargeFont)
		function TitlePanel:Paint(w,h)
			draw.SimpleTextOutlined("Better Damage Indicator Menu", "THM_Large", Spacing, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP,1,Color(0,0,0,255) )
			THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
		end
	
		local CloseButton = vgui.Create("DButton",BasePanel)
		CloseButton:SetSize(LargeFont,LargeFont)
		CloseButton:SetPos(LW - LargeFont - Spacing,0 + Spacing)
		CloseButton:SetText("")
		function CloseButton:Paint(w,h)
			draw.SimpleTextOutlined("✖", "THM_Large", LargeFont/2, LargeFont/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255) )
			THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
		end
		function CloseButton:DoClick()
			BasePanel:Remove()
		end
		
		local ContentPanel = vgui.Create("DPanel",BasePanel)
		ContentPanel:SetPos(Spacing,Spacing*2 + LargeFont)
		ContentPanel:SetSize(LW - Spacing*2,LH - Spacing*3 - LargeFont)
		function ContentPanel:Paint(w,h)
			THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
		end

		local LW,LH = ContentPanel:GetSize()
		
		local TestPanel = vgui.Create("DPanel",ContentPanel)
		TestPanel:SetPos(Spacing,Spacing)
		TestPanel:SetSize(Spacing*4 + ButtonSize*3,Spacing*5 + ButtonSize*4)
		function TestPanel:Paint(w,h)
			draw.SimpleTextOutlined("Debug", "THM_Large", Spacing, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP,1,Color(0,0,0,255) )
			draw.SimpleTextOutlined("Press button to test", "THM_Small", Spacing, LargeFont, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP,1,Color(0,0,0,255) )
			THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
		end

		local LW,LH = TestPanel:GetSize()
		
			local TestButtonTopLeft = vgui.Create("DButton",TestPanel)
			TestButtonTopLeft:SetSize(ButtonSize,ButtonSize)
			TestButtonTopLeft:SetPos(Spacing,Spacing*2 + ButtonSize)
			TestButtonTopLeft:SetText("")
			function TestButtonTopLeft:Paint(w,h)
				draw.SimpleTextOutlined("↖", "THM_Large", ButtonSize/2, ButtonSize/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,100) )
				THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
			end
			function TestButtonTopLeft:DoClick()
				THM_SendHit(true,false,false,false)
			end
			
			local TestButtonTopCenter = vgui.Create("DButton",TestPanel)
			TestButtonTopCenter:SetSize(ButtonSize,ButtonSize)
			TestButtonTopCenter:SetPos(Spacing*2 + ButtonSize,Spacing*2 + ButtonSize)
			TestButtonTopCenter:SetText("")
			function TestButtonTopCenter:Paint(w,h)
				draw.SimpleTextOutlined("↑", "THM_Large", ButtonSize/2, ButtonSize*0.4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,100) )
				THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
			end
			function TestButtonTopCenter:DoClick()
				THM_SendHit(true,true,false,false)
			end
			
			local TestButtonTopRight = vgui.Create("DButton",TestPanel)
			TestButtonTopRight:SetSize(ButtonSize,ButtonSize)
			TestButtonTopRight:SetPos(Spacing*3 + ButtonSize*2,Spacing*2 + ButtonSize)
			TestButtonTopRight:SetText("")
			function TestButtonTopRight:Paint(w,h)
				draw.SimpleTextOutlined("↗", "THM_Large", ButtonSize/2, ButtonSize/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,100) )
				THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
			end
			function TestButtonTopRight:DoClick()
				THM_SendHit(false,true,false,false)
			end
			
			local TestButtonCenterLeft = vgui.Create("DButton",TestPanel)
			TestButtonCenterLeft:SetSize(ButtonSize,ButtonSize)
			TestButtonCenterLeft:SetPos(Spacing,Spacing*3 + ButtonSize*2)
			TestButtonCenterLeft:SetText("")
			function TestButtonCenterLeft:Paint(w,h)
				draw.SimpleTextOutlined("←", "THM_Large", ButtonSize/2, ButtonSize*0.4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,100) )
				THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
			end
			function TestButtonCenterLeft:DoClick()
				THM_SendHit(true,false,false,true)
			end
			
			local TestButtonCenterCenter = vgui.Create("DButton",TestPanel)
			TestButtonCenterCenter:SetSize(ButtonSize,ButtonSize)
			TestButtonCenterCenter:SetPos(Spacing*2 + ButtonSize*1,Spacing*3 + ButtonSize*2)
			TestButtonCenterCenter:SetText("")
			function TestButtonCenterCenter:Paint(w,h)
				draw.SimpleTextOutlined("⬤", "THM_Large", ButtonSize/2, ButtonSize*0.4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,100) )
				THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
			end
			function TestButtonCenterCenter:DoClick()
				THM_SendHit(true,true,true,true)
			end
			
			local TestButtonCenterRight = vgui.Create("DButton",TestPanel)
			TestButtonCenterRight:SetSize(ButtonSize,ButtonSize)
			TestButtonCenterRight:SetPos(Spacing*3 + ButtonSize*2,Spacing*3 + ButtonSize*2)
			TestButtonCenterRight:SetText("")
			function TestButtonCenterRight:Paint(w,h)
				draw.SimpleTextOutlined("→", "THM_Large", ButtonSize/2, ButtonSize*0.4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,100) )
				THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
			end
			function TestButtonCenterRight:DoClick()
				THM_SendHit(false,true,true,false)
			end
			
			local TestButtonBottomLeft = vgui.Create("DButton",TestPanel)
			TestButtonBottomLeft:SetSize(ButtonSize,ButtonSize)
			TestButtonBottomLeft:SetPos(Spacing*1 + ButtonSize*0,Spacing*4 + ButtonSize*3)
			TestButtonBottomLeft:SetText("")
			function TestButtonBottomLeft:Paint(w,h)
				draw.SimpleTextOutlined("↙", "THM_Large", ButtonSize/2, ButtonSize/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,100) )
				THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
			end
			function TestButtonBottomLeft:DoClick()
				THM_SendHit(false,false,false,true)
			end
			
			local TestButtonBottomCenter = vgui.Create("DButton",TestPanel)
			TestButtonBottomCenter:SetSize(ButtonSize,ButtonSize)
			TestButtonBottomCenter:SetPos(Spacing*2 + ButtonSize*1,Spacing*4 + ButtonSize*3)
			TestButtonBottomCenter:SetText("")
			function TestButtonBottomCenter:Paint(w,h)
				draw.SimpleTextOutlined("↓", "THM_Large", ButtonSize/2, ButtonSize*0.4, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,100) )
				THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
			end
			function TestButtonBottomCenter:DoClick()
				THM_SendHit(false,false,true,true)
			end
			
			local TestButtonBottomRight = vgui.Create("DButton",TestPanel)
			TestButtonBottomRight:SetSize(ButtonSize,ButtonSize)
			TestButtonBottomRight:SetPos(Spacing*3 + ButtonSize*2,Spacing*4 + ButtonSize*3)
			TestButtonBottomRight:SetText("")
			function TestButtonBottomRight:Paint(w,h)
				draw.SimpleTextOutlined("↘", "THM_Large", ButtonSize/2, ButtonSize/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,100) )
				THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
			end
			function TestButtonBottomRight:DoClick()
				THM_SendHit(false,false,true,false)
			end
			
		local LW,LH = ContentPanel:GetSize()
		
		local ColorPanel = vgui.Create("DPanel",ContentPanel)
		ColorPanel:SetPos(Spacing*6 + ButtonSize*3,Spacing)
		ColorPanel:SetSize(Spacing*5 + ButtonSize*4,Spacing*5 + ButtonSize*4)
		function ColorPanel:Paint(w,h)
			draw.SimpleTextOutlined("Hit Color", "THM_Large", Spacing, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP,1,Color(0,0,0,255) )
			THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
		end	
		
			local LW,LH = ColorPanel:GetSize()

			local ColorMixer = vgui.Create( "DColorMixer", ColorPanel )
			ColorMixer:SetPos(Spacing,Spacing + LargeFont)
			ColorMixer:SetSize(LW - Spacing*2,LH - Spacing*2 - LargeFont)
			ColorMixer:SetPalette( false )
			ColorMixer:SetAlphaBar( false )
			ColorMixer:SetWangs( false )	
			ColorMixer:SetColor( HitColor )	--Set the default color
			ColorMixer:SetConVarR("cl_burhit_color_r")
			ColorMixer:SetConVarG("cl_burhit_color_g")
			ColorMixer:SetConVarB("cl_burhit_color_b")
			function ColorMixer:ValueChanged()
				THM_SendHit(true,true,true,true)
			end
			
		--THM_SendHit(true,true,true,true)
		--THM_SendHit(true,true,true,true)
		
		local LW,LH = ContentPanel:GetSize()
			
		local SettingsPanel = vgui.Create("DPanel",ContentPanel)
		SettingsPanel:SetPos(Spacing*12 + ButtonSize*7,Spacing)
		SettingsPanel:SetSize(Spacing*5 + ButtonSize*4,Spacing*5 + ButtonSize*4)
		function SettingsPanel:Paint(w,h)
			draw.SimpleTextOutlined("Other Settings", "THM_Large", Spacing, 0, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP,1,Color(0,0,0,255) )
			THM_Paint(w,h,Color( 255, 255, 255 , 100 ))
		end	
		
		local LW,LH = SettingsPanel:GetSize()
		
			local CheckEnabled = vgui.Create( "DCheckBoxLabel",SettingsPanel ) 
			CheckEnabled:SetPos( Spacing, Spacing + LargeFont )
			CheckEnabled:SetText( "Enable Damage Indicators" )
			CheckEnabled:SetValue(GetConVar("cl_burhit_enable"):GetInt())
			CheckEnabled:SetFont("THM_Small")
			CheckEnabled:SetTextColor(Color(0,0,0,255))
			CheckEnabled:SizeToContents()
			function CheckEnabled:OnChange(Value)
			
				if Value == true then
					Value = 1
				else
					Value = 0
				end
			
				RunConsoleCommand("cl_burhit_enable",Value)

			end


end

concommand.Add("cl_burhit_menu",THM_Menu)

function THM_HUDShouldDraw(name)
	if name=="CHudDamageIndicator" then
		return false
	end
end

hook.Add( "HUDShouldDraw", "THM_HUDShouldDraw", THM_HUDShouldDraw)

