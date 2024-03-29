# Write timeout.
use warnings;
use strict;
use EV::Stream::MatrixSSL::const;
BEGIN {
    *EV::Stream::MatrixSSL::const::TOHANDSHAKE = sub () { 0.1 };
}
use t::share;


@CheckPoint = (
    [ 'server', RESOLVED, undef             ], 'server: RESOLVED',
    [ 'server', CONNECTED, undef            ], 'server: CONNECTED',
    [ 'server', 0, 'ssl handshake timeout'  ], 'server: ssl handshake timeout',
);
plan tests => @CheckPoint/2;



my $srv_sock = tcp_server('127.0.0.1', 4444);
EV::Stream->new({
    host        => '127.0.0.1',
    port        => 4444,
    cb          => \&server,
    wait_for    => RESOLVED|CONNECTED|SENT,
    out_buf     => 'test',
    plugin      => [
        ssl         => EV::Stream::MatrixSSL::Server->new({
            crt         => 't/cert/testsrv.crt',
            key         => 't/cert/testsrv.key',
        }),
    ],
});

EV::loop;


sub server {
    my ($io, $e, $err) = @_;
    checkpoint($e, $err);
    EV::unloop if $err;
}

