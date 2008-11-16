# Write timeout.
use warnings;
use strict;
use EV::Stream::MatrixSSL::const;
BEGIN {
    *EV::Stream::MatrixSSL::const::TOHANDSHAKE = sub () { 0.1 };
}
use t::share;


@CheckPoint = (
    [ 'client', 0, 'ssl handshake timeout'  ], 'client: ssl handshake timeout',
);
plan tests => @CheckPoint/2;



my $srv_sock = tcp_server('127.0.0.1', 4444);
EV::Stream->new({
    fh          => tcp_client('127.0.0.1', 4444),
    cb          => \&client,
    wait_for    => RESOLVED|CONNECTED|SENT,
    out_buf     => 'test',
    plugin      => [
        ssl         => EV::Stream::MatrixSSL::Client->new({}),
    ],
});

EV::loop;


sub client {
    my ($io, $e, $err) = @_;
    checkpoint($e, $err);
    EV::unloop if $err;
}

