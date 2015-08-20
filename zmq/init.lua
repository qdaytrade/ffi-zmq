local ffi = require "ffi"
local bit = require "bit"
local uv  = require "uv"

local core = require('core');

local _lib = require('ffi-loader')(module.dir, "zmq.h")
local _ctx  =  _lib.zmq_ctx_new();
local zmq = {};

ffi.cdef[[
	void* memcpy(void* a, void* b, size_t);
]]
local _memcpy;
if ffi.os == 'Windows' then
	local rt = ffi.load('msvcrt');
	_memcpy = rt.memcpy;
else
	_memcpy = ffi.C.memcpy;
end

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
	_memcpy(_lib.zmq_msg_data(self._obj), ffi.cast('void*', d), math.min(#d, tonumber(_lib.zmq_msg_size(self._obj))));
end

-- 获取数据
function _msg:getdata()
	local ds = tonumber(_lib.zmq_msg_size(self._obj));
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
	self._obj = s;
	self._poll   = p;

	self._poll:start('r', function(err, event)
		if err then
			self:emit('error', err);			
		else
			while true do
				local d = self:recv(_lib.ZMQ_DONTWAIT);
				if d == nil then break; end
				self:emit('data', d);	
			end
			
		end
	end);
end

--绑定地址
function _sock:bind(addr)
	return 0 == _lib.zmq_bind(self._obj, addr);
end

--连接地址
function _sock:connect(addr)
	return 0 == _lib.zmq_connect(self._obj, addr);
end

--收数据
--flag 可选zmq.DONTWAIT 
function _sock:recv(flag)
	local m = _msg:new();
	local r = m:recv(self._obj, flag or 0);
	if r <= 0 then		
		m:close();
		return nil;
	end
	local d = m:getdata();
	m:close();
	return d;
end

--发数据
--d 可以是string，也可以是table 
--flag zmq.DONTWAIT or zmq.SNDMORE 
function _sock:send(d, flag)
	local m = _msg:new(d);
	local r = m:send(self._obj, flag or 0);
	m:close();
	return r;
end
-----------------------------------

zmq.DONTWAIT = _lib.ZMQ_DONTWAIT;
zmq.SNDMORE  = _lib.ZMQ_SNDMORE;

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
return zmq;
