-- this code probably isnt the most elegant
-- butidontcarelolitworks
-- created by MintyLatios aka Nebula
--  https://v3rmillion.net/showthread.php?tid=938167
if(shared.RoStrap)then return shared.RoStrap end
function getGithubSource(link) -- credit to rostrap team for part of this
	local Website, Directory = link:match("^(https://[raw%.]*github[usercontent]*%.com/)(.+)")
	if(Website~='https://raw.githubusercontent.com/')then return "return 'invalid'" end
	return game:HttpGetAsync(link)
end


local r = {Tables={}}
local gets = Instance.new("Folder")
r.LoadedLibraries = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ViniDalvino/Libraries/master/Libraries.lua"))()

r.Libraries = {}

function escape_pattern(text)
    return text:gsub("([^%w])", "%%%1")
end

function fixSource(str)
    local fixed = ''
    fixed=str:gsub(escape_pattern[[require(game:GetService("ReplicatedStorage"):WaitForChild("Resources"))]],escape_pattern"shared.RoStrap")
    fixed=fixed:gsub(escape_pattern[[require(ReplicatedStorage:WaitForChild("Resources"))]],escape_pattern"shared.RoStrap")
    return fixed;
end

r.LoadLibrary=function(self,s)
	if(not self.Libraries[s])then
		repeat wait() until self.Libraries[s]
	end
	if(self.Libraries[s])then
		if(self.Libraries[s]=='invalid')then
			return error("That isn't a RoStrap-created library!")
		end
		return self.Libraries[s]
	end
	--[[if(self.LoadedLibraries[s])then
		local library = loadstring(fixSource(getGithubSource(self.LoadedLibraries[s].URL)))()
		self.Libraries[s]=library
		return library
	else
		error("That isn't a valid library!")
	end]]
end
r.GetLocalTable=function(self,s)
	if(not self.Tables[s])then self.Tables[s]={} end
	return self.Tables[s]
end

setmetatable(r,{
	__index=function(s,i)
		if(i:sub(1,3)=='Get' and i~='GetLocalTable')then
			local class = i:sub(4)
			return function(self,name)
				local parent = gets:FindFirstChild(class) or Instance.new("Folder",gets)
				parent.Name=class
				local inst = parent:FindFirstChild(name) or Instance.new(class)
				inst.Name=name
				inst.Parent=parent
				return inst
			end
		end
		return rawget(s,i)
	end
})

shared.RoStrap=r

print'caching libraries.'
local threads = {}
for name,data in next, r.LoadedLibraries do 
	local c = coroutine.create(function()
		local source = getGithubSource(data.URL)
		if(source~="return 'invalid'")then
			local x,y = pcall(function() r.Libraries[name]=loadstring(fixSource(source))() end)
			if(not x)then warn("error on "..name..": "..y) end
		end
	end)
	table.insert(threads,c)
	coroutine.resume(c)
end

repeat wait()
	local deadThreads={}
	for i = 1,#threads do
		local c = threads[i]
		if(coroutine.status(c)=='dead')then
			table.insert(deadThreads,i)
		end
	end
	for i = 1,#deadThreads do
		table.remove(threads,deadThreads[i])
	end
until #threads==0

print'all g'

return r