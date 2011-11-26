# ABSTRACT: Centralized Input Validation For Dancer

package Dancer::Plugin::ValidationClass;

use strict;
use warnings;

use Dancer ':syntax';
use Dancer::Plugin;

our $VERSION = '0.113300'; # VERSION

our $Self;


# instance should only remained cached for the duration of the request
hook before => sub {
    $Dancer::Plugin::ValidationClass::Self = undef;
};

# register the keyword
register rules => sub {
    my @args = @_;
    my $cfg = plugin_setting || {};

    $Self = ref $Self ? $Self : instantiate( $cfg || {}, @args );

    return $Self;
};

# instantiation routine
sub instantiate {
    my ( $cfg, @args ) = @_;

    #find validation class
    my $class = my $path = $cfg->{class};
    $class = setting('appname') . '::Validation' unless $class;

    if ( $class =~ /::/ ) {
        $path = "$class.pm";
        $path =~ s/::/\//g;
    }
    elsif ( $class =~ /\.pm$/ ) {
        $path = $class;
        $class =~ s/\.pm$//;
        $class =~ s/\//::/;
    }

    {
        no warnings 'redefine';
        require $path unless defined $Self;
    }

    my $args = {@args};    # specified params supersedes frameworks
    $cfg->{params} = { params() } unless $args->{params};
    return $class->new( scalar keys %$args ? $args : $cfg );
}

register_plugin;

1;

__END__
=pod

=head1 NAME

Dancer::Plugin::ValidationClass - Centralized Input Validation For Dancer

=head1 VERSION

version 0.113300

=head1 SYNOPSIS

    use Dancer;
    use Dancer::Plugin::ValidationClass;

    post '/authenticate/:login' => sub {
        unless (rules->validate('login', 'password')) {
            return rules->errors->to_string;
        }
    };

    dance;

=head1 DESCRIPTION

This plugin provides a convenient wrapper around the L<Validation::Class> module
for easy, reusable data validation for your Dancer applications. You don't even
need to configure it unless your environment isn't a typical one.

=head1 ADVANCED SYNOPSIS

    use Dancer;
    use Dancer::Plugin::ValidationClass;

    post '/authenticate/:login' => sub {
        
        # validate everything
        unless (rules->validate()) {
            return rules->errors->to_string('<br/>');
        }
    };

    dance;

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

=head2 rules

This method returns the current Validation::Class instance if one exists.

    1 if rules->validate('login', 'password');
    1 if rules->validate({
        login => 'users:login',
        passw => 'users:password'
    });

    unless (rules->validate('login', 'password')) {
        return rules->error; # arrayref of errors
    }

=head1 AUTHOR

Al Newkirk <awncorp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by awncorp.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

