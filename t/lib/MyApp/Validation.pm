package MyApp::Validation;

use Validation::Class;
use base 'Validation::Class';

field 'login' => {
    required => 1,
    filter   => 'strip'
};

field 'password' => {
    required => 1,
    filter   => 'strip'
};

1;