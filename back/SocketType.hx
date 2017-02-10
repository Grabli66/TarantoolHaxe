/**
    The socket has the indicated type, which specifies the communication semantics
**/
enum SocketType {
    /**
        Provides sequenced, reliable, two-way, connection-
        based byte streams.  An out-of-band data transmission
        mechanism may be supported.
    **/
    SOCK_STREAM;

    /**
        Supports datagrams (connectionless, unreliable
        messages of a fixed maximum length).
    **/
    SOCK_DGRAM;

    /**
        Provides a sequenced, reliable, two-way connection-
        based data transmission path for datagrams of fixed
        maximum length; a consumer is required to read an
        entire packet with each input system call.
    **/
    SOCK_SEQPACKET;

    /**
        Provides raw network protocol access.
    **/
    SOCK_RAW;

    /**
        Provides a reliable datagram layer that does not
        guarantee ordering.    
    **/
    SOCK_RDM;

    /**
        Obsolete and should not be used in new programs;
    **/
    SOCK_PACKET;
}