print("K-Mail loaded..")

if SERVER then
	include("kmail/init.lua")
else
	include("kmail/cl_init.lua")
end
