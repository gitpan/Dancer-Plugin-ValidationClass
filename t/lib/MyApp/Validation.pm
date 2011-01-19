package MyApp::Validation;
use Validation::Class;

field 'login' => {
    required => 1,
    filter   => 'strip'
};

field 'password' => {
    required => 1,
    filter   => 'strip'
};

1;