local p=require"posix"
files,errstr,errno=p.dir(".");
if files then
	for a,b in ipairs(files) do
		print(a,b)
	end
else
	print(errstr)
end
