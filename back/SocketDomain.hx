/**
    The domain argument specifies a communication domain; this selects
    the protocol family which will be used for communication.
**/
enum SocketDomain {
    /**
        Local communication
    **/
    AF_UNIX; 
    AF_LOCAL;

    /**
        IPv4 Internet protocols
    **/
    AF_INET;

    /**
        IPv6 Internet protocols
    **/
    AF_INET6;            

    /**
        IPX - Novell protocols
    **/
    AF_IPX;

    /**
        Kernel user interface device
    **/
    AF_NETLINK;
    
    /**
        ITU-T X.25 / ISO-8208 protocol
    **/
    AF_X25;
    
    /**
        Amateur radio AX.25 protocol
    **/
    AF_AX25;
    
    /**
        Access to raw ATM PVCs
    **/
    AF_ATMPVC;
    
    /**
        AppleTalk
    **/
    AF_APPLETALK;
    
    /**
        Low level packet interface
    **/
    AF_PACKET;
    
    /**
        Interface to kernel crypto API
    **/
    AF_ALG;
}