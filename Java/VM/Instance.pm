package Java::VM::Instance;

use Moose;

use Carp;
use overload '""' => \&stringify;

use Java::VM::WithFields;

extends 'Java::VM::WithFields';

has class => (
	is			=> 'ro',
	isa			=> 'Maybe[Java::VM::LoadedClass]',
	default		=> undef
);

has null => (
	is			=> 'ro',
	isa			=> 'Bool',
	default		=> 0
);

sub BUILD {
	my $self = shift;
	
	return if $self->null;
	
	$self->create_fields( $self->class->_get_all_instance_fields );
}

sub stringify {
	my $self = shift;
	
	if( ! $self->null ) {
		'instance of class ' . $self->class->class->get_name . '; vars: ' . join(', ', values %{$self->fields});
	} else {
		'null-instance';
	}
}

no Moose;

__PACKAGE__->meta->make_immutable;
