local KEY="Jakobpanel123"
local env=(getgenv and getgenv()) or _G
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local lp=game:GetService("Players").LocalPlayer
local cam=workspace.CurrentCamera
local par=(gethui and gethui()) or game:GetService("CoreGui")
pcall(function() if par:FindFirstChild("BluePanel") then par.BluePanel:Destroy() end end)
local BLUE,DARK,LIGHT=Color3.fromRGB(30,100,255),Color3.fromRGB(15,35,90),Color3.fromRGB(0,190,255)
local W=Color3.new(1,1,1)

local function new(c,p,t)
 local o=Instance.new(c) for k,v in pairs(t) do o[k]=v end o.Parent=p return o
end
local function rnd(o,r) new("UICorner",o,{CornerRadius=UDim.new(0,r)}) end
local function drag(h,t)
 local d,s,sp
 h.InputBegan:Connect(function(i)
  if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
   d,s,sp=true,i.Position,t.Position
   i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end)
  end
 end)
 UIS.InputChanged:Connect(function(i)
  if d and (i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement) then
   local v=i.Position-s
   t.Position=UDim2.new(sp.X.Scale,sp.X.Offset+v.X,sp.Y.Scale,sp.Y.Offset+v.Y)
  end
 end)
end
local function hum() local c=lp.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function root() local c=lp.Character return c and c:FindFirstChild("HumanoidRootPart") end

local gui=new("ScreenGui",par,{Name="BluePanel",ResetOnSpawn=false})

local function build()
 local main=new("Frame",gui,{Size=UDim2.new(0,230,0,330),Position=UDim2.new(0.5,-115,0.5,-165),BackgroundColor3=DARK,BorderSizePixel=0})
 rnd(main,14)
 local top=new("TextLabel",main,{Size=UDim2.new(1,0,0,34),BackgroundColor3=BLUE,Text="Admin Panel",TextColor3=W,Font=Enum.Font.GothamBold,TextSize=16})
 rnd(top,14) drag(top,main)
 local list=new("ScrollingFrame",main,{Size=UDim2.new(1,-16,1,-44),Position=UDim2.new(0,8,0,40),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y})
 new("UIListLayout",list,{Padding=UDim.new(0,4)})

 local function toggle(name,cb)
  local b=new("TextButton",list,{Size=UDim2.new(1,0,0,32),BackgroundColor3=BLUE,Text=name..": OFF",TextColor3=W,Font=Enum.Font.GothamMedium,TextSize=14})
  rnd(b,8)
  local on=false
  b.MouseButton1Click:Connect(function()
   on=not on
   b.Text=name..": "..(on and "ON" or "OFF")
   b.BackgroundColor3=on and LIGHT or BLUE
   cb(on)
  end)
 end
 local function input(name,def,cb)
  local f=new("Frame",list,{Size=UDim2.new(1,0,0,32),BackgroundTransparency=1})
  new("TextLabel",f,{Size=UDim2.new(0.5,0,1,0),BackgroundTransparency=1,Text=name,TextColor3=W,Font=Enum.Font.GothamMedium,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left})
  local t=new("TextBox",f,{Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0.5,0,0,0),BackgroundColor3=Color3.fromRGB(25,60,150),Text=tostring(def),TextColor3=W,Font=Enum.Font.Gotham,TextSize=14,ClearTextOnFocus=false})
  rnd(t,8)
  t.FocusLost:Connect(function()
   local n=tonumber(t.Text)
   if n then cb(n) else t.Text=tostring(def) end
  end)
 end
 env.BP={gui=gui,toggle=toggle,input=input}

 -- FLY
 local fs,bv,bg,fc=60,nil,nil,nil
 input("Fly hitrost",fs,function(n) fs=n end)
 toggle("Fly",function(on)
  local r,h=root(),hum()
  if on and r and h then
   bv=new("BodyVelocity",r,{MaxForce=Vector3.new(9e9,9e9,9e9),Velocity=Vector3.zero})
   bg=new("BodyGyro",r,{MaxTorque=Vector3.new(9e9,9e9,9e9),P=9e4})
   h.PlatformStand=true
   fc=RS.RenderStepped:Connect(function()
    local hh=hum()
    if not(hh and bv and bg) then return end
    local lv=cam.CFrame:VectorToObjectSpace(hh.MoveDirection)
    bv.Velocity=cam.CFrame.RightVector*lv.X*fs+cam.CFrame.LookVector*-lv.Z*fs
    bg.CFrame=cam.CFrame
   end)
  else
   if fc then fc:Disconnect() fc=nil end
   if bv then bv:Destroy() bv=nil end
   if bg then bg:Destroy() bg=nil end
   if h then h.PlatformStand=false end
  end
 end)

 -- NOCLIP
 local nc
 toggle("Noclip",function(on)
  if on then
   nc=RS.Stepped:Connect(function()
    local c=lp.Character
    if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
   end)
  elseif nc then nc:Disconnect() nc=nil end
 end)

 -- SPEED
 local sv,sc=50,nil
 input("Speed",sv,function(n) sv=n end)
 toggle("Speed",function(on)
  if on then
   sc=RS.Heartbeat:Connect(function() local h=hum() if h then h.WalkSpeed=sv end end)
  else
   if sc then sc:Disconnect() sc=nil end
   local h=hum() if h then h.WalkSpeed=16 end
  end
 end)

 -- SKRIJ / POKAŽI
 local o=new("TextButton",gui,{Size=UDim2.new(0,46,0,46),Position=UDim2.new(0,10,0.5,-23),BackgroundColor3=BLUE,Text="☰",TextColor3=W,TextSize=22,Font=Enum.Font.GothamBold})
 rnd(o,23) drag(o,o)
 o.MouseButton1Click:Connect(function() main.Visible=not main.Visible end)
end

-- KEY SISTEM
local kf=new("Frame",gui,{Size=UDim2.new(0,260,0,170),Position=UDim2.new(0.5,-130,0.5,-85),BackgroundColor3=DARK,BorderSizePixel=0})
rnd(kf,14) drag(kf,kf)
local kt=new("TextLabel",kf,{Size=UDim2.new(1,0,0,40),BackgroundColor3=BLUE,Text="Vnesi ključ",TextColor3=W,Font=Enum.Font.GothamBold,TextSize=16})
rnd(kt,14)
local box=new("TextBox",kf,{Size=UDim2.new(1,-30,0,36),Position=UDim2.new(0,15,0,55),BackgroundColor3=Color3.fromRGB(25,60,150),PlaceholderText="Ključ...",Text="",TextColor3=W,Font=Enum.Font.Gotham,TextSize=14,ClearTextOnFocus=false})
rnd(box,8)
local btn=new("TextButton",kf,{Size=UDim2.new(1,-30,0,36),Position=UDim2.new(0,15,0,100),BackgroundColor3=BLUE,Text="Potrdi",TextColor3=W,Font=Enum.Font.GothamBold,TextSize=15})
rnd(btn,8)
local msg=new("TextLabel",kf,{Size=UDim2.new(1,0,0,22),Position=UDim2.new(0,0,1,-26),BackgroundTransparency=1,Text="",TextColor3=Color3.fromRGB(255,120,120),Font=Enum.Font.Gotham,TextSize=13})
btn.MouseButton1Click:Connect(function()
 local v=box.Text:gsub("%s+",""):lower()
 if v==KEY:lower() then kf:Destroy() build() else msg.Text="Napačen ključ!" end
end)local env=(getgenv and getgenv()) or _G
local BP=env.BP
if not BP then warn("Najprej zaženi 1. del in vnesi ključ!") return end
local P=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local L=game:GetService("Lighting")
local lp=P.LocalPlayer
local gui,toggle,input=BP.gui,BP.toggle,BP.input
local function hum() local c=lp.Character return c and c:FindFirstChildOfClass("Humanoid") end

-- JPOWER
local jv,jc=100,nil
input("JPower",jv,function(n) jv=n end)
toggle("JPower",function(on)
 if on then
  jc=RS.Heartbeat:Connect(function()
   local h=hum() if h then h.UseJumpPower=true h.JumpPower=jv end
  end)
 else
  if jc then jc:Disconnect() jc=nil end
  local h=hum() if h then h.JumpPower=50 end
 end
end)

-- INF JUMP
local ij
toggle("Inf Jump",function(on)
 if on then
  ij=UIS.JumpRequest:Connect(function()
   local h=hum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
  end)
 elseif ij then ij:Disconnect() ij=nil end
end)

-- FULLBRIGHT
local old,fb={},nil
toggle("Fullbright",function(on)
 if on then
  old={Brightness=L.Brightness,ClockTime=L.ClockTime,FogEnd=L.FogEnd,GlobalShadows=L.GlobalShadows,Ambient=L.Ambient}
  fb=RS.RenderStepped:Connect(function()
   L.Brightness=2 L.ClockTime=14 L.FogEnd=1e6
   L.GlobalShadows=false L.Ambient=Color3.new(1,1,1)
  end)
 else
  if fb then fb:Disconnect() fb=nil end
  for k,v in pairs(old) do L[k]=v end
 end
end)

-- ESP
local eo,ec={},{}
local function addESP(plr)
 if plr==lp then return end
 local function apply(c)
  if not c then return end
  local hl=Instance.new("Highlight")
  hl.FillColor=Color3.fromRGB(0,140,255)
  hl.OutlineColor=Color3.new(1,1,1)
  hl.FillTransparency=0.5
  hl.Adornee=c
  hl.Parent=gui
  table.insert(eo,hl)
  local head=c:WaitForChild("Head",5)
  if head then
   local bb=Instance.new("BillboardGui")
   bb.Size=UDim2.new(0,100,0,20)
   bb.StudsOffset=Vector3.new(0,2.5,0)
   bb.AlwaysOnTop=true
   bb.Adornee=head
   bb.Parent=gui
   local t=Instance.new("TextLabel")
   t.Size=UDim2.new(1,0,1,0)
   t.BackgroundTransparency=1
   t.Text=plr.Name
   t.TextColor3=Color3.new(1,1,1)
   t.TextStrokeTransparency=0
   t.Font=Enum.Font.GothamBold
   t.TextSize=13
   t.Parent=bb
   table.insert(eo,bb)
  end
 end
 apply(plr.Character)
 table.insert(ec,plr.CharacterAdded:Connect(apply))
end
toggle("ESP",function(on)
 if on then
  for _,p in ipairs(P:GetPlayers()) do addESP(p) end
  table.insert(ec,P.PlayerAdded:Connect(addESP))
 else
  for _,c in ipairs(ec) do c:Disconnect() end
  ec={}
  for _,o in ipairs(eo) do pcall(function() o:Destroy() end) end
  eo={}
 end
end)
