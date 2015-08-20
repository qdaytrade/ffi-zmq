

/*  Version macros for compile-time API version detection                     */
static const int ZMQ_VERSION_MAJOR = 4;
static const int ZMQ_VERSION_MINOR = 1;
static const int ZMQ_VERSION_PATCH = 0;
static const int ZMQ_VERSION = 40100;



/******************************************************************************/
/*  0MQ errors.                                                               */
/******************************************************************************/

/*  A number random enough not to collide with different errno ranges on      */
/*  different OSes. The assumption is that error_t is at least 32-bit type.   */
static const int ZMQ_HAUSNUMERO = 156384712;

/*  On Windows platform some of the standard POSIX errnos are not defined.    */
/*
#ifndef ENOTSUP
#define ENOTSUP (ZMQ_HAUSNUMERO + 1)
#endif
#ifndef EPROTONOSUPPORT
#define EPROTONOSUPPORT (ZMQ_HAUSNUMERO + 2)
#endif
#ifndef ENOBUFS
#define ENOBUFS (ZMQ_HAUSNUMERO + 3)
#endif
#ifndef ENETDOWN
#define ENETDOWN (ZMQ_HAUSNUMERO + 4)
#endif
#ifndef EADDRINUSE
#define EADDRINUSE (ZMQ_HAUSNUMERO + 5)
#endif
#ifndef EADDRNOTAVAIL
#define EADDRNOTAVAIL (ZMQ_HAUSNUMERO + 6)
#endif
#ifndef ECONNREFUSED
#define ECONNREFUSED (ZMQ_HAUSNUMERO + 7)
#endif
#ifndef EINPROGRESS
#define EINPROGRESS (ZMQ_HAUSNUMERO + 8)
#endif
#ifndef ENOTSOCK
#define ENOTSOCK (ZMQ_HAUSNUMERO + 9)
#endif
#ifndef EMSGSIZE
#define EMSGSIZE (ZMQ_HAUSNUMERO + 10)
#endif
#ifndef EAFNOSUPPORT
#define EAFNOSUPPORT (ZMQ_HAUSNUMERO + 11)
#endif
#ifndef ENETUNREACH
#define ENETUNREACH (ZMQ_HAUSNUMERO + 12)
#endif
#ifndef ECONNABORTED
#define ECONNABORTED (ZMQ_HAUSNUMERO + 13)
#endif
#ifndef ECONNRESET
#define ECONNRESET (ZMQ_HAUSNUMERO + 14)
#endif
#ifndef ENOTCONN
#define ENOTCONN (ZMQ_HAUSNUMERO + 15)
#endif
#ifndef ETIMEDOUT
#define ETIMEDOUT (ZMQ_HAUSNUMERO + 16)
#endif
#ifndef EHOSTUNREACH
#define EHOSTUNREACH (ZMQ_HAUSNUMERO + 17)
#endif
#ifndef ENETRESET
#define ENETRESET (ZMQ_HAUSNUMERO + 18)
#endif

#define EFSM (ZMQ_HAUSNUMERO + 51)
#define ENOCOMPATPROTO (ZMQ_HAUSNUMERO + 52)
#define ETERM (ZMQ_HAUSNUMERO + 53)
#define EMTHREAD (ZMQ_HAUSNUMERO + 54)

*/
/*  This function retrieves the errno as it is known to 0MQ library. The goal */
/*  of this function is to make the code 100% portable, including where 0MQ   */
/*  compiled with certain CRT library (on Windows) is linked to an            */
/*  application that uses different CRT library.                              */
 int zmq_errno (void);

/*  Resolves system errors and 0MQ errors to human-readable string.           */
 const char *zmq_strerror (int errnum);

/*  Run-time API version detection                                            */
 void zmq_version (int *major, int *minor, int *patch);

/******************************************************************************/
/*  0MQ infrastructure (a.k.a. context) initialisation & termination.         */
/******************************************************************************/

/*  New API                                                                   */
/*  Context options                                                           */
static const int ZMQ_IO_THREADS  = 1;
static const int ZMQ_MAX_SOCKETS = 2;
static const int ZMQ_SOCKET_LIMIT= 3;
static const int ZMQ_THREAD_PRIORITY =3;
static const int ZMQ_THREAD_SCHED_POLICY =4;

/*  Default for new contexts                                                  */
static const int ZMQ_IO_THREADS_DFLT  =1;
static const int ZMQ_MAX_SOCKETS_DFLT =1023;
static const int ZMQ_THREAD_PRIORITY_DFLT =-1;
static const int ZMQ_THREAD_SCHED_POLICY_DFLT =-1;

 void *zmq_ctx_new (void);
 int zmq_ctx_term (void *context);
 int zmq_ctx_shutdown (void *ctx_);
 int zmq_ctx_set (void *context, int option, int optval);
 int zmq_ctx_get (void *context, int option);


typedef struct zmq_msg_t {unsigned char _ [64];} zmq_msg_t;

typedef void (zmq_free_fn) (void *data, void *hint);

 int zmq_msg_init (zmq_msg_t *msg);
 int zmq_msg_init_size (zmq_msg_t *msg, size_t size);
 int zmq_msg_init_data (zmq_msg_t *msg, void *data,
    size_t size, zmq_free_fn *ffn, void *hint);
 int zmq_msg_send (zmq_msg_t *msg, void *s, int flags);
 int zmq_msg_recv (zmq_msg_t *msg, void *s, int flags);
 int zmq_msg_close (zmq_msg_t *msg);
 int zmq_msg_move (zmq_msg_t *dest, zmq_msg_t *src);
 int zmq_msg_copy (zmq_msg_t *dest, zmq_msg_t *src);
 void *zmq_msg_data (zmq_msg_t *msg);
 size_t zmq_msg_size (zmq_msg_t *msg);
 int zmq_msg_more (zmq_msg_t *msg);
 int zmq_msg_get (zmq_msg_t *msg, int property);
 int zmq_msg_set (zmq_msg_t *msg, int property, int optval);
 const char *zmq_msg_gets (zmq_msg_t *msg, const char *property);


static const int ZMQ_PAIR =0;
static const int ZMQ_PUB =1;
static const int ZMQ_SUB =2;
static const int ZMQ_REQ =3;
static const int ZMQ_REP =4;
static const int ZMQ_DEALER =5;
static const int ZMQ_ROUTER =6;
static const int ZMQ_PULL =7;
static const int ZMQ_PUSH =8;
static const int ZMQ_XPUB =9;
static const int ZMQ_XSUB =10;
static const int ZMQ_STREAM =11;

/*  Deprecated aliases                                                        */
static const int ZMQ_XREQ = 5;
static const int ZMQ_XREP = 6;

/*  Socket options.                                                           */
static const int ZMQ_AFFINITY =4;
static const int ZMQ_IDENTITY =5;
static const int ZMQ_SUBSCRIBE =6;
static const int ZMQ_UNSUBSCRIBE =7;
static const int ZMQ_RATE =8;
static const int ZMQ_RECOVERY_IVL =9;
static const int ZMQ_SNDBUF =11;
static const int ZMQ_RCVBUF =12;
static const int ZMQ_RCVMORE =13;
static const int ZMQ_FD =14;
static const int ZMQ_EVENTS =15;
static const int ZMQ_TYPE =16;
static const int ZMQ_LINGER =17;
static const int ZMQ_RECONNECT_IVL =18;
static const int ZMQ_BACKLOG =19;
static const int ZMQ_RECONNECT_IVL_MAX =21;
static const int ZMQ_MAXMSGSIZE =22;
static const int ZMQ_SNDHWM =23;
static const int ZMQ_RCVHWM =24;
static const int ZMQ_MULTICAST_HOPS =25;
static const int ZMQ_RCVTIMEO =27;
static const int ZMQ_SNDTIMEO =28;
static const int ZMQ_LAST_ENDPOINT =32;
static const int ZMQ_ROUTER_MANDATORY =33;
static const int ZMQ_TCP_KEEPALIVE =34;
static const int ZMQ_TCP_KEEPALIVE_CNT =35;
static const int ZMQ_TCP_KEEPALIVE_IDLE =36;
static const int ZMQ_TCP_KEEPALIVE_INTVL =37;
static const int ZMQ_TCP_ACCEPT_FILTER =38;
static const int ZMQ_IMMEDIATE =39;
static const int ZMQ_XPUB_VERBOSE =40;
static const int ZMQ_ROUTER_RAW =41;
static const int ZMQ_IPV6 =42;
static const int ZMQ_MECHANISM =43;
static const int ZMQ_PLAIN_SERVER =44;
static const int ZMQ_PLAIN_USERNAME =45;
static const int ZMQ_PLAIN_PASSWORD =46;
static const int ZMQ_CURVE_SERVER =47;
static const int ZMQ_CURVE_PUBLICKEY =48;
static const int ZMQ_CURVE_SECRETKEY =49;
static const int ZMQ_CURVE_SERVERKEY =50;
static const int ZMQ_PROBE_ROUTER =51;
static const int ZMQ_REQ_CORRELATE =52;
static const int ZMQ_REQ_RELAXED =53;
static const int ZMQ_CONFLATE =54;
static const int ZMQ_ZAP_DOMAIN =55;
static const int ZMQ_ROUTER_HANDOVER =56;
static const int ZMQ_TOS =57;
static const int ZMQ_IPC_FILTER_PID =58;
static const int ZMQ_IPC_FILTER_UID =59;
static const int ZMQ_IPC_FILTER_GID =60;
static const int ZMQ_CONNECT_RID =61 ;
static const int ZMQ_GSSAPI_SERVER =62;
static const int ZMQ_GSSAPI_PRINCIPAL =63;
static const int ZMQ_GSSAPI_SERVICE_PRINCIPAL =64;
static const int ZMQ_GSSAPI_PLAINTEXT =65;
static const int ZMQ_HANDSHAKE_IVL =66;
static const int ZMQ_IDENTITY_FD =67;
static const int ZMQ_SOCKS_PROXY =68;
static const int ZMQ_XPUB_NODROP =69;

/*  Message options                                                           */
static const int ZMQ_MORE = 1;
static const int ZMQ_SRCFD = 2;
static const int ZMQ_SHARED =3;

/*  Send/recv options.                                                        */
static const int ZMQ_DONTWAIT =1;
static const int ZMQ_SNDMORE =2;

/*  Security mechanisms                                                       */
static const int ZMQ_NULL =0;
static const int ZMQ_PLAIN =1;
static const int ZMQ_CURVE =2;
static const int ZMQ_GSSAPI =3;

/*  Deprecated options and aliases                                            */
static const int ZMQ_IPV4ONLY  =              31;
static const int ZMQ_DELAY_ATTACH_ON_CONNECT = 39;
static const int ZMQ_NOBLOCK                 = 1;
static const int ZMQ_FAIL_UNROUTABLE         = 33;
static const int ZMQ_ROUTER_BEHAVIOR         = 33;


static const int ZMQ_EVENT_CONNECTED         =0x0001;
static const int ZMQ_EVENT_CONNECT_DELAYED   =0x0002;
static const int ZMQ_EVENT_CONNECT_RETRIED   =0x0004;
static const int ZMQ_EVENT_LISTENING         =0x0008;
static const int ZMQ_EVENT_BIND_FAILED       =0x0010;
static const int ZMQ_EVENT_ACCEPTED          =0x0020;
static const int ZMQ_EVENT_ACCEPT_FAILED     =0x0040;
static const int ZMQ_EVENT_CLOSED            =0x0080;
static const int ZMQ_EVENT_CLOSE_FAILED      =0x0100;
static const int ZMQ_EVENT_DISCONNECTED      =0x0200;
static const int ZMQ_EVENT_MONITOR_STOPPED   =0x0400;
static const int ZMQ_EVENT_ALL               =0xFFFF;

 void *zmq_socket (void *, int type);
 int zmq_close (void *s);
 int zmq_setsockopt (void *s, int option, const void *optval,
    size_t optvallen);
 int zmq_getsockopt (void *s, int option, void *optval,
    size_t *optvallen);
 int zmq_bind (void *s, const char *addr);
 int zmq_connect (void *s, const char *addr);
 int zmq_unbind (void *s, const char *addr);
 int zmq_disconnect (void *s, const char *addr);
 int zmq_send (void *s, const void *buf, size_t len, int flags);
 int zmq_send_const (void *s, const void *buf, size_t len, int flags);
 int zmq_recv (void *s, void *buf, size_t len, int flags);
 int zmq_socket_monitor (void *s, const char *addr, int events);


/******************************************************************************/
/*  I/O multiplexing.                                                         */
/******************************************************************************/

static const int ZMQ_POLLIN =1;
static const int ZMQ_POLLOUT =2;
static const int ZMQ_POLLERR =4;

typedef struct zmq_pollitem_t
{
    void *socket;
    int fd;
    short events;
    short revents;
} zmq_pollitem_t;

static const int ZMQ_POLLITEMS_DFLT =16;

 int zmq_poll (zmq_pollitem_t *items, int nitems, long timeout);

/******************************************************************************/
/*  Message proxying                                                          */
/******************************************************************************/

 int zmq_proxy (void *frontend, void *backend, void *capture);
 int zmq_proxy_steerable (void *frontend, void *backend, void *capture, void *control);

/******************************************************************************/
/*  Probe library capabilities                                                */
/******************************************************************************/

static const int ZMQ_HAS_CAPABILITIES =1;
 int zmq_has (const char *capability);

/*  Deprecated aliases */
static const int ZMQ_STREAMER =1;
static const int ZMQ_FORWARDER= 2;
static const int ZMQ_QUEUE =3;

/*  Deprecated methods */
 int zmq_device (int type, void *frontend, void *backend);
 int zmq_sendmsg (void *s, zmq_msg_t *msg, int flags);
 int zmq_recvmsg (void *s, zmq_msg_t *msg, int flags);


/******************************************************************************/
/*  Encryption functions                                                      */
/******************************************************************************/

/*  Encode data with Z85 encoding. Returns encoded data                       */
 char *zmq_z85_encode (char *dest, const uint8_t *data, size_t size);

/*  Decode data with Z85 encoding. Returns decoded data                       */
 uint8_t *zmq_z85_decode (uint8_t *dest, const char *string);

/*  Generate z85-encoded public and private keypair with libsodium.           */
/*  Returns 0 on success.                                                     */
 int zmq_curve_keypair (char *z85_public_key, char *z85_secret_key);


/******************************************************************************/
/*  These functions are not documented by man pages -- use at your own risk.  */
/*  If you need these to be part of the formal ZMQ API, then (a) write a man  */
/*  page, and (b) write a test case in tests.                                 */
/******************************************************************************/

struct iovec;

 int zmq_sendiov (void *s, struct iovec *iov, size_t count, int flags);
 int zmq_recviov (void *s, struct iovec *iov, size_t *count, int flags);

/*  Helper functions are used by perf tests so that they don't have to care   */
/*  about minutiae of time-related functions on different OS platforms.       */

/*  Starts the stopwatch. Returns the handle to the watch.                    */
 void *zmq_stopwatch_start (void);

/*  Stops the stopwatch. Returns the number of microseconds elapsed since     */
/*  the stopwatch was started.                                                */
 unsigned long zmq_stopwatch_stop (void *watch_);

/*  Sleeps for specified number of seconds.                                   */
 void zmq_sleep (int seconds_);

typedef void (zmq_thread_fn) (void*);

/* Start a thread. Returns a handle to the thread.                            */
 void *zmq_threadstart (zmq_thread_fn* func, void* arg);

/* Wait for thread to complete then free up resources.                        */
 void zmq_threadclose (void* thread);

