#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Dancer::Plugin::ValidationClass' );
}

diag( "Testing Dancer::Plugin::ValidationClass $Dancer::Plugin::ValidationClass::VERSION, Perl $], $^X" );
