local ffi = require "ffi"
local bit = require "bit"
local uv  = require "uv"

local core = require('core');

local _lib = require('ffi-loader')(module.dir, "zmq.h")
local _ctx =  _lib.zmq_ctx_new();
local zmq  = {};

zmq.DONTWAIT = _lib.ZMQ_DONTWAIT;
zmq.SNDMORE  = _lib.ZMQ_SNDMORE;

-- sock opt -----
zmq.AFFINITY = _lib.ZMQ_AFFINITY;
zmq.IDENTITY = _lib.ZMQ_IDENTITY;
zmq.SUBSCRIBE = _lib.ZMQ_SUBSCRIBE;
zmq.UNSUBSCRIBE = _lib.ZMQ_UNSUBSCRIBE;
zmq.RATE = _lib.ZMQ_RATE;
zmq.RECOVERY_IVL = _lib.ZMQ_RECOVERY_IVL;
zmq.SNDBUF = _lib.ZMQ_SNDBUF;
zmq.RCVBUF = _lib.ZMQ_RCVBUF;
zmq.RCVMORE = _lib.ZMQ_RCVMORE;
zmq.FD = _lib.ZMQ_FD;
zmq.EVENTS = _lib.ZMQ_EVENTS;
zmq.TYPE = _lib.ZMQ_TYPE;
zmq.LINGER = _lib.ZMQ_LINGER;
zmq.RECONNECT_IVL = _lib.ZMQ_RECONNECT_IVL;
zmq.BACKLOG = _lib.ZMQ_BACKLOG;
zmq.RECONNECT_IVL_MAX = _lib.ZMQ_RECONNECT_IVL_MAX;
zmq.MAXMSGSIZE = _lib.ZMQ_MAXMSGSIZE;
zmq.SNDHWM = _lib.ZMQ_SNDHWM;
zmq.RCVHWM = _lib.ZMQ_RCVHWM;
zmq.MULTICAST_HOPS = _lib.ZMQ_MULTICAST_HOPS;
zmq.RCVTIMEO = _lib.ZMQ_RCVTIMEO;
zmq.SNDTIMEO = _lib.ZMQ_SNDTIMEO;
zmq.LAST_ENDPOINT = _lib.ZMQ_LAST_ENDPOINT;
zmq.ROUTER_MANDATORY = _lib.ZMQ_ROUTER_MANDATORY;
zmq.TCP_KEEPALIVE = _lib.ZMQ_TCP_KEEPALIVE;
zmq.TCP_KEEPALIVE_CNT = _lib.ZMQ_TCP_KEEPALIVE_CNT;
zmq.TCP_KEEPALIVE_IDLE = _lib.ZMQ_TCP_KEEPALIVE_IDLE;
zmq.TCP_KEEPALIVE_INTVL = _lib.ZMQ_TCP_KEEPALIVE_INTVL;
zmq.TCP_ACCEPT_FILTER = _lib.ZMQ_TCP_ACCEPT_FILTER;
zmq.IMMEDIATE = _lib.ZMQ_IMMEDIATE;
zmq.XPUB_VERBOSE = _lib.ZMQ_XPUB_VERBOSE;
zmq.ROUTER_RAW = _lib.ZMQ_ROUTER_RAW;
zmq.IPV6 = _lib.ZMQ_IPV6;
zmq.MECHANISM = _lib.ZMQ_MECHANISM;
zmq.PLAIN_SERVER = _lib.ZMQ_PLAIN_SERVER;
zmq.PLAIN_USERNAME = _lib.ZMQ_PLAIN_USERNAME;
zmq.PLAIN_PASSWORD = _lib.ZMQ_PLAIN_PASSWORD;
zmq.CURVE_SERVER = _lib.ZMQ_CURVE_SERVER;
zmq.CURVE_PUBLICKEY = _lib.ZMQ_CURVE_PUBLICKEY;
zmq.CURVE_SECRETKEY = _lib.ZMQ_CURVE_SECRETKEY;
zmq.CURVE_SERVERKEY = _lib.ZMQ_CURVE_SERVERKEY;
zmq.PROBE_ROUTER = _lib.ZMQ_PROBE_ROUTER;
zmq.REQ_CORRELATE = _lib.ZMQ_REQ_CORRELATE;
zmq.REQ_RELAXED = _lib.ZMQ_REQ_RELAXED;
zmq.CONFLATE = _lib.ZMQ_CONFLATE;
zmq.ZAP_DOMAIN = _lib.ZMQ_ZAP_DOMAIN;
zmq.ROUTER_HANDOVER = _lib.ZMQ_ROUTER_HANDOVER;
zmq.TOS = _lib.ZMQ_TOS;
zmq.IPC_FILTER_PID = _lib.ZMQ_IPC_FILTER_PID;
zmq.IPC_FILTER_UID = _lib.ZMQ_IPC_FILTER_UID;
zmq.IPC_FILTER_GID = _lib.ZMQ_IPC_FILTER_GID;
zmq.CONNECT_RID = _lib.ZMQ_CONNECT_RID;
zmq.GSSAPI_SERVER = _lib.ZMQ_GSSAPI_SERVER;
zmq.GSSAPI_PRINCIPAL = _lib.ZMQ_GSSAPI_PRINCIPAL;
zmq.GSSAPI_SERVICE_PRINCIPAL = _lib.ZMQ_GSSAPI_SERVICE_PRINCIPAL;
zmq.GSSAPI_PLAINTEXT = _lib.ZMQ_GSSAPI_PLAINTEXT;
zmq.HANDSHAKE_IVL = _lib.ZMQ_HANDSHAKE_IVL;
zmq.IDENTITY_FD = _lib.ZMQ_IDENTITY_FD;
zmq.SOCKS_PROXY = _lib.ZMQ_SOCKS_PROXY;
zmq.XPUB_NODROP = _lib.ZMQ_XPUB_NODROP;

-- socket类型
zmq.PAIR = _lib.ZMQ_PAIR;
zmq.PUB  = _lib.ZMQ_PUB;
zmq.SUB  = _lib.ZMQ_SUB;
zmq.REQ  = _lib.ZMQ_REQ;
zmq.REP  = _lib.ZMQ_REP;
zmq.DEALER = _lib.ZMQ_DEALER;
zmq.ROUTER = _lib.ZMQ_ROUTER;
zmq.PULL   = _lib.ZMQ_PULL;
zmq.PUSH   = _lib.ZMQ_PUSH;
zmq.XPUB   = _lib.ZMQ_XPUB;
zmq.XSUB   = _lib.ZMQ_XSUB;
zmq.STREAM = _lib.ZMQ_STREAM;


--monitor类型
zmq.EVENT_CONNECTED       = _lib.ZMQ_EVENT_CONNECTED      ;
zmq.EVENT_CONNECT_DELAYED = _lib.ZMQ_EVENT_CONNECT_DELAYED;
zmq.EVENT_CONNECT_RETRIED = _lib.ZMQ_EVENT_CONNECT_RETRIED;
zmq.EVENT_LISTENING       = _lib.ZMQ_EVENT_LISTENING      ;
zmq.EVENT_BIND_FAILED     = _lib.ZMQ_EVENT_BIND_FAILED    ;
zmq.EVENT_ACCEPTED        = _lib.ZMQ_EVENT_ACCEPTED       ;
zmq.EVENT_ACCEPT_FAILED   = _lib.ZMQ_EVENT_ACCEPT_FAILED  ;
zmq.EVENT_CLOSED          = _lib.ZMQ_EVENT_CLOSED         ;
zmq.EVENT_CLOSE_FAILED    = _lib.ZMQ_EVENT_CLOSE_FAILED   ;
zmq.EVENT_DISCONNECTED    = _lib.ZMQ_EVENT_DISCONNECTED   ;
zmq.EVENT_MONITOR_STOPPED = _lib.ZMQ_EVENT_MONITOR_STOPPED;
zmq.EVENT_ALL             = _lib.ZMQ_EVENT_ALL            ;


--------------------msg_t---------------------------------
local _msg = core.Object:extend();   --处理消息包

function _msg:initialize(d)	
	self._obj = ffi.new('zmq_msg_t');

	if d then
		_lib.zmq_msg_init(self._obj);
		self:setdata(d);
	else
		_lib.zmq_msg_init(self._obj);
	end
end

--设置数据
function _msg:setdata(d)
	_lib.zmq_msg_close(self._obj);
	_lib.zmq_msg_init_size(self._obj, #d);
	ffi.copy(_lib.zmq_msg_data(self._obj), d, #d);
end

-- 获取数据
function _msg:getdata()
	local ds = self:size();
	if ds <= 0 then return '' end;

	return ffi.string(_lib.zmq_msg_data(self._obj), _lib.zmq_msg_size(self._obj));
end

function _msg:size()
	return tonumber(_lib.zmq_msg_size(self._obj));
end

function _msg:close()
	return _lib.zmq_msg_close(self._obj);
end

function _msg:send(s, flag)
	return _lib.zmq_msg_send(self._obj, s, flag or 0);
end

function _msg:recv(s, flag)
	return _lib.zmq_msg_recv(self._obj, s, flag or 0);
end

function zmq.msg(d)
	return _msg:new(d);
end
----------------------------------------------------------
local sfd_t = 'uint32_t[1]';
if ffi.arch == 'x64' then
	sfd_t = 'uint64_t[1]';
end

local fd = ffi.new(sfd_t, 0);
local fs = ffi.new(sfd_t, 4);
local function socket_2_poll(s)
	fd[0] = 0;
	fs[0] = 4;
	local r = _lib.zmq_getsockopt(s, _lib.ZMQ_FD, fd, fs);
	if r == 0 then --suc
		local f = tonumber(fd[0]);
		return uv.new_poll(f);
	end
end
---- socket object ---------
local _sock = core.Emitter:extend();
function _sock:initialize(s, p )
	self._obj  = s;
	self._poll = p;

	self._poll:start('r', function(err, event)
		if err then
			self:emit('error', err);			
		else
			while true do				
				local d, r= self:recv(_lib.ZMQ_DONTWAIT);
				if d == nil then 
					break; 
				end
				self:emit('data', d);	
			end
		end
	end);
end



-- 设置opt
local function _setopt(ct)
	return function(sock, opt, val)			
		local t = ct .. '[1]';
		local v = ffi.new(t, val);
		local s = ffi.sizeof(t);
		return 0 == _lib.zmq_setsockopt(sock, opt, v, s);
	end
end

-- for char*
local function _setopt_str()
	return function(sock, opt, val)
		local s = #val;
		return 0 == _lib.zmq_setsockopt(sock, opt, val, s);
	end
end
-- 获得opt的函数包装
local function _getopt(ct)
	return function(sock, opt)			
		local t = ct .. '[1]';
		local v = ffi.new(t, 0);
		local s = ffi.new('size_t[1]',   ffi.sizeof(t));
		local r = _lib.zmq_getsockopt(sock, opt, v, s);
		if r == 0 then
			return tonumber(v[0]);
		end		
		return;
	end
end
local function _getopt_str()
	return function( sock, opt )
		local maxlen = 1024;
		local v = ffi.new('uint8_t[?]', maxlen);
		local s = ffi.new('size_t[1]',  maxlen);
		local r = _lib.zmq_getsockopt(sock, opt, v, s);
		if r == 0 then
			return ffi.string(v, s[0]);
		end
		return;
	end
end



local function _opt(ct)
	if ct == 'char*' then
		return {
			get = _getopt_str();
			set = _setopt_str();
		}
	end
	return {
		get = _getopt(ct);
		set = _setopt(ct);
	};
end

local opt_handle = 
{	
	[zmq.AFFINITY] 		= _opt('uint64_t');	
	[zmq.BACKLOG]		= _opt('int');
	[zmq.CONNECT_RID]	= _opt('char*');
	[zmq.CONFLATE]		= _opt('int');
	[zmq.CURVE_PUBLICKEY]=_opt('char*');
	[zmq.CURVE_SECRETKEY]=_opt('char*');
	[zmq.CURVE_SERVER]  = _opt('int');
	[zmq.CURVE_SERVERKEY]= _opt('char*');
	[zmq.GSSAPI_PLAINTEXT] = _opt('int');
	[zmq.GSSAPI_PRINCIPAL] = _opt('char*');
	[zmq.GSSAPI_SERVER]    = _opt('int');
	[zmq.GSSAPI_SERVICE_PRINCIPAL] = _opt('char*');
	[zmq.HANDSHAKE_IVL]    = _opt('int');
	[zmq.IDENTITY]	   = _opt('char*');
	[zmq.IMMEDIATE] 	   = _opt('int');	
	[zmq.IPV6]		  	   = _opt('int');
	[zmq.LINGER]		   = _opt('int');
	[zmq.MAXMSGSIZE]	   = _opt('int64_t');
	[zmq.MULTICAST_HOPS]   = _opt('int');
	[zmq.PLAIN_PASSWORD]   = _opt('char*');
	[zmq.PLAIN_SERVER]	   = _opt('int');
	[zmq.PLAIN_USERNAME]   = _opt('char*');
	[zmq.PROBE_ROUTER]	   = _opt('int');
	[zmq.RATE]			   = _opt('int');
	[zmq.RCVBUF]		   = _opt('int');
	[zmq.RCVHWM]		   = _opt('int');
	[zmq.RCVTIMEO]		   = _opt('int');
	[zmq.RECONNECT_IVL]	   = _opt('int');
	[zmq.RECONNECT_IVL_MAX]= _opt('int');
	[zmq.RECOVERY_IVL]	   = _opt('int');
	[zmq.REQ_CORRELATE]	   = _opt('int');
	[zmq.REQ_RELAXED]	   = _opt('int');
	[zmq.ROUTER_HANDOVER]  = _opt('int');
	[zmq.ROUTER_MANDATORY] = _opt('int');
	[zmq.ROUTER_RAW]	   = _opt('int');
	[zmq.SNDBUF]		   = _opt('int');
	[zmq.SNDHWM]		   = _opt('int');
	[zmq.SNDTIMEO]		   = _opt('int');
	[zmq.SUBSCRIBE]		   = _opt('char*');
	[zmq.TCP_ACCEPT_FILTER]= _opt('char*');
	[zmq.TCP_KEEPALIVE]		   = _opt('int');
	[zmq.TCP_KEEPALIVE_CNT]= _opt('int');
	[zmq.TCP_KEEPALIVE_IDLE]= _opt('int');
	[zmq.TCP_KEEPALIVE_INTVL]= _opt('int');
	[zmq.TOS]		   = _opt('int');
	[zmq.UNSUBSCRIBE]	= _opt('char*');
	[zmq.XPUB_VERBOSE]	   = _opt('int');
	[zmq.ZAP_DOMAIN]	   = _opt('char*');

	--only get
	[zmq.RCVMORE]		   = _opt('int');
};


--属性设置
function _sock:setopt( opt, val)
	local fs = opt_handle[opt] or {};
	local f  = fs.set;
	if f then
		return f(self._obj, opt, val);
	end
end


--获得属性
function _sock:getopt( opt )
	local fs = opt_handle[opt] or {};
	local f  = fs.get;
	if f then
		return f(self._obj, opt);
	end
end

--绑定地址
function _sock:bind(addr)
	return 0 == _lib.zmq_bind(self._obj, addr);
end

--连接地址
function _sock:connect(addr)
	return 0 == _lib.zmq_connect(self._obj, addr);
end

function _sock:disconnect(addr)
	return 0 == _lib.zmq_disconnect(self._obj, addr or '');
end
--收数据
--flag 可选zmq.DONTWAIT 
function _sock:recv(flag)
	local t = {};
	flag = flag or 0;
	while(true) do
		local m = zmq.msg();
		local r = m:recv(self._obj, flag);
		if r <= 0 then		
			m:close();
			return nil, r;
		end
		table.insert(t, m:getdata());
		m:close();

		if self:getopt(zmq.RCVMORE) ~= 1 then
			break;
		end
	end
	return t;
end

--发数据
--d 可以是string，也可以是table 
--flag zmq.DONTWAIT or zmq.SNDMORE 
function _sock:send(d, flag)
	flag = flag or 0;
	if type(d) == 'table' then --发送多个数据
		local m = zmq.msg();
		local f = bit.bor(flag, zmq.SNDMORE);
		local n = #d;
		for i=1,n - 1 do
			m:setdata(tostring(d[i]));
			m:send(self._obj, f);
		end
		m:setdata(d[n]);
		m:send(self._obj, flag);
		m:close();
	else
		local m = zmq.msg(d);
		local r = m:send(self._obj, flag);
		m:close();
		return r;
	end
end


--[[ ！！！！！！！！！！！！ it dont work ！！！！！！！！！！！！！！
local _monitor_id = 1;

--监控当前socket
--同时只能设置一个监控函数，如果多次调用，之前设置的监控函数会被取消
function _sock:monitor(events, f)
	self:monitor_close();

	if not self._monitor_id then
		local addr = string.format('inproc://socket_monitor_%d', _monitor_id);
		_monitor_id = _monitor_id + 1;

		
		if 0 ~= _lib.zmq_socket_monitor(self._obj, addr, events) then
			return nil;
		end
		self._monitor_id = addr;
	end

	local _ms  = zmq.socket(zmq.PAIR);
	_ms:on('data', function(d)
		f(d);
	end);

	self._monitor = _ms;
	return _ms;
end

--关闭监控
function _sock:monitor_close()
	if self._monitor then
		self._monitor:close();
	end
end
]]

--关闭socket
function _sock:close()
	self._poll:stop();
	_lib.zmq_close(self._obj);
end
-----------------------------------


-- 创建socket
-- t 需要创建的socket类型
function zmq.socket(t)
	local s   		  = _lib.zmq_socket(_ctx, t);	
	local p, e1, e2   = socket_2_poll(s);
	if p == nil then
		_lib.zmq_close(s);
		return nil, e1, e2;
	end

	return _sock:new(s, p);
end

function zmq.bind_socket(t, addr)
	local s, e1, e2 = zmq.socket(t);
	if not s then
		return nil, e1, e2;
	end
	s:bind(addr);
	return s;
end


--返回版本号
function zmq.version()
	local v1 = ffi.new('int[1]', 0);
	local v2 = ffi.new('int[1]', 0);	
	local v3 = ffi.new('int[1]', 0);

	_lib.zmq_version(v1, v2, v3);

	v1 = tonumber(v1[0]);
	v2 = tonumber(v2[0]);
	v3 = tonumber(v3[0]);
	return string.format('%d.%d.%d', v1, v2, v3), v1, v2, v3;
end

function zmq.close()
	_lib.zmq_ctx_term(ctx);
end
return zmq;
