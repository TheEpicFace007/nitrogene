-- https://developers.google.com/custom-search/v/introduction#identify_your_application_to_google_with_api_key
-- https://any-api.com/googleapis_com/customsearch/docs/cse/search_cse_siterestrict_list
local HttpService = game:GetService("HttpService")
api = {}

api.parseSearch = function (searchTerm)
    searchTerm = string.gsub(searchTerm," ","+")
    local searchResult = game:HttpPostAsync(
        "https://duckduckgo.com/lite/" ,                      -- url
        "q=site%3Apastebin.com+" .. searchTerm .. "&kl=&df=", -- post data
        "text/html; charset=UTF-8",                           -- content type
        true,                                                   -- comptess
        [[
Host: duckduckgo.com
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Referer: https://duckduckgo.com/
Content-Type: application/x-www-form-urlencoded
Content-Length: 44
Origin: https://duckduckgo.com
DNT: 1
Connection: keep-alive
Upgrade-Insecure-Requests: 1
        ]]
    )
end
