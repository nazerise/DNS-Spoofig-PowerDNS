local http = require "socket"
local https = require("ssl.https")
https.TIMEOUT = 0.6
local ac = "0"

myrecords = newDS()
myrecords:add({ 'google.com', 'github.com'})

function page(p)
    res, code, headers, status = https.request{
         url = p,
         headers =
         {
         ["Request Method"] = GET,
         },
         source = ltn12.source.string(request_body),
         sink = ltn12.sink.table(response_body),
        }
	return rec, code, headers, status
end


function preresolve(dq)
        local urls = string.format("%s", dq.qname:toStringNoDot())
	local httpsurl = "https://" .. urls
        pdnslog(httpsurl)
	if myrecords:check(dq.qname) then
               	pdnslog("Match with myrecords")
        else
		page(httpsurl)
		local st = string.format("%s", code)
		pdnslog("NOt match url :: " .. httpsurl .. " Status code:: " .. st)
		if st == "timeout" or st == "wantread" then
       	                dq.variable = false
       	                pdnslog("NO ACCESS Changing content 1! " .. urls)
	                dq.rcode=0 -- make it a normal answer
        	        dq:addAnswer(pdns.A, "192.168.1.100", 60, urls)
              	        ac = "1"
	                return true
		end
		if status then
			if headers["content-length"] ~= "0" then
				local r = string.match(status, "30%d+")
				if r then
					st = "200"
       		                end
				if st == "503" then
					return false
				end
		    	   	if st ~= "200" or st == "timeout" then
                	       		pdnslog("NO ACCESS Changing content! " .. urls)
					dq.rcode=0 -- make it a normal answer
		        	        dq:addAnswer(pdns.A, "192.168.1.100", 3600, urls)
					ac = "2"
					return true
				end
			end
		end
	end
	return false
end

function postresolve(dq)
	if ac == "1" or ac == "2" then
		return false
	else
		return true
	end
end
