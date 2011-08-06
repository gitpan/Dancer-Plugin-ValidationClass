#!perl
package MyApp;

use Test::More tests => 7, import => ['!pass'];

BEGIN {
    use FindBin;
    use lib "$FindBin::Bin/lib";
    use_ok 'Dancer', ':syntax';
    use_ok 'Dancer::Plugin::ValidationClass';
}

my @settings    = <DATA>;
set plugins     => from_yaml("@settings");
set appname     => 'MyApp';

my $params = { login => 'admin', password => 'secret' };

ok 'MyApp::Validation' eq ref rules(params => $params), 'validation instantiated and returned';
ok 'admin' eq rules()->params->{login}, 'validation param login is set';
ok 'secret' eq rules()->params->{password}, 'validation param password is set';
ok rules()->validate, 'validation data validated';

rules()->params->{password} = '';

ok ! rules()->validate, 'validation data failed as expected';

__DATA__
ValidationClass:
  class: MyApp/Validation.pm
