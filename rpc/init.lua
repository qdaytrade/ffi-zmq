local zmq = require('zmq');
local core= require('core');
local utils= require('utils');
local timer= require('timer');

local encode = require('msgpack').encode;
local decode = require('msgpack').decode;

local rpc_svr = core.Emitter:extend();

-- linkaddr bind listen addr
-- dispaddr send response addr
function rpc_svr:initialize(linkaddr, dispaddr)	
	self._sock = zmq.bind_socket(zmq.PULL, linkaddr,
															utils.bind(self._onData, self))
	self._sendsock = zmq.bind_socket(zmq.PUB, dispaddr);

	self._clients = {};
	self._links   = {};

	self._cid_index = 1;	--客户端ID记录
	self._cnt = 0;
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
	local cname = d[1];
	local req = decode(d[2]);

	self._cnt = self._cnt  + 1;
	if math.fmod(self._cnt, 1000)  == 0 then
		p(os.date(), 'call count->', self._cnt);
	end

--	p(os.date(), 'call->', cname,  req);
	local ctx = req.ctx;
	local p   = req.p;

	local fn = self[ctx.cmd];
	local res= nil;
	if fn then
		local e = {
			ctx = ctx;
			cname = cname;
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

	if res then
		self._sendsock:send({cname, encode(res)});
	end
end

--连接请求
--cbaddr   回拨地址
function rpc_svr:_sys_connect(cbaddr)
	p(os.date(), 'sys_connect->', cbaddr);
	local cid = string.format('c_%d', self._cid_index);
	self._cid_index = self._cid_index + 1;

	ctx.cid = cid;
	return cid;
end

exports.server = rpc_svr;

------------------ client class --------------------
local rpc_client = core.Emitter:extend();
function rpc_client:initialize(svraddr, resaddr, cname)
	self._sock   = zmq.socket(zmq.PUSH);
  self._resock = zmq.socket(zmq.SUB);	
	self._resock:on('data', utils.bind(self._onData, self))

	self._resock:connect(resaddr);
	self._resock:setopt(zmq.SUBSCRIBE, cname)

	self._sock:connect(svraddr);

	self._name = cname;
	self._rid = 1;
	self._callback = {};

	self:call('_sys_connect', function(cid)
		self._cid = cid;
		self:emit('connected')
	end)
end

function rpc_client:close()
	self._sock:close();
	self._resock:close();
end
function rpc_client:_onData(d)	
	local cname = d[1];
  if cname ~= self._name then
		p(os.date(), 'is not my data->', cname); 
	end
	local res = decode(d[2]);

	local ctx = res.ctx;
	local r   = res.r;

	--p('return ->', cname, res);
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
		rid = self._rid;
	};
	self._rid  = self._rid + 1;

	--self._sock:send({self._name, encode({ctx = ctx, p = arg})}, zmq.DONTWAIT);
	self._sock:send({self._name, encode({ctx = ctx, p = arg})});
end

exports.client = rpc_client;
