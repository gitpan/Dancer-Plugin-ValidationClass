package MyApp::Validation;

use Validation::Class;

field 'login' => {
    required => 1,
    filters  => 'strip'
};

field 'password' => {
    required => 1,
    filters  => 'strip'
};

1;