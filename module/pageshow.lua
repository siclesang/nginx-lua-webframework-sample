#!/usr/bin/env lua


local _M = {}


--将整个页面分成多个部分，每个部分都有自己的模板

--part 对应 ../template/part.html
function _M.partp(part,vars)
	local temp=require("template")
        local tf="../template/"..part..".html"
        temp.setVars(vars)
        temp.setTemplateFile(tf)
        return temp.templateParse()
end

--header template
function _M.headerPage()
	return _M.partp("header",{})
end

--sitemap template
function _M.sitemapPage()
	local config=require("config")
	local sitemap=require("sitemap")
	local maps={}
        maps["table"]=sitemap.sitemap()
        maps["domain"]=config.domain
	return _M.partp("sitemap",maps)
end

--body template
function _M.bodyPage(templatename,inputtable)
	return _M.partp(templatename,inputtable)
end

--footer template
function _M.footerPage()
	return _M.partp("footer",{})
end

--默认网页布局都相同，只有body内容不同，将body模板名字和传入变量table当入参
function _M.pageShow(bodyTemplateName,bodyVarsTable)
        --模板调用
        local temp=require("template")
        
        --传入模板参数table 
        --ta={header=header_text,sitemap=sitemap_text,body=body_text,footer=footer_text}
        local ta={}

        --页面又嵌套了4个模板，将页面分为四个部分
        --header
        ta["header"]=_M.headerPage()

        --sitemap
        ta["sitemap"]=_M.sitemapPage()

        --boday
        ta["body"]=_M.bodyPage(bodyTemplateName,bodyVarsTable)

        --footer
        ta["footer"]=_M.footerPage()

        --页面模板
        tft="../template/page.html"
        temp.setVars(ta)
        temp.setTemplateFile(tft)
        temp.templateRun()

end


--index
function _M.indexShow()
	_M.pageShow("indexbody",{})
end

--articles
function _M.articlesShow()
	local atcls=require "articles"
	local config=require "config"
	local req=require "reqinit"
	local vars={}
	
	vars["authtable"]={}
	vars["authtitlestable"]={}


	local auth,ti=req.getarg("auth","title")
	if auth == nil then
		auth="N"
	end
	
	if ti ==nil then
		ti="N"
	end

	vars["auth"]=auth
	vars["title"]=ti
	--vars["contents"]=nil

	if auth == "N" then
		vars["authtable"]=atcls.getauth()
	else
		if ti == "N" then
			vars["authtitlestable"]=atcls.getAuthTitles(auth)
		else
			vars["contents"]=atcls.getAuthTitleContent(auth,ti)
			--print(type(vars["contents"]))
		end
	end
	--vars["authtable"]=atcls.getauth()
	vars["domain"]=config.domain

	
	
	_M.pageShow("articlesbody",vars)
end


return _M
