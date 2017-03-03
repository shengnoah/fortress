import encode_base64 from require "lapis.util.encoding"

class RestyGraylog 
    pwd: ""
    uname: ""
    headers_info: ""
    endpoints: {
        's_uat':{'/search/universal/absolute/terms':{'field', 'query', 'from', 'to', 'limit'} }
        's_ua':{'/search/universal/absolute':{'fields', 'query', 'from', 'to', 'limit'} }
        's_urt':{'/search/universal/relative/terms':{'field', 'query', 'range'} }
        's_ut':{'/search/universal/relative':{'fields', 'query', 'range'} }
    }


    @build_headers: =>
        auth = "Basic "..encode_base64(self.uname..":"..self.pwd)
        print(auth)
        headers= {
            'Authorization': auth, 
            'Accept': '*/*',
            'Content-Type':'application/json'
        }
        return headers 


    @auth: (username, password, host, port) =>
        errList = {}
        if type(port) == 'nil'
            table.insert(errList, "port is nil\n")
        if type(host) == 'nil'
            table.insert(errList, "host is nil\n")
        if type(password) == 'nil'
            table.insert(errList, "password is nil\n")
        if type(username) == 'table'
            table.insert(errList, "username is nil\n")

        num = table.getn(errList) 
        if num > 0 
            return errList

        self.uname = username
        self.pwd = password 
        self.host = host
        self.port = port
        self.url = "http://"..host..":"..port
        self.auth = "Basic "..encode_base64(self.uname..":"..self.pwd)
        self.headers_info = self\build_headers()
        return self.url


    @getRequestSimple:(req_url) =>
        body, status_code, headers = http.simple {
            url: req_url 
            method: "GET"
            headers: self.headers_info 
        }
        return body



    @postRequest:(req_url, data) =>
        http = require "resty.http"
        httpc = http.new()
        metadata = {
          method:"PUT",
          body: data,
          headers: self.headers_info
        }

        res, err = httpc\request_uri(req_url, metadata)
        if not res
          ngx.say("failed to request: ", err)
          return

        ngx.status = res.status
        return res.body


    @checkParam:(s_type, s_param) =>
        --Check configuration info
        if type(self.url) == "nil"
            return 'auth info err.'

        --Check type  
        info = self.endpoints[s_type]
        chk_flg = type(info)
        if chk_flg == "nil"
            return "Input parameter error,unknow type."

        --Get master key
        key = ''
        for k,v in pairs info
            key = k 

        --Check param
        str = ''
        for k,v in pairs info[key]
            if type(s_param[v]) == 'nil'
                return info[key][k]..":is nil"
            str = str..s_param[v]
        return "OK", str

    @call: (s_type, s_param) =>
        --Get master key
        key = ''
        for k,v in pairs self.endpoints[s_type]
            key = k 

        --encode url 
        url_data = ngx.encode_args(s_param)
        tmp_url = self.url..key.."?"
        req_url = tmp_url..url_data

        --HTTP GET request
        ret = self\getRequest req_url
        return ret


    @dealStream: (s_type, s_param) =>
        ret = ''
        status, param_list = GMoonSDK\checkParam s_type, s_param
        if status == "OK"
            ret = GMoonSDK\call s_type, s_param
        else 
            ret = status 
        return ret


    @putRequest:(req_url, data) =>
        http = require "resty.http"
        httpc = http.new()
        metadata = {
          method:"PUT",
          body: data,
          headers: self.headers_info
        }

        res, err = httpc\request_uri(req_url, metadata)

        if not res
          ngx.say("failed to request: ", err)
          return
        return res.body


    @updateWidget: (dashboardId, widgetId,jsonBody) =>
        errList = {}
        if type(dashboardId) == 'nil'
            table.insert(errList, "dashboard id is nil\n")

        if type(widgetId) == 'nil'
            table.insert(errList, "widget id is nil\n")

        if type(jsonBody) == 'nil'
            table.insert(errList, "json body is nil\n")

        num = table.getn(errList) 
        if num > 0 
            return errList


        url = "http://"..self.host..":"..self.port
        req_url = url..'/dashboards/'..dashboardId..'/widgets/'..widgetId

        self.headers_info = {
            'Authorization': self.auth, 
            'Accept': '*/*',
            'Content-Type':'application/json'
        }

        self\putRequest req_url, jsonBody
        return 1


    @getRequest:(req_url) =>
        http = require "resty.http"
        httpc = http.new()
        metadata = {
          method:"GET",
          headers: self.headers_info
        }

        res, err = httpc\request_uri(req_url, metadata)

        if not res
          ngx.say("failed to request: ", err)
          return

        ngx.status = res.status
        return res.body


    @getWidgetValue: (dashboardId, widgetId) =>
        errList = {}
        if type(dashboardId) == 'nil'
            table.insert(errList, "dashboard id is nil\n")

        if type(widgetId) == 'nil'
            table.insert(errList, "widget id is nil\n")

        num = table.getn(errList) 
        if num > 0 
            return errList

        url = "http://"..self.host..":"..self.port
        req_url = url..'/dashboards/'..dashboardId..'/widgets/'..widgetId..'/value'

        self.headers_info = {
            'Authorization': self.auth, 
            'Accept': 'application/json',
        }

        ret = self\getRequest req_url
        return ret
