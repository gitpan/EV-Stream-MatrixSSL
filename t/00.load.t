use Test::More tests => 3;

BEGIN {
use_ok( 'EV::Stream::MatrixSSL' );
use_ok( 'EV::Stream::MatrixSSL::Client' );
use_ok( 'EV::Stream::MatrixSSL::Server' );
}

diag( "Testing EV::Stream::MatrixSSL $EV::Stream::MatrixSSL::VERSION" );
