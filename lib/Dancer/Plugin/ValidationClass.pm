# ABSTRACT: Centralized Input Validation For Dancer

package Dancer::Plugin::ValidationClass;

use strict;
use warnings;
use Dancer ':syntax';
use Dancer::Plugin;
use Validation::Class qw/validation_schema/;

my $self = undef;


register validate => sub {
    my @args = @_;
    my $cfg  = plugin_setting;

    #find validation class
    my $class = my $path = $cfg->{class};
    $class = setting('appname') . '::Validation' unless $class;

    if ($class =~ /::/) {
        $path = "$class.pm";
        $path =~ s/::/\//g;
    }
    elsif ($class =~ /\.pm$/) {
        $path = $class;
        $class =~ s/\.pm$//;
        $class =~ s/\//::/;
    }

    {
        no warnings 'redefine';
        require $path unless defined $self;
        #*{$class . "::params"} = sub {
        #    my ($self, @params) = @_;
        #    if (@params) {
        #        my %params = @params == 1 ? %{$params[0]} : @params;
        #        $self->{params} = { %params };
        #        return $self->{params};
        #    }
        #    else {
        #        return $self->{params};
        #    }
        #};
    }

    $self = $class->new({ params });

    return $self->validate(@args);
};

register validation => sub {
    my @args = @_;
    my $cfg  = plugin_setting;

    $self = validation_schema @args if @args;
    return ref $self ? $self : undef;
};

register_plugin;

1;

__END__
=pod

=head1 NAME

Dancer::Plugin::ValidationClass - Centralized Input Validation For Dancer

=head1 VERSION

version 0.110190

=head1 SYNOPSIS

    use Dancer;
    use Dancer::Plugin::ValidationClass;

    post '/authenticate/:login' => sub {
        unless (validate 'login', 'password') {
            return validation->errors;
        }
    };

    dance;

=head1 DESCRIPTION

This plugin provides a convenient wrapper around the L<Validation::Class> module
for easy, reusable data validation for your Dancer applications. You don't even
need to configure it unless your environment isn't a typical one.

=head1 CONFIGURATION

Connection details will be optionally grabbed from your L<Dancer> config file.
For example: 

    plugins:
      ValidationClass:
        class: Foo::Bar
        
    or
    
    plugins:
      ValidationClass:
        class: lib/Foo/Bar.pm

If no configuration information is given, this plugin will attempt to use the
application's name, as set in the configuration file, and assume the class is
$AppName::Validation under the lib directory.

=head1 METHODS

=head2 validate

This method return true or false based on whether or not the user-input has passed
the validation rules.

    1 if validate 'login', 'password';
    1 if validate {
        login => 'users:login',
        passw => 'users:password'
    };

=head2 validation

This method returns the current Validation::Class instance if one exists.

    unless ( validate 'login', 'password' ) {
        return validation->errors;
    }

=head1 AUTHOR

Al Newkirk <awncorp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by awncorp.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

