#!/usr/bin/lua
local fn=require"filenodes"
local p=require"posix"

local start="/usr"

local inodes=require"inodes"
local files=0
local dirents=0
local depth=0
local directories=0
local function recursedir(dir,inodes)
	depth=depth+1
	directories=directories+1
	local rs=0
	local vs=0
	for nm,ino,t in fn.files(dir)
	do
		dirents=dirents+1
		--print(nm,ino,t)
		if nm == "." or nm == ".."
		then
		elseif t==4
		then
			local rrs,rvs=recursedir(dir .. "/"..nm,inodes)
			rs=rs+rrs
			vs=vs+rvs
		elseif inodes[ino] ~= nil
		then
			vs=vs+inodes[ino]
			--print(nm,ino,inodes[ino])
		else
			local s=p.stat(dir .. "/".. nm)
			--print(dir .. "/".. nm)
			if s~=nil
			then
				inodes[ino]=s.size
				files=files+1
				rs=rs+s.size
				vs=vs+s.size
			end
			--print(nm,ino,inodes[ino])
		end
	end
	if depth < 6
	then
--	print(depth,dir, rs,vs,files,dirents,directories)
	end
	depth=depth-1
	return rs,vs
end
recursedir(start,inodes)
print("Total:",files,dirents)
local f=assert(io.open("inodes.txt","wb"))
f:write("inodes={")
local first=""
for i,v in pairs(inodes) do
	f:write(first,"[",i,"]=",inodes[i])
	first=","
end
f:write("}")
f:close()
--[[
	recursedir()
	grouped-depth level
	max-width-depth
]]
