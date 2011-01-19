#!perl
package MyApp;

use Test::More tests => 2, import => ['!pass'];

BEGIN {
    use FindBin;
    use lib "$FindBin::Bin/lib";
    use_ok 'Dancer::Plugin::ValidationClass';
    use_ok 'Dancer', ':syntax';
}

my @settings    = <DATA>;;
set plugins     => from_yaml("@settings");
set appname     => 'MyApp';

# ok  ! validate(), 'validate appears operational';
# ok  validation(), 'validation has been set and seems appears operational';

__DATA__
ValidationClass:
  class: MyApp/Validation.pm
