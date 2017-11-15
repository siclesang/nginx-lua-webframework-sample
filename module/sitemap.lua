#!/usr/bin/env lua

lfs = require "lfs"

local map = {}


config=require "config"
map.root_dir=config.content_root_dir
--map.root_dir=nil



function map.setrootdir(directory)
	map.root_dir=directory
end


function map.getrootdir()
	print("map.root_dir:"..map.root_dir)
end


function map.children(directory)
	
	local child={}

	if directory == nil
	then
		directory = map.root_dir
	end
	--ngx.print(directory.."<br>")
	for dir in lfs.dir(directory) do
		if string.find(dir,"%.") == nil
		then
			table.insert(child,dir)
		end
	end
	--ngx.say(table.concat(child,","))
	return child
end


function map.sitemap()
        local table=map.children()
        return table
end

return map
