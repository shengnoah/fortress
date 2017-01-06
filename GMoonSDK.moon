class GMoonSDK
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
        headers= {
            'Authorization': auth, 
            'Accept': 'application/json'
        }
        return headers 

    @author: (username, password, host, port) =>
        self.uname = username
        self.pwd = password 
        self.host = host
        self.port = port
        self.url = "http://"..host..":"..port
        self.headers_info = self\build_headers()
        return self.url

    @get_request:(req_url) =>
        body, status_code, headers = http.simple {
            url: req_url 
            method: "GET"
            headers: self.headers_info 
        }
        return body

    @call: (s_type, s_param) =>
        --get param list
        info = self.endpoints[s_type]
        key = ''
        for k,v in pairs info
            key = k 

        --check param
        str = ''
        for k,v in pairs info[key]
            str = str..s_param[v]

        --encode url 
        url_data = ngx.encode_args(s_param)
        tmp_url = self.url..key.."?"
        req_url = tmp_url..url_data

        --HTTP GET request
        ret = self\get_request req_url
        return ret

