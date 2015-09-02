local zmq = require('zmq');
local core= require('core');
local utils= require('utils');
local timer= require('timer');

local encode = require('msgpack').encode;
local decode = require('msgpack').decode;

local rpc_svr = core.Emitter:extend();
function rpc_svr:initialize(addr)	
	self._sock = zmq.bind_socket(zmq.PULL, addr);
	self._sock:on('data', utils.bind(self._onData, self))

	self._clients = {};
	self._links   = {};

	self._cid_index = 1;	--客户端ID记录
end


-- 请求参数
-- {ctx = {}, p = {}}
-- 其中ctx是保留信息，即请求的上下文
--     p当前调用的参数
--  ctx中的数据可能有
--  cid  --  客户端ID
--  cmd  --  调用的方法名称
--  rid  --  请求的上下文ID
function rpc_svr:_onData(d)
	local req = decode(d[1]);

	--p(os.date(), 'call->', req);
	local ctx = req.ctx;
	local p   = req.p;

	local cs = self._clients[ctx.cid or ''];
	local fn = self[ctx.cmd];
	local res= nil;
	if fn then
		local e = {
			ctx = ctx;
			cs  = cs;
		};

		setfenv(fn, setmetatable(e, {__index = _G}));
		local ret = {fn(self, unpack(p))};
		ctx.ret = 0;
		res = {
			ctx = ctx;
			r   = ret;
		};	
	else
		ctx.ret = -1;
		res = {
			ctx = ctx;
		};
	end

	cs = cs or self._clients[ctx.cid or ''];
	if res and cs then
		cs:send(encode(res));
	end
end

--连接请求
--cbaddr   回拨地址
function rpc_svr:_sys_connect(cbaddr)
	p(os.date(), 'sys_connect->', cbaddr);
	local cid = string.format('c_%d', self._cid_index);
	self._cid_index = self._cid_index + 1;

	local s = self._links[cbaddr];
	if s == nil then
		s = zmq.socket(zmq.PUSH);
		self._links[cbaddr] = s;
		s:connect(cbaddr);
	else
		p('use old client socket');
	end

	self._clients[cid] = s;
	ctx.cid = cid;
	return cid;
end

exports.server = rpc_svr;

------------------ client class --------------------
local rpc_client = core.Emitter:extend();
function rpc_client:initialize(svraddr, bindaddr, cbaddr)
	self._sock = zmq.socket(zmq.PUSH, addr);
  self._listen = zmq.bind_socket(zmq.PULL, bindaddr);	
	self._listen:on('data', utils.bind(self._onData, self))

	self._sock:connect(svraddr);
	self._rid = 1;
	self._callback = {};

	self:call('_sys_connect', cbaddr, function(cid)
		p('get cid->', cid);
		self._cid = cid;
		self:emit('connected')
	end)
end

function rpc_client:_onData(d)
	local res = decode(d[1]);

	local ctx = res.ctx;
	local r   = res.r;

	--p('return ->', res);
	if ctx.ret == 0 then 	--suc
		local f = self._callback[ctx.rid or 0];
		if f then
			f(unpack(r));
		end
	end
end

--远程调用
function rpc_client:call(name, ...)
	local n   = select('#', ...);
	local arg = {...};
	if type(arg[n]) == 'function' then
		self._callback[self._rid] = arg[n];
		table.remove(arg, n);
  end

	local ctx = 
	{
		cmd = name;
		cid = self._cid;
		rid = self._rid;
	};
	self._rid  = self._rid + 1;

	self._sock:send(encode({ctx = ctx, p = arg}));
end

exports.client = rpc_client;
